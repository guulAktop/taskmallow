import 'package:flutter/material.dart';

class UIHelper {
  static double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static isDevicePortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait ? true : false;
  }
}
