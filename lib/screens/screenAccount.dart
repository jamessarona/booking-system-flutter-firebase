import 'package:edq/net/firebase_auth.dart';
import 'package:edq/screens/screenCancel.dart';
import 'package:edq/screens/screenCart.dart';
import 'package:edq/screens/screenOrder.dart';
import 'package:edq/screens/screenProduct.dart';
import 'package:edq/screens/screenSettings.dart';
import 'package:edq/shared/constants.dart';
import 'package:edq/widgets/mySpinKits.dart';
import 'package:edq/widgets/mybuttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

//TODO: Sort Customer Name A-Z
class Account extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  Account({this.auth, this.onSignOut});
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  Size screenSize;
  var userDatabase;
  var customerData;
  final FirebaseAuth auth = FirebaseAuth.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  bool choiceClient = false;
  bool choiceAgent = false;
  bool textBoxUserNameVisible = false;
  bool textBoxAgentAddress = false;
  bool isLoadingCreateOrder = false;
  bool isLoadingLogout = false;
  Color buttonClient = Colors.black;
  Color buttonAgent = Colors.black;
  String clientName;
  String agentAddress;
  String month;
  String day;
  String year;
  String hour;
  String minute;
  String second;
  String longitude;
  String latitude;
  final TextEditingController _typeAheadController = TextEditingController();
  String getCurrentUserEmail() {
    final User user = auth.currentUser;
    return user.email.toString();
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      setState(() {
        isLoadingLogout = false;

        Navigator.of(context).pop();
      });
      widget.onSignOut();
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildAgentInformation() {
    return Column(
      children: [
        SizedBox(height: screenSize.height * .04),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image(
            image: userDatabase[0]['AgentImage'] != null
                ? NetworkImage(userDatabase[0]['AgentImage'])
                : AssetImage('assets/profile.png'),
            height: 200,
          ),
        ),
        SizedBox(
          height: screenSize.height * .01,
        ),
        Text(
          _getUserFullname(),
          style: bodyText.copyWith(fontSize: 25),
        ),
        SizedBox(
          height: screenSize.height * .01,
        ),
        Text(
          _getUserEmail(),
          style: bodyText.copyWith(fontSize: 14),
        ),
        Text(
          _getUserContact(),
          style: bodyText.copyWith(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildMyAccountButton() {
    return Column(
      children: [
        SizedBox(
          height: screenSize.height * .05,
        ),
        MyAccountButton(
          onPressed: () async {
            await _buildCreateOrderModal(context);
          },
          image: 'order.png',
          name: 'Create Order',
        ),
        SizedBox(
          height: screenSize.height * .005,
        ),
        MyAccountButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => OrderScreen(
                  agentCode: _getAgentCode(),
                  agentContact: _getUserContact(),
                  agentEmail: _getUserEmail(),
                  customerData: customerData,
                ),
              ),
            );
          },
          image: 'box.png',
          name: 'Order',
        ),
        SizedBox(
          height: screenSize.height * .005,
        ),
        MyAccountButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => CancelledOrderScreen(
                  agentCode: _getAgentCode(),
                  agentContact: _getUserContact(),
                  agentEmail: _getUserEmail(),
                  customerData: customerData,
                ),
              ),
            );
          },
          image: 'cancel.png',
          name: 'Cancelled',
        ),
        SizedBox(
          height: screenSize.height * .005,
        ),
        MyAccountButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => CartOrderScreen(
                  agentCode: _getAgentCode(),
                  userDatabase: userDatabase,
                  customerData: customerData,
                ),
              ),
            );
          },
          image: 'shopping-cart.png',
          name: 'Cart',
        ),
        SizedBox(
          height: screenSize.height * .005,
        ),
        MyAccountButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => Settings(
                  agentCode: _getAgentCode(),
                ),
              ),
            );
          },
          image: 'settings.png',
          name: 'Settings',
        ),
        SizedBox(
          height: screenSize.height * .005,
        ),
        MyAccountButton(
          onPressed: () async {
            await _buildLogOutModal(context);
          },
          //_signOut,
          image: 'switch.png',
          name: 'Switch Account',
        ),
      ],
    );
  }

  String _getUserFullname() {
    return userDatabase[0]['AgentName'];
  }

  String _getUserEmail() {
    return userDatabase[0]['AgentEmail'];
  }

  String _getUserContact() {
    return userDatabase[0]['AgentContact'].toString();
  }

  String _getInputtedClientName() {
    if (choiceClient == true) {
      return clientName;
    }
    return userDatabase[0]['AgentName'];
  }

  String _getCustomerAddress() {
    if (choiceAgent == true) {
      return agentAddress;
    }
    for (int i = 0; i < customerData.length; i++) {
      if (customerData[i]['CustName'] == clientName) {
        return customerData[i]['CustAdd'];
      }
    }
    return 'Davao City';
  }

  String _getAgentCode() {
    return userDatabase[0]['AgentCode'].toString();
  }

  Future<void> _createOrder(String cName, String aName, String aId) async {
    DateTime now = new DateTime.now();
    month = _formatNumber(now.month);
    day = _formatNumber(now.day);
    year = _formatNumber(now.year);
    hour = _formatNumber(now.hour);
    minute = _formatNumber(now.minute);
    second = _formatNumber(now.second);

    //Get the position
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    longitude = position.longitude.toString();
    latitude = position.latitude.toString();

    //get the total number of order
    _getCartLength().then((value) async {
      //this will execute when the function return something

      int cartLength = value;
      String orderUniqueId = _formatNumber(cartLength);
      String orderNo = '$month$day$year$orderUniqueId';
      String currentDate = '$month/$day/$year $hour:$minute:$second';
      String deliveryAddress = _getCustomerAddress();
      await _dbRef.child('Cart').update({
        cartLength.toString(): {
          'AgentCode': aId,
          'Customer': cName,
          'Location': '$latitude $longitude',
          'OrderNo': orderNo,
          'Date': currentDate,
          'DeliveryAdd': deliveryAddress,
          'Discount': 0,
          'Status': 'Cart',
          'Total': 0,
        }
      });
      Navigator.of(context).pop();
      setState(() {
        choiceClient = false;
        choiceAgent = false;
        textBoxUserNameVisible = false;
        textBoxAgentAddress = false;
        buttonClient = Colors.black;
        buttonAgent = Colors.black;
        clientName = null;
        isLoadingCreateOrder = false;
      });
      return Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => ProductList(
            agentCode: _getAgentCode(),
            orderNo: orderNo,
            userDatabase: userDatabase,
            customerData: customerData,
          ),
        ),
      );
    });
  }

  String _formatNumber(int number) {
    if (number < 10) {
      return '0' + number.toString();
    }
    return number.toString();
  }

  Future<int> _getCartLength() async {
    int cartLength =
        await _dbRef.child('Cart').once().then((DataSnapshot snapshot) {
      return snapshot.value.length;
    });
    return cartLength;
  }

