import 'package:edq/screens/detailOrder.dart';
import 'package:edq/shared/constants.dart';
import 'package:edq/widgets/myMessage.dart';
import 'package:edq/widgets/mySpinKits.dart';
import 'package:edq/widgets/mybuttons.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CancelledOrderScreen extends StatefulWidget {
  final String agentCode;
  final String agentContact;
  final String agentEmail;
  final List customerData;
  CancelledOrderScreen(
      {this.agentCode, this.agentContact, this.agentEmail, this.customerData});
  @override
  _CancelledOrderScreenState createState() => _CancelledOrderScreenState();
}

class _CancelledOrderScreenState extends State<CancelledOrderScreen> {
  DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  var salesOrderData;
  var filterAll;
  var filterCancelled;
  Size screenSize;
  Widget _buildOrderCard(
      int index,
      String orderNo,
      String date,
      String customer,
      String address,
      String contactNumber,
      String totalItems,
      String orderStatus,
      String totalPrice) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => DetailOrder(
                      orderNo: orderNo,
                      isEdit: false,
                      agentCode: widget.agentCode,
                      agentContact: widget.agentContact,
                      agentEmail: widget.agentEmail,
                      customerData: widget.customerData,
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderCardTitle(orderNo, date),
                  _buildOrderCardBody(customer, address, contactNumber,
                      totalItems, orderStatus, totalPrice),
                ],
              ),
            ),
            _buildOrderCardFooter(index, orderNo, orderStatus, orderNo),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCardTitle(String orderNo, String date) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ID: $orderNo',
            style: appBar.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            'Place on  $date',
            style: appBar.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCardBody(
      String customer,
      String address,
      String contactNumber,
      String totalItems,
      String orderStatus,
      String totalPrice) {
    return Container(
      height: screenSize.height * .14,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1.0,
            color: Colors.black,
          ),
          bottom: BorderSide(
            width: 1.0,
            color: Colors.black,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: screenSize.width * .64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage(
                      "assets/client.png",
                    ),
                    height: 200,
                  ),
                  Container(width: screenSize.width * .025),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: screenSize.width * .38,
                            height: screenSize.height * .05,
                            child: Text(
                                customer.toLowerCase().capitalizeFirstofEach,
                                style: appBar.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Container(
                            width: screenSize.width * .38,
                            child: Text(contactNumber,
                                style: appBar.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Container(
                            width: screenSize.width * .38,
                            height: screenSize.height * .03,
                            child: Text(
                                address.toLowerCase().capitalizeFirstofEach,
                                style: appBar.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      Text(
                        'No. of Items $totalItems',
                        style: appBar.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: screenSize.width * .27,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyButtonOrderStatus(
                    onPressed: () {},
                    name: orderStatus,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: screenSize.height * .038,
                        child: Text(
                          'Total:',
                          style: bodyText.copyWith(fontSize: 12),
                        ),
                      ),
                      Container(
                        height: screenSize.height * .038,
                        width: screenSize.width * .18,
                        child: Text(
                          '₱${double.tryParse(totalPrice).toStringAsFixed(2)}',
                          style: roboto.copyWith(
                            color: customColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCardFooter(
    int index,
    String filter,
    String orderStatus,
    String orderNo,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: screenSize.width * .22,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IgnorePointer(
                ignoring: orderStatus == 'Approved' ? true : false,
                child: MyButtonOrders(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => DetailOrder(
                          orderNo: orderNo,
                          isEdit: true,
                          agentCode: widget.agentCode,
                          agentContact: widget.agentContact,
                          agentEmail: widget.agentEmail,
                          customerData: widget.customerData,
                        ),
                      ),
                    );
                  },
                  name: 'Edit',
                  color: orderStatus == 'Approved' ? Colors.grey : Colors.green,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  String _getContactPerson(int index, String filter, List filterList) {
    for (int i = 0; i < widget.customerData.length; i++) {
      if (widget.customerData[i]['CustName'] == filterList[index]['Customer']) {
        return widget.customerData[i]['CustAdd'];
      }
    }
    return widget.agentEmail;
  }

  String _getContactNumber(int index, String filter, List filterList) {
    for (int i = 0; i < widget.customerData.length; i++) {
      if (widget.customerData[i]['CustName'] == filterList[index]['Customer']) {
        if (widget.customerData[i]['CustMob'] != null) {
          return widget.customerData[i]['CustMob'];
        } else if (widget.customerData[i]['CustTel'] != null) {
          return widget.customerData[i]['CustTel'];
        }
      }
    }
    return widget.agentContact;
  }

  String _getTotalItems(int index, String filter, List filterList) {
    int items = 0;

    for (int i = 0;
        i < filterList[index][filterList[index]['OrderNo']].length;
        i++) {
      items++;
      // items += filterList[index][filterList[index]['OrderNo']][i]['Quantity'];
    }
    return items.toString();
  }

  List _buildFilteredOrderCard(String filter, List list) {
    int len = 0;
    if (salesOrderData == null) {
      return null;
    } else {
      if (filter == 'All') {
        for (int i = 0; i < salesOrderData.length; i++) {
          if (salesOrderData[i]['AgentCode'] == widget.agentCode &&
              salesOrderData[i]['Status'] == 'Cancelled') {
            len++;
          }
        }
        if (len != 0) {
          var filterOrder = new List.filled(len, []);
          int x = 0;
          for (int i = 0; i < salesOrderData.length; i++) {
            if (salesOrderData[i]['AgentCode'] == widget.agentCode &&
                salesOrderData[i]['Status'] == 'Cancelled') {
              filterOrder[x++].add(salesOrderData[i]);
            }
          }
          return _reOrderOrders(filterOrder);
        }
      } else {
        if (list != null) {
          for (int i = 0; i < list[0].length; i++) {
            if (list[0][i]['Status'] == filter) {
              len++;
            }
          }
          if (len != 0) {
            var filterOrder = new List.filled(len, []);
            int x = 0;
            for (int i = 0; i < list[0].length; i++) {
              if (list[0][i]['Status'] == filter) {
                filterOrder[x++].add(list[0][i]);
              }
            }
            return filterOrder;
          }
        }
      }
    }
    return null;
  }

  List _reOrderOrders(List list) {
    var newList = new List.filled(list[0].length, []);
    int x = 0;
    for (int i = 0; i < list.length; i++) {
      newList[x++].add(list[0][list[0].length - 1 - i]);
    }
    return newList;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: customColor[10],
        centerTitle: false,
        title: Text(
          'Cancelled Order',
          style: appBar,
        ),
      ),
      body: StreamBuilder(
          stream: _dbRef.child('SalesOrder').onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null) {
              salesOrderData = snapshot.data.snapshot.value;
            } else {
              return MySpinKitFadingCube();
            }

            filterAll = _buildFilteredOrderCard('All', null);
            filterCancelled = _buildFilteredOrderCard('Cancelled', filterAll);

            return Container(
              color: customColor[20],
              child: filterCancelled != null
                  ? GridView.builder(
                      itemCount: filterCancelled[0].length,
                      itemBuilder: (ctx, index) => _buildOrderCard(
                          index,
                          filterCancelled[0][index]['OrderNo'],
                          filterCancelled[0][index]['Date'],
                          filterCancelled[0][index]['Customer'],
                          _getContactPerson(index, 'all', filterCancelled[0]),
                          _getContactNumber(index, 'all', filterCancelled[0]),
                          _getTotalItems(index, 'all', filterCancelled[0]),
                          filterCancelled[0][index]['Status'],
                          filterCancelled[0][index]['Total'].toString()),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.8,
                        crossAxisCount: 1,
                      ),
                    )
                  : NoDataFound(name: 'No Data Found'),
            );
          }),
    );
  }
}
