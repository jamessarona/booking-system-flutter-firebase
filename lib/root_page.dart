import 'package:edq/net/firebase_auth.dart';
import 'package:edq/screens/screenAccount.dart';
import 'package:edq/screens/screenAuthentication.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  final BaseAuth auth;
  Root({this.auth});
  @override
  _RootState createState() => _RootState();
}

enum AuthSatus { notSignedIn, signedIn }

class _RootState extends State<Root> {
  AuthSatus _authSatus = AuthSatus.notSignedIn;

  //check the current status of the user on start of the app
  //called before statefull widget
  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        _authSatus =
            userId == null ? AuthSatus.notSignedIn : AuthSatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      _authSatus = AuthSatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authSatus = AuthSatus.notSignedIn;
    });
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (_authSatus) {
      case AuthSatus.notSignedIn:
        return new Authentication(
          auth: widget.auth,
          onSignIn: _signedIn,
        );
      case AuthSatus.signedIn:
        return new Account(
          auth: widget.auth,
          onSignOut: _signedOut,
        );
    }
  }
}
