import 'package:flutter/material.dart';

abstract class AppTextStyle {
  static const TextStyle largeTitleStyle = TextStyle(
    fontSize: 32,
    height: 38 / 32,
    fontWeight: FontWeight.bold,
    fontFamily: "Roboto",
  );
  static const TextStyle titleStyle = TextStyle(
    fontSize: 20,
    height: 32 / 20,
    // fontWeight: FontWeight.bold,
    fontFamily: "Roboto",
  );
  static const buttonStyle = TextStyle(
    fontSize: 14,
    height: 24 / 14,
    fontWeight: FontWeight.bold,
    fontFamily: "Roboto",
  );
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontFamily: "Roboto",
  );
  static const TextStyle subheadStyle = TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontFamily: "Roboto",
  );
}
