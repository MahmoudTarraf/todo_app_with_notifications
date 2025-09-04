import 'package:flutter/material.dart';

class MySize {
  //padding and margin
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  //icon size
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;

  //font size
  static const double fontSizeSm = 12.0;
  static const double fontSizeMD = 14.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXlg = 22.0;
  //button size
  //appbar height
  static screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
