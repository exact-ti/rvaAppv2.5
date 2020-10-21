import 'package:flutter/material.dart';
import 'package:rvaapp/src/Util/utils.dart';

class ReusableWidgets {

  static getAppBar(String title) {
    return AppBar(
          backgroundColor: PrimaryColor,
          title: Text('$title',
              style: TextStyle(
                  fontSize: 18,
                  decorationStyle: TextDecorationStyle.wavy,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.normal)),
    );
  }

}