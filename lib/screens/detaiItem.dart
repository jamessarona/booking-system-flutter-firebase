import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:edq/shared/constants.dart';
import 'package:edq/widgets/mySpinKits.dart';
import 'package:edq/widgets/myTexts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String brand;
  final String category;
  final String itemCode;
  final String itemDesc;
  final String partNo;
  final String price;
  final String unit;
  final String image;
  final String orderNo;

  DetailScreen({
    this.brand,
    this.category,
    this.itemCode,
    this.itemDesc,
    this.partNo,
    this.price,
    this.unit,
    this.orderNo,
    this.image,
  });
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Size screenSize;
  String parentKey;
  int itemExist;
  var cartData;
  var cartItemsData;
  bool isAddToCartLoading = false;
  Timer _timer;
  bool isAddPress;
  bool isDeductPress;
  DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  Widget _buildImage() {
    return Stack(
      children: [
        Container(
          width: screenSize.width,
          height: screenSize.height * .3,
          color: customColor[10],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenSize.width * .9,
                height: screenSize.height * .28,
                child: Card(
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image:
                              // widget.image != null
                              //     ? NetworkImage('${widget.image}')
                              // :
                              AssetImage('assets/no-image.jpg'),
                        ),
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemInformation() {
    return Container(
      height: screenSize.height * .5,
      width: screenSize.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: screenSize.height * .5,
            width: screenSize.width * .75,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenSize.height * .03),
                Text(
                  '₱${double.tryParse(widget.price).toStringAsFixed(2)}',
                  style: roboto.copyWith(
                      fontSize: 35,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0,
                      color: customColor),
                ),
                SizedBox(height: screenSize.height * .03),
                Text(widget.itemDesc,
                    style: appBar.copyWith(
                      fontSize: 25,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: screenSize.height * .03),
                Row(
                  children: [
                    Container(
                      width: 25,
                    ),
                  ],
                ),
                Text(
                  'Specification',
                  style: appBar.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0),
                ),
                Row(
                  children: [
                    Container(
                      width: 25,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyItemDescription(
                          title: 'Item Code',
                          name: widget.itemCode,
                        ),
                        MyItemDescription(
                          title: 'Part Number',
                          name: widget.partNo,
                        ),
                        MyItemDescription(
                          title: 'Category',
                          name: widget.category,
                        ),
                        MyItemDescription(
                          title: 'Brand',
                          name: widget.brand,
                        ),
                        MyItemDescription(
                          title: 'Unit',
                          name: widget.unit,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _addToCart(int quantity) async {
    var newTotal = cartData['Total'];
    int newQuantity;
    if (cartItemsData != null) {
      itemExist = _checkItemExistOnCart();
      print(itemExist);
      if (itemExist >= 0) {
        newQuantity = cartItemsData[itemExist]['Quantity'] + quantity;
        newTotal += (double.parse(widget.price) * newQuantity);
        await _dbRef
            .child('Cart')
            .child(parentKey)
            .child(widget.orderNo)
            .update({
          itemExist.toString(): {
            'Brand': widget.brand,
            'ItemCode': widget.itemCode.toString(),
            'ItemDesc': widget.itemDesc,
            'Quantity': newQuantity,
            'PartNo': widget.partNo,
            'Price': double.parse(widget.price),
            'Ammount': double.parse(widget.price) * newQuantity,
          }
        });
      } else {
        newTotal += (double.parse(widget.price) * quantity);
        await _dbRef
            .child('Cart')
            .child(parentKey)
            .child(widget.orderNo)
            .update({
          cartItemsData.length.toString(): {
            'Brand': widget.brand,
            'ItemCode': widget.itemCode.toString(),
            'ItemDesc': widget.itemDesc,
            'Quantity': quantity,
            'PartNo': widget.partNo,
            'Price': double.parse(widget.price),
            'Ammount': double.parse(widget.price) * quantity,
          }
        });
      }
    } else {
      newTotal += (double.parse(widget.price) * quantity);
      await _dbRef.child('Cart').child(parentKey).child(widget.orderNo).update({
        0.toString(): {
          'Brand': widget.brand,
          'ItemCode': widget.itemCode.toString(),
          'ItemDesc': widget.itemDesc,
          'Quantity': quantity,
          'PartNo': widget.partNo,
          'Price': double.parse(widget.price),
          'Ammount': double.parse(widget.price) * quantity,
        }
      });
    }
    await _dbRef.child('Cart').child(parentKey).update({
      'Total': newTotal,
    });
  }

  int _checkItemExistOnCart() {
    for (int i = 0; i < cartItemsData.length; i++) {
      if (widget.itemCode.toString() ==
          cartItemsData[i]['ItemCode'].toString()) {
        return i;
      }
    }
    return -1;
  }

  void _buildModalBottom() {
    showModalBottomSheet(
      context: context,
      // ignore: non_constant_identifier_names
      builder: (BuildContext context) {
        return BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) {
              int quantity = 1;
              return StatefulBuilder(builder: (BuildContext context, setState) {
                return Container(
                  height: screenSize.height * .3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            iconSize: 25,
                            color: Colors.black,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      Text(
                        widget.itemDesc,
                        style: appBar.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Quantity:',
                        style: bodyText.copyWith(fontSize: 15),
                      ),
                      Container(
                        height: screenSize.height * .04,
                        width: screenSize.width * .3,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (quantity > 1) {
                                      quantity--;
                                    }
                                  });
                                },
                                highlightColor: customColor,
                                splashColor: customColor,
                                child: Icon(
                                  Icons.remove,
                                ),
                              ),
                              onLongPressStart: (_) async {
                                isDeductPress = true;
                                do {
                                  setState(() {
                                    if (quantity > 1) {
                                      quantity--;
                                    }
                                  });
                                  await Future.delayed(
                                      Duration(milliseconds: 1));
                                } while (isDeductPress);
                              },
                              onLongPressEnd: (_) =>
                                  setState(() => isDeductPress = false),
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
                              width: screenSize.width * .1,
                              child: AutoSizeText(
                                quantity.toString(),
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
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },
                                highlightColor: customColor,
                                splashColor: customColor,
                                child: Icon(
                                  Icons.add,
                                ),
                              ),
                              onLongPressStart: (_) async {
                                isAddPress = true;
                                do {
                                  setState(() {
                                    quantity++;
                                  });
                                  await Future.delayed(
                                      Duration(milliseconds: 1));
                                } while (isAddPress);
                              },
                              onLongPressEnd: (_) =>
                                  setState(() => isAddPress = false),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: bodyText.copyWith(fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Ammount:',
                              style: bodyText.copyWith(fontSize: 15),
                            ),
                            TextSpan(
                              text:
                                  ' ₱${(double.tryParse(widget.price) * quantity).toStringAsFixed(2)}',
                              style: roboto.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: customColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenSize.width * .9,
                        height: screenSize.height * .08,
                        child: IgnorePointer(
                          ignoring: isAddToCartLoading,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isAddToCartLoading = true;
                                _addToCart(quantity);
                                isAddToCartLoading = false;
                                Navigator.of(context).pop();
                                _buildModalSuccessAddToCart(context);
                              });
                            },
                            color: customColor[10],
                            textColor: Colors.black,
                            child: Container(
                              child: isAddToCartLoading == false
                                  ? Text(
                                      'Add To Cart',
                                      style: appBar.copyWith(
                                        fontSize: 25,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  : MySpinKitCircle(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
            });
      },
    );
  }

  Future<void> _buildModalSuccessAddToCart(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _timer = Timer(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          backgroundColor: customColor[10],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          content: Container(
            height: screenSize.height * .08,
            width: screenSize.width * .8,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Added to ${cartData['Customer']}',
                    style: appBar.copyWith(
                      fontSize: 25,
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColor[10],
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder(
          stream: _dbRef
              .child('Cart')
              .orderByChild('OrderNo')
              .equalTo(widget.orderNo)
              .onChildAdded,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null) {
              parentKey = snapshot.data.snapshot.key;
              cartData = snapshot.data.snapshot.value;
            } else {
              return MySpinKitFadingCube();
            }
            return StreamBuilder(
                stream: _dbRef
                    .child('Cart')
                    .child(parentKey.toString())
                    .child(widget.orderNo)
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      !snapshot.hasError &&
                      snapshot.data.snapshot.value != null) {
                    cartItemsData = snapshot.data.snapshot.value;
                  } else {
                    cartItemsData = null;
                  }
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(
                      children: [
                        _buildImage(),
                        _buildItemInformation(),
                      ],
                    ),
                  );
                });
          }),
      floatingActionButton: SizedBox(
        width: screenSize.width * .94,
        height: screenSize.height * .08,
        child: FloatingActionButton(
          onPressed: () {
            _buildModalBottom();
          },
          backgroundColor: customColor[10],
          child: Text(
            'Add To Cart',
            style: appBar.copyWith(
              fontSize: 25,
              fontWeight: FontWeight.normal,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