// ignore: non_constant_identifier_names

  Future<void> _buildCreateOrderModal(BuildContext context) async {
    final TextEditingController _textEditingController =
        TextEditingController();
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
                    'Order For:',
                    style: appBar,
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.times,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        choiceClient = false;
                        choiceAgent = false;
                        textBoxUserNameVisible = false;
                        textBoxAgentAddress = false;
                        buttonClient = Colors.black;
                        buttonAgent = Colors.black;
                        clientName = '';
                      });
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
                        MyChoiceModalButton(
                          name: 'CUSTOMER',
                          onPressed: () {
                            setState(() {
                              choiceClient = true;
                              choiceAgent = false;
                              buttonClient = customColor;
                              buttonAgent = Colors.black;
                              textBoxUserNameVisible = true;
                              textBoxAgentAddress = false;
                            });
                          },
                          buttonColor: buttonClient,
                        ),
                        MyChoiceModalButton(
                          name: 'AGENT',
                          onPressed: () {
                            setState(() {
                              choiceAgent = true;
                              choiceClient = false;
                              buttonAgent = customColor;
                              buttonClient = Colors.black;
                              textBoxUserNameVisible = false;
                              textBoxAgentAddress = true;
                            });
                          },
                          buttonColor: buttonAgent,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenSize.height * .03,
                    ),
                    Visibility(
                      visible: textBoxUserNameVisible,
                      child: Container(
                        width: screenSize.width * .6,
                        child: TypeAheadFormField(
                          hideSuggestionsOnKeyboardHide: false,
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: this._typeAheadController,
                            decoration: InputDecoration(
                              hintText: 'Enter Customer\'s Name',
                            ),
                          ),
                          suggestionsCallback: (pattern) {
                            return customerData;
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              leading: Icon(Icons.person_outline),
                              title: Text(suggestion['CustName']),
                              subtitle: Text(suggestion['CustCont']),
                            );
                          },
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            this._typeAheadController.text =
                                suggestion['CustName'];
                          },
                          validator: (value) {
                            return value.isNotEmpty
                                ? null
                                : 'Customer is required!';
                          },
                          onSaved: (value) => this.clientName = value,
                        ),
                        // RaisedButton(
                        //   child: Text('Submit'),
                        //   onPressed: () {
                        //     if (this._formKey.currentState.validate()) {
                        //       this._formKey.currentState.save();
                        //       Scaffold.of(context).showSnackBar(SnackBar(
                        //           content: Text(
                        //               'Your Favorite City is ${this._selectedCustomer}')));
                        //     }
                        //   },
                        // )
                        // child: TextFormField(
                        //   controller: _textEditingController,
                        //   validator: (value) {
                        //     return value.isNotEmpty
                        //         ? null
                        //         : 'Customer is required!';
                        //   },
                        //   onChanged: (value) {
                        //     setState(
                        //       () {
                        //         choiceAgent = false;
                        //         buttonAgent = Colors.black;
                        //         clientName = value;
                        //       },
                        //     );
                        //   },
                        //   decoration: InputDecoration(
                        //     hintText: 'Enter Client\'s Name',
                        //   ),
                        // ),
                      ),
                    ),
                    Visibility(
                      visible: textBoxAgentAddress,
                      child: Container(
                        width: screenSize.width * .6,
                        child: TextFormField(
                          controller: _textEditingController,
                          validator: (value) {
                            return value.isNotEmpty
                                ? null
                                : 'Address is required!';
                          },
                          onChanged: (value) {
                            setState(
                              () {
                                choiceClient = false;
                                buttonClient = Colors.black;
                                agentAddress = value;
                              },
                            );
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Delivery Address',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 65,
                      width: 400,
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 40,
                                  width: 150,
                                  child: IgnorePointer(
                                    ignoring:
                                        isLoadingCreateOrder ? true : false,
                                    child: MyCreateOrderButton(
                                      onPressed: () {
                                        setState(() {
                                          if (_formKey.currentState
                                              .validate()) {
                                            if (choiceClient == true ||
                                                choiceAgent == true) {
                                              isLoadingCreateOrder = true;
                                              _formKey.currentState.save();
                                              _createOrder(
                                                  _getInputtedClientName(),
                                                  _getUserFullname(),
                                                  _getAgentCode());
                                            }
                                          }
                                        });
                                      },
                                      isLoading: isLoadingCreateOrder,
                                      name: 'Create Order',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _buildLogOutModal(BuildContext context) async {
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
                    style: appBar,
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.times,
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
                                text: 'Are you sure you want to',
                              ),
                              TextSpan(
                                text: ' switch account?',
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                                  ignoring: isLoadingLogout ? true : false,
                                  child: MySwitchAccountButton(
                                    onPressed: () {
                                      setState(() {
                                        isLoadingLogout = true;
                                        _signOut();
                                      });
                                    },
                                    isLoading: isLoadingLogout,
                                    name: 'Logout',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.houseUser,
            color: Colors.black,
            size: 25,
          ),
          onPressed: () {},
        ),
        backgroundColor: customColor[10],
        centerTitle: false,
        title: Text(
          'My Account',
          style: appBar,
        ),
      ),
      body: StreamBuilder(
          stream: _dbRef
              .child('Agent')
              .orderByChild('AgentEmail')
              .equalTo(getCurrentUserEmail())
              .onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null) {
              userDatabase = snapshot.data.snapshot.value;
            } else {
              return MySpinKitFadingCube();
            }

            return StreamBuilder(
                stream:
                    _dbRef.child('Customer').orderByChild('CustName').onValue,
                builder: (context, customerDataSnapshot) {
                  if (customerDataSnapshot.hasData &&
                      !customerDataSnapshot.hasError &&
                      customerDataSnapshot.data.snapshot.value != null) {
                    customerData = customerDataSnapshot.data.snapshot.value;
                  } else {
                    return MySpinKitFadingCube();
                  }
                  return SingleChildScrollView(
                    child: Container(
                      height: screenSize.height,
                      width: screenSize.width,
                      color: customColor[20],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildAgentInformation(),
                          _buildMyAccountButton(),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
