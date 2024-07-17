import 'package:flutter/material.dart';

abstract class AppTextStyle {
  static final TextStyle largeTitleStyle = const TextStyle(
    fontSize: 32,
    height: 38 / 32,
    fontWeight: FontWeight.bold,
    fontFamily: "Roboto",
  );
  static final TextStyle titleStyle = const TextStyle(
    fontSize: 20,
    height: 32 / 20,
    fontWeight: FontWeight.bold,
    fontFamily: "Roboto",
  );
  static final buttonStyle = const TextStyle(
    fontSize: 14,
    height: 24 / 14,
    fontWeight: FontWeight.bold,
    fontFamily: "Roboto",
  );
  static final TextStyle bodyStyle = const TextStyle(
    fontSize: 16,
    height: 20 / 16,
    fontFamily: "Roboto",
  );
  static final TextStyle subheadStyle = const TextStyle(
    fontSize: 14,
    height: 20 / 14,
    fontFamily: "Roboto",
  );
}
