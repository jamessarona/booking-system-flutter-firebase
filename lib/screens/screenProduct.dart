import 'package:edq/screens/screenAccount.dart';
import 'package:edq/screens/screenCart.dart';
import 'package:edq/screens/detaiItem.dart';
import 'package:edq/screens/searchScreen.dart';
import 'package:edq/shared/constants.dart';
import 'package:edq/widgets/mySpinKits.dart';
import 'package:edq/widgets/mybuttons.dart';
import 'package:edq/widgets/singleCards.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  final String agentCode;
  final String orderNo;
  final List userDatabase;
  final List customerData;
  ProductList(
      {this.agentCode, this.orderNo, this.userDatabase, this.customerData});
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  var products;
  var carts;
  var filterCarts;
  Size screenSize;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  // void _checkDuplicate() {
  //   int xx = 0;
  //   for (int i = 0; i < products.length; i++) {
  //     for (int x = i; x < products.length; x++) {
  //       if (x != i) {
  //         if (products[i]['ItemCode'] == products[x]['ItemCode']) {
  //           print('$i : $x = ${products[i]['ItemCode']}');
  //           xx++;
  //         }
  //       }
  //     }
  //   }
  //   print(xx);
  // }

  //Filter Carts by Agent
  List _filterCarts(List list) {
    int len = 0;

    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i]['AgentCode'] == widget.agentCode &&
            list[i]['Status'] == 'Cart') {
          len++;
        }
      }
      if (len != 0) {
        var newList = new List.filled(len, []);
        int x = 0;
        for (int i = 0; i < list.length; i++) {
          if (list[i]['AgentCode'] == widget.agentCode &&
              list[i]['Status'] == 'Cart') {
            newList[x++].add(list[i]);
          }
        }
        return newList;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: customColor[10],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => Account(),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Products",
              style: appBar,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
              size: 30.0,
            ),
            onPressed: () {
              // showSearch(context: context, delegate: SearchScreen());
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => SearchScreen(
                    agentCode: widget.agentCode,
                    orderNo: widget.orderNo,
                    products: products,
                  ),
                ),
              );
            },
          ),
          StreamBuilder(
              stream: _dbRef.child('Cart').onValue,
              builder: (context, cartSnapshot) {
                if (cartSnapshot.hasData &&
                    !cartSnapshot.hasError &&
                    cartSnapshot.data.snapshot.value != null) {
                  carts = cartSnapshot.data.snapshot.value;
                } else {
                  return MyCartBadgeButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => CartOrderScreen(
                            agentCode: widget.agentCode,
                            userDatabase: widget.userDatabase,
                            customerData: widget.customerData,
                          ),
                        ),
                      );
                    },
                    quantity: 0,
                  );
                }
                filterCarts = _filterCarts(carts);
                return MyCartBadgeButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => CartOrderScreen(
                          agentCode: widget.agentCode,
                          userDatabase: widget.userDatabase,
                          customerData: widget.customerData,
                        ),
                      ),
                    );
                  },
                  quantity: filterCarts != null ? filterCarts[0].length : 0,
                );
              }),
        ],
      ),
      body: StreamBuilder(
        stream: _dbRef.child('Products').orderByChild('ItemDesc').onValue,
        builder: (context, productsSnapshot) {
          if (productsSnapshot.hasData &&
              !productsSnapshot.hasError &&
              productsSnapshot.data.snapshot.value != null) {
            products = productsSnapshot.data.snapshot.value;
          } else {
            return MySpinKitFadingCube();
          }
          // _checkDuplicate();
          //   print(_getNumberOfExistingCart());

          return Container(
            padding: EdgeInsets.only(top: 5.0),
            color: customColor[20],
            child: GridView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => DetailScreen(
                        brand: products[index]['Brand'],
                        category: products[index]['Category'],
                        itemCode: products[index]['ItemCode'].toString(),
                        itemDesc: products[index]['ItemDesc'],
                        partNo: products[index]['PartNo'],
                        price: products[index]['Price'].toString(),
                        unit: products[index]['Unit'],
                        image: products[index]['Image'],
                        orderNo: widget.orderNo,
                      ),
                    ),
                  );
                },
                child: SingleItem(
                  category: products[index]['Category'],
                  itemDesc: products[index]['ItemDesc'],
                  image: products[index]['Image'],
                ),
              ),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //For No Image
                // mainAxisSpacing: 0,
                // childAspectRatio: 5,
                // crossAxisCount: 1,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
                crossAxisCount: 2,
              ),
            ),
          );
        },
      ),
    );
  }
}
