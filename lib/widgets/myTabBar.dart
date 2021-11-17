import 'package:flutter/material.dart';

class MyStabBar extends StatelessWidget {
  final String tabBarName;
  MyStabBar({this.tabBarName});
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        tabBarName,
      ),
    );
  }
}
