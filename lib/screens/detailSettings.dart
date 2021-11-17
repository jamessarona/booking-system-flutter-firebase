import 'package:edq/shared/constants.dart';
import 'package:flutter/material.dart';

class DetailSettings extends StatefulWidget {
  final String leading;
  final String title;
  DetailSettings({this.leading, this.title});
  @override
  _DetailSettingsState createState() => _DetailSettingsState();
}

class _DetailSettingsState extends State<DetailSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customColor[10],
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
        title: Text(
          widget.leading,
          style: appBar,
        ),
      ),
      body: Container(),
    );
  }
}
