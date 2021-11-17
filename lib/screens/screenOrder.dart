import 'dart:async';
import 'package:edq/screens/detailOrder.dart';
import 'package:edq/screens/screenAccount.dart';
import 'package:edq/shared/constants.dart';
import 'package:edq/widgets/myMessage.dart';
import 'package:edq/widgets/mySpinKits.dart';
import 'package:edq/widgets/myTabBar.dart';
import 'package:edq/widgets/mybuttons.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  final String agentCode;
  final String agentContact;
  final String agentEmail;
  final List customerData;
  OrderScreen(
      {this.agentCode, this.agentContact, this.agentEmail, this.customerData});
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  var salesOrderData;
  var filterAll;
  var filterQueued;
  var filterProcessing;
  var filterApproved;
  var filterDeclined;
  bool isLoadingDeleteOrder = false;
  Timer _timer;
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
                              fontWeight: FontWeight.normal),
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
          width: screenSize.width * .44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IgnorePointer(
                ignoring: orderStatus == 'Approved' ? true : false,
                child: MyButtonOrders(
                  onPressed: () {
                    _buildModalCancelConfirmation(context, index, orderNo);
                  },
                  name: 'Cancel',
                  color: orderStatus == 'Approved' ? Colors.grey : customColor,
                ),
              ),
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
              salesOrderData[i]['Status'] != 'Cancelled') {
            len++;
          }
        }
        if (len != 0) {
          var filterOrder = new List.filled(len, []);
          int x = 0;
          for (int i = 0; i < salesOrderData.length; i++) {
            if (salesOrderData[i]['AgentCode'] == widget.agentCode &&
                salesOrderData[i]['Status'] != 'Cancelled') {
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

  Future<void> _buildModalCancelConfirmation(
      BuildContext context, int index, String orderNo) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 10,
                    width: screenSize.width * .11,
                  ),
                  Text(
                    'WARNING!!',
                    style: appBar.copyWith(color: customColor),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: appBar.copyWith(
                              fontSize: 13, fontWeight: FontWeight.normal),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Press Confirm to',
                            ),
                            TextSpan(
                              text: ' Cancel',
                              style: appBar.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: customColor,
                              ),
                            ),
                            TextSpan(
                              text: ' order.',
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 65,
                      width: 240,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 35,
                            width: 80,
                            child: IgnorePointer(
                              ignoring: false,
                              child: MySwitchAccountButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                },
                                isLoading: false,
                                name: 'Close',
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 35,
                            width: 80,
                            child: IgnorePointer(
                              ignoring: isLoadingDeleteOrder ? true : false,
                              child: MySwitchAccountButton(
                                onPressed: () {
                                  setState(() {
                                    isLoadingDeleteOrder = true;
                                    _cancelOrder(orderNo);
                                    isLoadingDeleteOrder = false;
                                  });
                                },
                                isLoading: isLoadingDeleteOrder,
                                name: 'Confirm',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _cancelOrder(String orderNo) async {
    for (int i = 0; i < salesOrderData.length; i++) {
      if (salesOrderData[i]['OrderNo'] == orderNo) {
        await _dbRef.child('SalesOrder').child(i.toString()).update({
          'Status': 'Cancelled',
        });
      }
    }
    Navigator.of(context).pop();
    _buildModalSuccessDeleteOrder(context);
  }

  Future<void> _buildModalSuccessDeleteOrder(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _timer = Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          backgroundColor: customColor[20],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: Container(
            height: screenSize.height * .05,
            width: screenSize.width * .6,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Order is Cancelled',
                    style: appBar.copyWith(
                      fontSize: 18,
                      color: customColor,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),
        );
      },
    ).then((value) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => Account(),
              ),
            ),
          ),
          backgroundColor: customColor[10],
          centerTitle: false,
          title: Text(
            'Orders',
            style: appBar,
          ),
          bottom: PreferredSize(
            child: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.black.withOpacity(0.3),
                labelColor: customColor,
                indicatorColor: customColor,
                tabs: [
                  MyStabBar(
                    tabBarName: 'All',
                  ),
                  MyStabBar(
                    tabBarName: 'Queued',
                  ),
                  MyStabBar(
                    tabBarName: 'Processing',
                  ),
                  MyStabBar(
                    tabBarName: 'Approved',
                  ),
                  MyStabBar(
                    tabBarName: 'Declined',
                  ),
                ]),
            preferredSize: Size.fromHeight(30.0),
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

            filterQueued = _buildFilteredOrderCard('Queued', filterAll);
            filterProcessing = _buildFilteredOrderCard('Processing', filterAll);
            filterApproved = _buildFilteredOrderCard('Approved', filterAll);
            filterDeclined = _buildFilteredOrderCard('Declined', filterAll);
            return TabBarView(
              children: <Widget>[
                Container(
                  color: customColor[20],
                  child: filterAll != null
                      ? GridView.builder(
                          itemCount: filterAll[0].length,
                          itemBuilder: (ctx, index) => _buildOrderCard(
                              index,
                              filterAll[0][index]['OrderNo'],
                              filterAll[0][index]['Date'],
                              filterAll[0][index]['Customer'],
                              _getContactPerson(index, 'all', filterAll[0]),
                              _getContactNumber(index, 'all', filterAll[0]),
                              _getTotalItems(index, 'all', filterAll[0]),
                              filterAll[0][index]['Status'],
                              filterAll[0][index]['Total'].toString()),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.8,
                            crossAxisCount: 1,
                          ),
                        )
                      : NoDataFound(name: 'No Order Found'),
                ),
                Container(
                  color: customColor[20],
                  child: filterQueued != null
                      ? GridView.builder(
                          itemCount: filterQueued[0].length,
                          itemBuilder: (ctx, index) => _buildOrderCard(
                              index,
                              filterQueued[0][index]['OrderNo'],
                              filterQueued[0][index]['Date'],
                              filterQueued[0][index]['Customer'],
                              _getContactPerson(
                                  index, 'Queued', filterQueued[0]),
                              _getContactNumber(
                                  index, 'Queued', filterQueued[0]),
                              _getTotalItems(index, 'Queued', filterQueued[0]),
                              filterQueued[0][index]['Status'],
                              filterQueued[0][index]['Total'].toString()),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.8,
                            crossAxisCount: 1,
                          ),
                        )
                      : NoDataFound(name: 'No Order Found'),
                ),
                Container(
                  color: customColor[20],
                  child: filterProcessing != null
                      ? GridView.builder(
                          itemCount: filterProcessing[0].length,
                          itemBuilder: (ctx, index) => _buildOrderCard(
                              index,
                              filterProcessing[0][index]['OrderNo'],
                              filterProcessing[0][index]['Date'],
                              filterProcessing[0][index]['Customer'],
                              _getContactPerson(
                                  index, 'Processing', filterProcessing[0]),
                              _getContactNumber(
                                  index, 'Processing', filterProcessing[0]),
                              _getTotalItems(
                                  index, 'Processing', filterProcessing[0]),
                              filterProcessing[0][index]['Status'],
                              filterProcessing[0][index]['Total'].toString()),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.8,
                            crossAxisCount: 1,
                          ),
                        )
                      : NoDataFound(name: 'No Order Found'),
                ),
                Container(
                  color: customColor[20],
                  child: filterApproved != null
                      ? GridView.builder(
                          itemCount: filterApproved[0].length,
                          itemBuilder: (ctx, index) => _buildOrderCard(
                              index,
                              filterApproved[0][index]['OrderNo'],
                              filterApproved[0][index]['Date'],
                              filterApproved[0][index]['Customer'],
                              _getContactPerson(
                                  index, 'Queued', filterApproved[0]),
                              _getContactNumber(
                                  index, 'Queued', filterApproved[0]),
                              _getTotalItems(
                                  index, 'Queued', filterApproved[0]),
                              filterApproved[0][index]['Status'],
                              filterApproved[0][index]['Total'].toString()),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.8,
                            crossAxisCount: 1,
                          ),
                        )
                      : NoDataFound(name: 'No Order Found'),
                ),
                Container(
                  color: customColor[20],
                  child: filterDeclined != null
                      ? GridView.builder(
                          itemCount: filterDeclined[0].length,
                          itemBuilder: (ctx, index) => _buildOrderCard(
                              index,
                              filterDeclined[0][index]['OrderNo'],
                              filterDeclined[0][index]['Date'],
                              filterDeclined[0][index]['Customer'],
                              _getContactPerson(
                                  index, 'Queued', filterDeclined[0]),
                              _getContactNumber(
                                  index, 'Queued', filterDeclined[0]),
                              _getTotalItems(
                                  index, 'Queued', filterDeclined[0]),
                              filterDeclined[0][index]['Status'],
                              filterDeclined[0][index]['Total'].toString()),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.8,
                            crossAxisCount: 1,
                          ),
                        )
                      : NoDataFound(name: 'No Order Found'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
