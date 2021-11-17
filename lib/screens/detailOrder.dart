import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:edq/screens/detaiItem.dart';
import 'package:edq/shared/constants.dart';
import 'package:edq/widgets/myImageItems.dart';
import 'package:edq/widgets/myMessage.dart';
import 'package:edq/widgets/mySpinKits.dart';
import 'package:edq/widgets/myTexts.dart';
import 'package:edq/widgets/mybuttons.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DetailOrder extends StatefulWidget {
  final String orderNo;
  final bool isEdit;
  final String agentCode;
  final String agentContact;
  final String agentEmail;
  final List customerData;
  DetailOrder({
    this.orderNo,
    this.isEdit,
    this.agentCode,
    this.agentContact,
    this.agentEmail,
    this.customerData,
  });
  @override
  _DetailOrderState createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  Size screenSize;
  DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
  var singleOrderData;
  var singleOrderDataKey;
  var productData;
  bool isAddPress = false;
  bool isDeductPress = false;
  bool isLoadingDeleteOrder = false;
  bool isLoadingUpdateOrder = false;
  Timer _timer;

  Widget _buildSingleOrderInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order No: ${singleOrderData[singleOrderDataKey.toString()]['OrderNo']}',
                style: bodyText.copyWith(
                  fontSize: 18,
                  letterSpacing: 0,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  'Place on ${singleOrderData[singleOrderDataKey.toString()]['Date']}',
                  style: bodyText.copyWith(
                    fontSize: 12,
                    letterSpacing: 0,
                  ),
                ),
              ),
              Container(
                width: screenSize.width * .6,
                height: screenSize.height * .052,
                child: AutoSizeText(
                  singleOrderData[singleOrderDataKey]['DeliveryAdd']
                      .toLowerCase(),
                  style: bodyText.copyWith(
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              'Total:',
              style: bodyText.copyWith(
                fontSize: 18,
                letterSpacing: 0,
              ),
            ),
            Container(
              width: 5,
            ),
            Text(
              '₱${singleOrderData[singleOrderDataKey.toString()]['Total'].toStringAsFixed(2)}',
              style: roboto.copyWith(
                fontSize: 18,
                letterSpacing: 0,
                color: customColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSingleItemOrder(
    index,
    String iName,
    String iCode,
    String iPart,
    String iBrand,
    double iAmmount,
    int iQuantity,
    double iPrice,
    double iTotal,
  ) {
    return Card(
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          children: [
            Container(
              height: screenSize.height * .2,
              width: screenSize.width * .05,
            ),
            // _buildItemCheckBox(index),
            Container(
              height: screenSize.height * .2,
              width: screenSize.width * .83,
              child: Row(
                children: [
                  Container(
                    height: screenSize.height * .2,
                    width: screenSize.width * .3,
                    child: MySmallItemImage(),
                  ),
                  Container(
                    height: screenSize.height * .2,
                    width: screenSize.width * .53,
                    child: _buildItemInfo(index, iName, iCode, iPart, iBrand,
                        iAmmount, iQuantity, iPrice, iTotal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemInfo(
      int index,
      String iName,
      String iCode,
      String iPart,
      String iBrand,
      double iAmmount,
      int iQuantity,
      double iPrice,
      double iTotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenSize.height * .05,
              width: screenSize.width * .53,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => DetailScreen(
                          brand: getproductSpecs(iCode, 'Brand'),
                          category: getproductSpecs(iCode, 'Category'),
                          itemCode: getproductSpecs(iCode, 'ItemCode'),
                          itemDesc: getproductSpecs(iCode, 'ItemDesc'),
                          partNo: getproductSpecs(iCode, 'PartNo'),
                          price: getproductSpecs(iCode, 'Price'),
                          unit: getproductSpecs(iCode, 'Unit'),
                          image: getproductSpecs(iCode, 'Image'),
                          orderNo: widget.orderNo,
                        ),
                      ),
                    );
                  },
                  child: _buildItemTitle(index, iName, iCode)),
            ),
            Container(
              height: screenSize.height * .11,
              width: screenSize.width * .53,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildItemSubtitle(iCode, iPart, iBrand, iAmmount),
                  _buildItemQuantity(index, iQuantity, iPrice, iTotal),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemTitle(int index, String iName, String iCode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: screenSize.height * .05,
          width: screenSize.width * .4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: screenSize.height * .033,
                width: screenSize.width * .4,
                child: Text(
                  iName,
                  style: bodyText.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: 10,
          ),
          child: IgnorePointer(
            ignoring: widget.isEdit == false ? true : false,
            child: GestureDetector(
              onTap: () async {
                await _buildDeleteCart(context, index, iCode);
              },
              child: Image(
                image: AssetImage(
                  "assets/trash.png",
                ),
                height: 30,
                color: widget.isEdit == false ? Colors.black : customColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemSubtitle(
      String iCode, String iPart, String iBrand, double iAmmount) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: screenSize.height * .06,
          width: screenSize.width * .25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MySubTextCartCard(
                name: 'Item Code: $iCode',
              ),
              MySubTextCartCard(
                name: 'Part No: $iPart',
              ),
              MySubTextCartCard(
                name: iBrand.length > 0
                    ? 'Brand: ${iBrand.toLowerCase().capitalizeFirstofEach}'
                    : 'Brand: n/a',
              ),
            ],
          ),
        ),
        Text(
          '₱${iAmmount.toStringAsFixed(2)}',
          style: roboto.copyWith(
            fontSize: 12,
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildItemQuantity(
      int index, int iQuantity, double iPrice, double iTotal) {
    return Container(
      height: screenSize.height * .05,
      width: screenSize.width * .24,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IgnorePointer(
            ignoring: widget.isEdit == false ? true : false,
            child: GestureDetector(
              child: InkWell(
                highlightColor: customColor,
                splashColor: customColor,
                child: Icon(
                  Icons.remove,
                ),
                onTap: () {
                  _updateItemQuantity('-', index, iQuantity, iPrice, iTotal);
                },
              ),
              onLongPressStart: (_) async {
                isDeductPress = true;
                do {
                  setState(() {
                    _updateItemQuantity('-', index, iQuantity, iPrice, iTotal);
                  });
                  await Future.delayed(Duration(milliseconds: 1));
                } while (isDeductPress);
              },
              onLongPressEnd: (_) => setState(() => isDeductPress = false),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Container(
            width: screenSize.width * .08,
            child: AutoSizeText(
              singleOrderData[singleOrderDataKey][widget.orderNo][index]
                      ['Quantity']
                  .toString(),
              // iQuantity.toString(),
              style: appBar.copyWith(
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          IgnorePointer(
            ignoring: widget.isEdit == false ? true : false,
            child: GestureDetector(
              child: InkWell(
                highlightColor: customColor,
                splashColor: customColor,
                child: Icon(
                  Icons.add,
                ),
                onTap: () {
                  _updateItemQuantity('+', index, iQuantity, iPrice, iTotal);
                },
              ),
              onLongPressStart: (_) async {
                isAddPress = true;
                do {
                  setState(() {
                    _updateItemQuantity('+', index, iQuantity, iPrice, iTotal);
                  });
                  await Future.delayed(Duration(milliseconds: 1));
                } while (isAddPress);
              },
              onLongPressEnd: (_) => setState(() => isAddPress = false),
            ),
          ),
        ],
      ),
    );
  }

  void _updateItemQuantity(
      String method, int index, int iQuantity, double iPrice, double iTotal) {
    setState(() {
      if (method == '+') {
        singleOrderData[singleOrderDataKey][widget.orderNo][index]
            ['Quantity']++;
        singleOrderData[singleOrderDataKey][widget.orderNo][index]['Ammount'] +=
            iPrice;
        singleOrderData[singleOrderDataKey]['Total'] += iPrice;
      } else {
        if (singleOrderData[singleOrderDataKey][widget.orderNo][index]
                ['Quantity'] >
            1) {
          singleOrderData[singleOrderDataKey][widget.orderNo][index]
              ['Quantity']--;
          singleOrderData[singleOrderDataKey][widget.orderNo][index]
              ['Ammount'] -= iPrice;
          singleOrderData[singleOrderDataKey]['Total'] -= iPrice;
        }
      }
    });
  }

  Future<void> _buildDeleteCart(
      BuildContext context, int index, String iCode) async {
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
                              text: 'Are you sure to ',
                            ),
                            TextSpan(
                              text: ' Deleted',
                              style: appBar.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: customColor,
                              ),
                            ),
                            TextSpan(
                              text: ' Code: $iCode.',
                            ),
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
                                name: 'Cancel',
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
                                    _deleteOrder(iCode);
                                    isLoadingDeleteOrder = false;
                                  });
                                },
                                isLoading: isLoadingDeleteOrder,
                                name: 'Delete',
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

  void _deleteOrder(String iCode) {
    //TODO: remove an item to list
    // for (int i = 0;
    //     i < singleOrderData[singleOrderDataKey][widget.orderNo].length;
    //     i++) {
    //   if (singleOrderData[singleOrderDataKey][widget.orderNo][i]['ItemCode'] ==
    //       iCode) {
    //     // for (int x = i;
    //     //     x < singleOrderData[singleOrderDataKey][widget.orderNo].length - 1;
    //     //     x++) {
    //     //   singleOrderData[singleOrderDataKey][widget.orderNo][x] =
    //     //       singleOrderData[singleOrderDataKey][widget.orderNo][x + 1];
    //     // }
    //   }
    // }
    //Last Edit deleting the selected item
    //create new list that thats been deleted, calculate the deduct and addition
    //update the order in db using the new list
    //delete item using iCode

    Navigator.of(context).pop();
    _buildModalSuccessDeleteItemOrder(context, iCode);
  }

  Future<void> _updateOrder() async {
    singleOrderData[singleOrderDataKey]['Status'] = 'Queued';
    await _dbRef.child('SalesOrder').update({
      singleOrderDataKey.toString(): singleOrderData[singleOrderDataKey],
    });

    Navigator.of(context).pop();
    _buildModalSuccessUpdateOrder(context);
  }

  Future<void> _buildModalResubmitOrder() async {
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
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: appBar.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                          children: <TextSpan>[
                            singleOrderData[singleOrderDataKey.toString()]
                                        ['Status'] !=
                                    'Queued'
                                ? TextSpan(
                                    text: 'This will be',
                                  )
                                : TextSpan(),
                            singleOrderData[singleOrderDataKey.toString()]
                                        ['Status'] !=
                                    'Queued'
                                ? TextSpan(
                                    text: ' Queued Again.',
                                    style: appBar.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: customColor,
                                    ),
                                  )
                                : TextSpan(),
                            TextSpan(
                              text: '\nSubmit to save changes.',
                            ),
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
                                name: 'Cancel',
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            height: 35,
                            width: 80,
                            child: IgnorePointer(
                              ignoring: isLoadingUpdateOrder ? true : false,
                              child: MySwitchAccountButton(
                                onPressed: () {
                                  setState(() {
                                    isLoadingUpdateOrder = true;
                                    _updateOrder();
                                  });
                                },
                                isLoading: isLoadingDeleteOrder,
                                name: 'Submit',
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

  Future<void> _buildModalSuccessDeleteItemOrder(
      BuildContext context, String iCode) async {
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
                    '$iCode item is Removed',
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

  Future<void> _buildModalSuccessUpdateOrder(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _timer = Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
        return AlertDialog(
          backgroundColor: customColor[10],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: Container(
            height: screenSize.height * .08,
            width: screenSize.width * .6,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sales Order Updated Successfully',
                    style: appBar.copyWith(
                      fontSize: 18,
                      color: Colors.black,
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
  void initState() {
    _getProductData().then((value1) {
      _getSingleSalesOrder().then((value2) {
        setState(() {
          productData = value1;
          singleOrderData = value2;
        });
      });
    });
    super.initState();
  }

  Future<List> _getProductData() async {
    List<dynamic> productList =
        await _dbRef.child('Products').once().then((DataSnapshot snapshot) {
      return snapshot.value;
    });
    return productList;
  }

  Future<Map> _getSingleSalesOrder() async {
    Map<dynamic, dynamic> itemsList = await _dbRef
        .child('SalesOrder')
        .orderByChild('OrderNo')
        .equalTo(widget.orderNo)
        .once()
        .then((DataSnapshot snapshot) {
      singleOrderDataKey =
          Map<String, dynamic>.from(snapshot.value).keys.toList()[0];
      return snapshot.value;
    });
    return itemsList;
  }

  String getproductSpecs(String iCode, String method) {
    String iData;
    for (int i = 0; i < productData.length; i++) {
      if (productData[i]['ItemCode'].toString() == iCode) {
        iData = productData[i][method].toString();
      }
    }
    return iData;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: customColor[20],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
          // pushReplacement(
          //   MaterialPageRoute(
          //     builder: (ctx) => OrderScreen(
          //       agentCode: widget.agentCode,
          //       agentContact: widget.agentContact,
          //       agentEmail: widget.agentEmail,
          //       customerData: widget.customerData,
          //     ),
          //   ),
          // ),
        ),
        backgroundColor: customColor[10],
        centerTitle: false,
        title: Text(
          'Order Items',
          style: appBar,
        ),
      ),
      body: singleOrderData != null && productData != null
          ? Container(
              height: screenSize.height,
              width: screenSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: screenSize.height * .15,
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        left: 25, right: 30, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSingleOrderInfo(),
                        Container(
                          padding: EdgeInsets.only(top: 11),
                          height: screenSize.height * .04,
                          child: MyButtonOrderStatus(
                            onPressed: () {},
                            name: singleOrderData[singleOrderDataKey.toString()]
                                ['Status'],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: screenSize.height * .67,
                    padding: EdgeInsets.only(top: 5),
                    child: singleOrderData[singleOrderDataKey.toString()]
                                    [widget.orderNo]
                                .length !=
                            null
                        ? GridView.builder(
                            itemCount:
                                singleOrderData[singleOrderDataKey.toString()]
                                        [widget.orderNo]
                                    .length,
                            itemBuilder: (ctx, index) => _buildSingleItemOrder(
                              index,
                              singleOrderData[singleOrderDataKey]
                                  [widget.orderNo][index]['ItemDesc'],
                              singleOrderData[singleOrderDataKey]
                                      [widget.orderNo][index]['ItemCode']
                                  .toString(),
                              singleOrderData[singleOrderDataKey]
                                  [widget.orderNo][index]['PartNo'],
                              singleOrderData[singleOrderDataKey]
                                  [widget.orderNo][index]['Brand'],
                              singleOrderData[singleOrderDataKey]
                                      [widget.orderNo][index]['Ammount']
                                  .toDouble(),
                              singleOrderData[singleOrderDataKey]
                                      [widget.orderNo][index]['Quantity']
                                  .toInt(),
                              singleOrderData[singleOrderDataKey]
                                      [widget.orderNo][index]['Price']
                                  .toDouble(),
                              singleOrderData[singleOrderDataKey]['Total']
                                  .toDouble(),
                            ),
                            scrollDirection: Axis.vertical,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 3,
                              childAspectRatio: 2.7,
                              crossAxisCount: 1,
                            ),
                          )
                        : NoDataFound(
                            name: 'No Item Found',
                          ),
                  ),
                ],
              ),
            )
          : MySpinKitFadingCube(),
      floatingActionButton: singleOrderData != null
          ? singleOrderDataKey != null
              ? Row(
                  children: [
                    SizedBox(
                      width: screenSize.width,
                      height: screenSize.height * .08,
                      child: IgnorePointer(
                        ignoring: singleOrderData[singleOrderDataKey]
                                    ['Status'] !=
                                'Approved'
                            ? false
                            : true,
                        child: MyFloatingButton(
                          name: widget.isEdit ? 'Resubmit Order' : 'Edit Order',
                          buttonColor: widget.isEdit
                              ? customColor
                              : singleOrderData[singleOrderDataKey]['Status'] !=
                                      'Approved'
                                  ? customColor[10]
                                  : Colors.grey,
                          textColor: widget.isEdit
                              ? Colors.white
                              : singleOrderData[singleOrderDataKey]['Status'] !=
                                      'Approved'
                                  ? Colors.black
                                  : Colors.white,
                          onPress: widget.isEdit
                              ? () {
                                  // submitOrder();
                                  _buildModalResubmitOrder();
                                }
                              : () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (ctx) => DetailOrder(
                                        orderNo: widget.orderNo,
                                        isEdit: true,
                                        agentCode: widget.agentCode,
                                        agentContact: widget.agentContact,
                                        agentEmail: widget.agentEmail,
                                        customerData: widget.customerData,
                                      ),
                                    ),
                                  );
                                },
                        ),
                      ),
                    ),
                  ],
                )
              : Text('')
          : Text(''),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
