import 'package:edq/net/firebase_auth.dart';
import 'package:edq/shared/constants.dart';
import 'package:edq/widgets/mytextformField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/mybuttons.dart';
import '../net/firebase_auth.dart';

class Authentication extends StatefulWidget {
  final VoidCallback onSignIn;
  final BaseAuth auth;
  Authentication({this.auth, this.onSignIn});
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  Size screenSize;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final emailHolder = TextEditingController();
  String regEx =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  bool obserText = true;
  String email;
  String password;
  String errorOnLogIn = '';
  bool authIsNotValid;
  bool _isLoading = false;

  void validation() async {
    String userId;
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        setState(() {
          authIsNotValid = false;
        });
        userId = await widget.auth.signInWithEmailAndPassword(email, password);
        if (userId != null) {
          widget.onSignIn();
        }
        //widget.onSignIn();
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'wrong-password') {
          setState(() {
            errorOnLogIn = 'Password is incorrect!';
            authIsNotValid = true;
          });
        } else {
          setState(() {
            errorOnLogIn = 'Email does not exist!';
            authIsNotValid = true;
          });
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: customColor[10],
          title: Text(
            'Login Account',
            style: appBar,
          ),
          bottom: PreferredSize(
            child: TabBar(
              isScrollable: false,
              unselectedLabelColor: Colors.black.withOpacity(0.3),
              labelColor: customColor,
              indicatorColor: customColor,
              tabs: [
                Row(
                  children: [
                    Container(
                      width: screenSize.width * .5,
                      child: Tab(
                        icon: Icon(
                          Icons.login,
                          color: customColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            preferredSize: Size.fromHeight(30.0),
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    color: customColor[20],
                  ),
                  Positioned(
                    top: 10,
                    child: Container(
                      height: screenSize.height,
                      width: screenSize.width,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: screenSize.height * .07,
                    left: screenSize.width * .1,
                    bottom: screenSize.height * .1,
                    right: screenSize.width * .1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image(
                            image: AssetImage(
                              "assets/edq-logo.png",
                            ),
                            height: 100,
                          ),
                          MyTextFormField(
                            hintname: 'someting@email.com',
                            name: 'Email',
                            onChanged: (value) {
                              setState(
                                () {
                                  email = value;
                                },
                              );
                            },
                            validation: (value) {
                              if (value == '') {
                                return 'Please Fill Email';
                              } else if (!RegExp(regEx).hasMatch(value)) {
                                return 'Invalid Email';
                              }
                              return null;
                            },
                            emailController: emailHolder,
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                          ),
                          PasswordTextFormField(
                            obserText: obserText,
                            name: 'Password',
                            onChanged: (value) {
                              setState(
                                () {
                                  password = value;
                                },
                              );
                            },
                            validation: (value) {
                              if (value == '') {
                                return 'Please Fill Password';
                              }
                              return null;
                            },
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              setState(
                                () {
                                  obserText = !obserText;
                                },
                              );
                            },
                            shortCutLoginButton: (term) {
                              validation();
                            },
                          ),
                          SizedBox(
                            height: screenSize.height * 0.02,
                          ),
                          SizedBox(
                            height: screenSize.height * 0.03,
                            child: authIsNotValid == true
                                ? Text(
                                    errorOnLogIn,
                                    style: bodyText.copyWith(
                                      fontSize: 12,
                                      color: customColor,
                                    ),
                                  )
                                : null,
                          ),
                          IgnorePointer(
                            ignoring: _isLoading ? true : false,
                            child: MyButton(
                              onPressed: () {
                                validation();
                              },
                              name: 'Login',
                              isLoading: _isLoading,
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * .1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
