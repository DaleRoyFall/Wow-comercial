import 'package:flutter/material.dart';

// Class that stock data about resize screen
class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  // Save area
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    // Extract sceen width and height
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    // Determine save area
    double _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;

    double _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    // And get save block
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  static double adaptHeight(double height) {
    return safeBlockVertical * height;
  }

  static double adaptWidth(double width) {
    return safeBlockHorizontal * width;
  }

  static double adaptFontSize(double fontSize) {
    return safeBlockHorizontal * fontSize;
  }
}
