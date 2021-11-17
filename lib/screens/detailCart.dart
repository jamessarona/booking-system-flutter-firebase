import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:edq/screens/detaiItem.dart';
import 'package:edq/screens/screenProduct.dart';
import 'package:edq/shared/constants.dart';
import 'package:edq/widgets/myImageItems.dart';
import 'package:edq/widgets/myMessage.dart';
import 'package:edq/widgets/mySpinKits.dart';
import 'package:edq/widgets/myTexts.dart';
import 'package:edq/widgets/mybuttons.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//TODO: Improve add minus quantity to long press
// sundugon ra sa detail order na kwaon ang initState!!!!
class CartItem extends StatefulWidget {
  final String orderNo;
  final String clientName;
  final String clientEmail;
  final String clientContact;
  final String address;

  final String agentCode;
  final List userDatabase;
  final List customerData;
  final List productData;
  CartItem(
      {this.orderNo,
      this.clientName,
      this.clientContact,
      this.clientEmail,
      this.address,
      this.agentCode,
      this.customerData,
      this.userDatabase,
      this.productData});
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  Size screenSize;
  Timer _timer;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoadingDeleteCart = false;
  bool isLoadingSubmitCart = false;
  bool isLoadingDeleteSelectedItems = false;
  List isCheckedGroup = [];
  bool isAddPress;
  bool isDeductPress;
  DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
  var singleCartData;
  var singleCartDataKey;

