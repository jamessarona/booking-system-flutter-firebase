import 'package:edq/net/firebase_auth.dart';
import 'package:edq/root_page.dart';
import 'package:edq/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: customColor,
        primaryColor: customColor,
      ),
      home: Root(
        auth: new FireBaseAuth(),
      ),
    );
  }
}
