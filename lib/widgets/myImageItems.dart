import 'package:flutter/material.dart';

class MySmallItemImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 100,
      child: Image(
        image: AssetImage(
          "assets/no-image.jpg",
        ),
        height: 200,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