  Widget _buildCartInfo(double cTotal) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.clientName.toLowerCase().capitalizeFirstofEach}',
          style: bodyText.copyWith(
            fontSize: 18,
            letterSpacing: 0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.clientEmail,
                // .toLowerCase().capitalizeFirstofEach,
                style: bodyText.copyWith(
                  fontSize: 12,
                  letterSpacing: 0,
                ),
              ),
              Text(
                widget.clientContact,
                style: bodyText.copyWith(
                  fontSize: 12,
                  letterSpacing: 0,
                ),
              ),
              Container(
                width: screenSize.width * .75,
                child: Text(
                  widget.address.toLowerCase().capitalizeFirstofEach,
                  style: bodyText.copyWith(
                    fontSize: 12,
                    letterSpacing: 0,
                  ),
                  maxLines: 3,
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
              '₱${cTotal.toStringAsFixed(2)}',
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

  Widget _buildSingleItemCart(
      int index,
      String iName,
      String iCode,
      String iPart,
      String iBrand,
      double iAmmount,
      int iQuantity,
      double iPrice,
      double iTotal) {
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
            _buildItemCheckBox(index),
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
                          iAmmount, iQuantity, iPrice, iTotal)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCheckBox(index) {
    return Container(
      height: screenSize.height * .2,
      width: screenSize.width * .05,
      child: Checkbox(
        value: isCheckedGroup[index][index.toString()],
        onChanged: (value) {
          setState(() {
            isCheckedGroup[index][index.toString()] =
                !isCheckedGroup[index][index.toString()];
          });
        },
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
                child: _buildItemTitle(iName),
              ),
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

  Widget _buildItemTitle(String iName) {
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
        //Text('data'),
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
                name: 'Brand: ${iBrand.toLowerCase().capitalizeFirstofEach}',
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
          GestureDetector(
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
            // onLongPressStart: (_) async {
            //   isDeductPress = true;
            //   do {
            //     setState(() {
            //       _updateItemQuantity('-', index, iQuantity, iPrice, iTotal);
            //     });
            //     await Future.delayed(Duration(milliseconds: 1));
            //   } while (isDeductPress);
            // },
            // onLongPressEnd: (_) => setState(() => isDeductPress = false),
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
              iQuantity.toString(),
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
          GestureDetector(
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
            // onLongPressStart: (_) async {
            //   isAddPress = true;
            //   do {
            //     setState(() {
            //       _updateItemQuantity('+', index, iQuantity, iPrice, iTotal);
            //       print(iQuantity);
            //     });
            //     await Future.delayed(Duration(milliseconds: 1));
            //   } while (isAddPress);
            // },
            // onLongPressEnd: (_) => setState(() => isAddPress = false),
          ),
        ],
      ),
    );
  }

  Future<void> _updateItemQuantity(String method, int index, int iQuantity,
      double iPrice, double iTotal) async {
    if (method == '+') {
      iQuantity++;
      iTotal += iPrice;
    } else if (method == '-') {
      if (iQuantity > 1) {
        iQuantity--;
        iTotal -= iPrice;
      }
    }
    await _dbRef
        .child('Cart')
        .child(singleCartDataKey)
        .child(widget.orderNo)
        .child(index.toString())
        .update({
      'Quantity': iQuantity,
      'Ammount': iPrice * iQuantity,
    });
    await _dbRef.child('Cart').child(singleCartDataKey).update({
      'Total': iTotal,
    });
    setState(() {});
  }

  void submitOrder() {
    if (singleCartData[widget.orderNo] != null) {
      _getSalsOrderLength().then((value) async {
        int salesOrderLength = value;
        singleCartData['Status'] = 'Queued';
        await _dbRef.child('SalesOrder').update({
          salesOrderLength.toString(): singleCartData,
        });

        await _dbRef.child('Cart').child(singleCartDataKey.toString()).update({
          'Status': 'Submitted',
        });
        Navigator.of(context).pop();
        _buildModalSuccessAddToOrder(context);
      });
    } else {
      Navigator.of(context).pop();
      _buildModalEmptyCart(context, 'Cart is Empty');
    }
  }

  Future<int> _getSalsOrderLength() async {
    int salesOrderLength =
        await _dbRef.child('SalesOrder').once().then((DataSnapshot snapshot) {
      return snapshot.value.length;
    });
    return salesOrderLength;
  }

  void _deleteCart() async {
    await _dbRef.child('Cart').child(singleCartDataKey.toString()).update({
      'Status': 'Deleted',
    });

    Navigator.of(context).pop();
    _buildModalSuccessDeleteCart(context);
  }

  Future<void> _deleteSelectedItems() async {
    if (singleCartData[widget.orderNo] != null) {
      double deduct = 0;
      double total = 0;
      double newTotal = 0;
      int len = 0;
      for (int i = 0; i < singleCartData[widget.orderNo].length; i++) {
        if (isCheckedGroup[i][i.toString()] == false) {
          len++;
        }
      }
      var newCartItemData = new List.filled(len, []);
      int x = 0;
      for (int i = 0; i < singleCartData[widget.orderNo].length; i++) {
        if (isCheckedGroup[i][i.toString()] == false) {
          newCartItemData[x++]
              .add(singleCartData[widget.orderNo.toString()][i]);
        } else {
          deduct += singleCartData[widget.orderNo.toString()][i]['Ammount']
              .toDouble();
        }
      }
      if (newCartItemData.length != 0) {
        total = singleCartData['Total'].toDouble();

        newTotal = total - deduct;
        await _dbRef.child('Cart').child(singleCartDataKey).update({
          widget.orderNo: newCartItemData[0],
        });
        await _dbRef.child('Cart').child(singleCartDataKey).update({
          'Total': newTotal,
        });
      } else {
        await _dbRef
            .child('Cart')
            .child(singleCartDataKey)
            .child(widget.orderNo.toString())
            .remove();
        await _dbRef.child('Cart').child(singleCartDataKey).update({
          'Total': 0,
        });
      }
      isCheckedGroup.clear();
      setState(() {
        isLoadingDeleteSelectedItems = false;
        Navigator.of(context).pop();
        _buildModalEmptyCart(context, 'Selected items Removed');
      });
    } else {
      isCheckedGroup.clear();
      setState(() {
        isLoadingDeleteSelectedItems = false;
        Navigator.of(context).pop();
        _buildModalEmptyCart(context, 'Cart is Empty');
      });
    }
  }

  Future<void> _buildSubmitCart(BuildContext context) async {
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
                    'Confirmation',
                    style: appBar.copyWith(
                      color: Colors.black,
                    ),
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
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: appBar.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Are you sure to submit this cart',
                              ),
                              TextSpan(
                                text:
                                    '\nOrder No: ${singleCartData['OrderNo']}',
                                style: appBar.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: customColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                              ignoring: isLoadingSubmitCart ? true : false,
                              child: MySwitchAccountButton(
                                onPressed: () {
                                  setState(() {
                                    isLoadingSubmitCart = true;
                                    submitOrder();
                                  });
                                },
                                isLoading: isLoadingSubmitCart,
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

  Future<void> _buildDeleteCart(BuildContext context) async {
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
              content: Form(
                key: _formKey,
                child: Column(
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
                                text: 'This Cart will be',
                              ),
                              TextSpan(
                                text: ' Deleted Permanently.',
                                style: appBar.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: customColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                              ignoring: isLoadingDeleteCart ? true : false,
                              child: MySwitchAccountButton(
                                onPressed: () {
                                  setState(() {
                                    isLoadingDeleteCart = true;
                                    _deleteCart();
                                  });
                                },
                                isLoading: isLoadingDeleteCart,
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

  Future<void> _buildModalSuccessDeleteCart(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _timer = Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
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
                    'Cart is Removed',
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

  Future<void> _buildDeleteSelectedItem(BuildContext context) async {
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
              content: Form(
                key: _formKey,
                child: Column(
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
                                text: 'Tap Delete to',
                              ),
                              TextSpan(
                                text: '  Delete the Selected Items.',
                                style: appBar.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: customColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                              ignoring:
                                  isLoadingDeleteSelectedItems ? true : false,
                              child: MySwitchAccountButton(
                                onPressed: () {
                                  setState(() {
                                    //Debug here yesterday not working fucking shit
                                    //wont output simple print
                                    //delete wont work when only one item in cart remains
                                    // isLoadingDeleteSelectedItems = true;

                                    _deleteSelectedItems();
                                  });
                                },
                                isLoading: isLoadingDeleteSelectedItems,
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

  Future<void> _buildModalSuccessAddToOrder(BuildContext context) async {
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
                    'Sales Order Created Successfully',
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

  Future<void> _buildModalEmptyCart(
      BuildContext context, String message) async {
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
                    message,
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

  String getproductSpecs(String iCode, String method) {
    String iData;
    for (int i = 0; i < widget.productData.length; i++) {
      if (widget.productData[i]['ItemCode'].toString() == iCode) {
        iData = widget.productData[i][method].toString();
      }
    }
    return iData;
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
          'Cart',
          style: appBar,
        ),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.cartPlus),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => ProductList(
                    agentCode: widget.agentCode,
                    orderNo: widget.orderNo,
                    userDatabase: widget.userDatabase,
                    customerData: widget.customerData,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _dbRef
              .child('Cart')
              .orderByChild('OrderNo')
              .equalTo(widget.orderNo)
              .onChildAdded,
          builder: (context, singleCartSnapshot) {
            if (singleCartSnapshot.hasData &&
                !singleCartSnapshot.hasError &&
                singleCartSnapshot.data.snapshot.value != null) {
              singleCartData = singleCartSnapshot.data.snapshot.value;
              singleCartDataKey = singleCartSnapshot.data.snapshot.key;
            } else {
              return MySpinKitFadingCube();
            }
            //theres an error bellow becuase if you add the a checkbox member ir will continuously grow
            if (singleCartData[widget.orderNo] != null) {
              for (int i = 0; i < singleCartData[widget.orderNo].length; i++) {
                isCheckedGroup.add({i.toString(): false});
              }
            }
            return Container(
              color: customColor[20],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: screenSize.height * .16,
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        left: 25, right: 30, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCartInfo(singleCartData['Total'].toDouble()),
                        Container(
                          padding: EdgeInsets.only(
                            top: 10,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              await _buildDeleteCart(context);
                            },
                            child: Image(
                              image: AssetImage(
                                "assets/trash.png",
                              ),
                              height: 30,
                              color: customColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: screenSize.height * .7,
                    padding: EdgeInsets.only(top: 5),
                    child: singleCartData[widget.orderNo] != null
                        ? GridView.builder(
                            itemCount: singleCartData[widget.orderNo].length,
                            itemBuilder: (ctx, index) => _buildSingleItemCart(
                              index,
                              singleCartData[widget.orderNo][index]['ItemDesc'],
                              singleCartData[widget.orderNo][index]['ItemCode']
                                  .toString(),
                              singleCartData[widget.orderNo][index]['PartNo'],
                              singleCartData[widget.orderNo][index]['Brand'],
                              singleCartData[widget.orderNo][index]['Ammount']
                                  .toDouble(),
                              singleCartData[widget.orderNo][index]['Quantity']
                                  .toInt(),
                              singleCartData[widget.orderNo][index]['Price']
                                  .toDouble(),
                              singleCartData['Total'].toDouble(),
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
            );
          }),
      floatingActionButton: Row(
        children: [
          SizedBox(
            width: screenSize.width * .5,
            height: screenSize.height * .08,
            child: MyFloatingButton(
              name: 'Delete',
              buttonColor: customColor,
              textColor: Colors.white,
              onPress: () {
                _buildDeleteSelectedItem(context);
              },
            ),
          ),
          SizedBox(
            width: screenSize.width * .5,
            height: screenSize.height * .08,
            child: MyFloatingButton(
              name: 'Submit Order',
              buttonColor: customColor[10],
              textColor: Colors.black,
              onPress: () {
                _buildSubmitCart(context);
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
