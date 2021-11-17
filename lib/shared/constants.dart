import 'package:currencies/currencies.dart';
import 'package:flutter/material.dart';

const TextStyle appBar = TextStyle(
  fontFamily: 'Lato',
  fontSize: 15,
  letterSpacing: 1,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const TextStyle tabText = TextStyle(
  fontFamily: 'Lato',
  fontSize: 11,
  letterSpacing: 1,
  fontWeight: FontWeight.bold,
  color: customColor,
);

const TextStyle bodyText = TextStyle(
  fontFamily: 'Lato',
  fontSize: 11,
  letterSpacing: 1,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

const TextStyle buttonText = TextStyle(
  fontFamily: 'Lato',
  fontSize: 15,
  letterSpacing: 2,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

const TextStyle listStyle = TextStyle(
  fontFamily: 'Lato',
  fontSize: 15,
  letterSpacing: 0,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

const TextStyle roboto = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 15,
  letterSpacing: 1,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
const MaterialColor customColor = MaterialColor(0xffb40311, <int, Color>{
  //default is Custom Red
  10: Color(0xfffed23e), //custom Orange
  20: Color(0xffeff0f5), //custom Grey for background
});

String titleCase(String text) {
  if (text.length <= 1) return text.toUpperCase();
  var words = text.split(' ');
  var capitalized = words.map((word) {
    var first = word.substring(0, 1).toUpperCase();
    var rest = word.substring(1);
    return '$first$rest';
  });
  return capitalized.join(' ');
}

class CurrencySign {
  static String getPesoSym() {
    return currencies[Iso4217Code.php].symbol;
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.inCaps).join(" ");
}
