import 'package:edq/screens/detailCart.dart';
import 'package:edq/shared/constants.dart';
import 'package:edq/widgets/myMessage.dart';
import 'package:edq/widgets/mySpinKits.dart';
import 'package:edq/widgets/singleCards.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CartOrderScreen extends StatefulWidget {
  final String agentCode;
  final List userDatabase;
  final List customerData;
  CartOrderScreen({this.agentCode, this.userDatabase, this.customerData});
  @override
  _CartOrderScreenState createState() => _CartOrderScreenState();
}

class _CartOrderScreenState extends State<CartOrderScreen> {
  DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
  var cartData;
  var filterStatusCart;
  var productData;
  String _getCustomerContact(String cName) {
    String cContact;

    for (int i = 0; i < widget.customerData.length; i++) {
      if (widget.customerData[i]['CustName'] == cName) {
        cContact = widget.customerData[i]['CustMob'];
        if (cContact == null) {
          cContact = widget.customerData[i]['CustTel'];
        }
      }
    }
    if (cContact == null) {
      cContact = widget.userDatabase[0]['AgentContact'];
    }

    return cContact;
  }

  String _getCustomerRep(String cName) {
    String cRep;
    for (int i = 0; i < widget.customerData.length; i++) {
      if (widget.customerData[i]['CustName'] == cName) {
        cRep = widget.customerData[i]['CustCont'];
      }
    }
    if (cRep == null) {
      cRep = widget.userDatabase[0]['AgentEmail'];
    }
    return cRep;
  }

  int _getTotalItems(List filterList, int index) {
    int items = 0;
    for (int i = 0;
        i < filterList[index][filterList[index]['OrderNo']].length;
        i++) {
      items++;
      //get total quantity items in a cart
      // items += filterList[index][filterList[index]['OrderNo']][i]['Quantity'];
    }

    return items;
  }

  List _buildFilteredOrderCard(String filter1, String filter2) {
    int len = 0;
    //First determine the length of the filtered data
    for (int i = 0; i < cartData.length; i++) {
      if (cartData[i]['AgentCode'] == widget.agentCode &&
          cartData[i]['Status'] == filter2) {
        len++;
      }
    }
    //Second use the length of filtered data
    var filterOrder = new List.filled(len, []);

    //Third is Filter the not submitted cart in specific agent
    int x = 0;
    for (int i = 0; i < cartData.length; i++) {
      if (cartData[i]['AgentCode'] == widget.agentCode &&
          cartData[i]['Status'] == filter2) {
        filterOrder[x++].add(cartData[i]);
      }
    }
    var orderByLatest = new List.filled(len, []);
    //Fourth is order the cart by latest date
    for (int i = 0; i < len; i++) {
      orderByLatest[i].add(filterOrder[0][len - 1 - i]);
    }
    return orderByLatest;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: customColor[10],
        centerTitle: false,
        title: Text(
          'Carts',
          style: appBar,
        ),
      ),
      body: StreamBuilder(
        stream: _dbRef
            .child('Cart')
            // .orderByChild('AgentCode')
            // .equalTo(widget.agentCode)
            .onValue,
        builder: (context, cartSnapshot) {
          if (cartSnapshot.hasData &&
              !cartSnapshot.hasError &&
              cartSnapshot.data.snapshot.value != null) {
            cartData = cartSnapshot.data.snapshot.value;
          } else {
            return MySpinKitFadingCube();
          }
          filterStatusCart = _buildFilteredOrderCard(widget.agentCode, 'Cart');
          return StreamBuilder(
              stream: _dbRef.child('Products').onValue,
              builder: (context, productsSnapshot) {
                if (productsSnapshot.hasData &&
                    !productsSnapshot.hasError &&
                    productsSnapshot.data.snapshot.value != null) {
                  productData = productsSnapshot.data.snapshot.value;
                } else {
                  return MySpinKitFadingCube();
                }
                return Container(
                  padding: EdgeInsets.only(top: 5.0),
                  color: customColor[20],
                  child: filterStatusCart.length != 0
                      ? GridView.builder(
                          itemCount: filterStatusCart[0].length,
                          itemBuilder: (ctx, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => CartItem(
                                    orderNo: filterStatusCart[0][index]
                                        ['OrderNo'],
                                    clientName: filterStatusCart[0][index]
                                        ['Customer'],
                                    clientEmail: _getCustomerRep(
                                        filterStatusCart[0][index]['Customer']),
                                    clientContact: _getCustomerContact(
                                        filterStatusCart[0][index]['Customer']),
                                    address: filterStatusCart[0][index]
                                            ['DeliveryAdd']
                                        .toString(),
                                    agentCode: widget.agentCode,
                                    customerData: widget.customerData,
                                    userDatabase: widget.userDatabase,
                                    productData: productData,
                                  ),
                                ),
                              );
                            },
                            child: SingleCart(
                              clientName: filterStatusCart[0][index]
                                  ['Customer'],
                              cleintContact: _getCustomerContact(
                                  filterStatusCart[0][index]['Customer']),
                              address: filterStatusCart[0][index]['DeliveryAdd']
                                  .toString(),
                              totalQuantity: filterStatusCart[0][index][
                                          filterStatusCart[0][index]['OrderNo']
                                              .toString()] !=
                                      null
                                  ? _getTotalItems(filterStatusCart[0], index)
                                  : 0,
                              uniqueProduct: filterStatusCart[0][index][
                                          filterStatusCart[0][index]['OrderNo']
                                              .toString()] !=
                                      null
                                  ? filterStatusCart[0][index][
                                          filterStatusCart[0][index]['OrderNo']
                                              .toString()]
                                      .length
                                  : 0,
                              total: filterStatusCart[0][index]['Total']
                                  .toDouble(),
                            ),
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.9,
                            crossAxisCount: 1,
                          ),
                        )
                      : NoDataFound(name: 'No Cart Found'),
                );
              });
        },
      ),
    );
  }
}
