import 'package:edq/shared/constants.dart';
import 'package:flutter/material.dart';

class NoDataFound extends StatelessWidget {
  final String name;
  NoDataFound({this.name});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(name, style: appBar.copyWith(color: Colors.grey)),
    );
  }
}
