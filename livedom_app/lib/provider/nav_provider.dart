import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';

class NavProvider with ChangeNotifier {
  int _navIndex = 2;

  int get navIndex => _navIndex;


  set navIndex(int index) {
    _navIndex = index;
  }
}
