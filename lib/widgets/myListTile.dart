import 'package:edq/screens/detailSettings.dart';
import 'package:edq/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyAccountInformationListTile extends StatelessWidget {
  final String leading;
  final String title;
  MyAccountInformationListTile({this.leading, this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => DetailSettings(
              leading: leading,
              title: title,
            ),
          ),
        );
      },
      child: ListTile(
        leading: Text(
          leading,
          style: appBar.copyWith(
            letterSpacing: 1,
            fontSize: 15,
          ),
        ),
        title: Text(
          title,
          style: appBar.copyWith(
            letterSpacing: 0,
            fontSize: 13,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.end,
        ),
        trailing: IconButton(
          icon: FaIcon(FontAwesomeIcons.angleRight),
          color: Colors.black,
          onPressed: () {},
        ),
      ),
    );
  }
}
