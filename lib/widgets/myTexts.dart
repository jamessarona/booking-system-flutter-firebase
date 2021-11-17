import 'package:edq/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyItemDescription extends StatelessWidget {
  final String name;
  final String title;
  MyItemDescription({this.name, this.title});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: screenSize.height * .01),
        Text(
          '$title: $name',
          style: appBar.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            letterSpacing: 0,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

class MySubTextCartCard extends StatelessWidget {
  final String name;
  MySubTextCartCard({this.name});
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * .02,
      width: screenSize.width * .33,
      child: Text(
        name,
        style: bodyText.copyWith(letterSpacing: 0),
        maxLines: 1,
      ),
    );
  }
}
