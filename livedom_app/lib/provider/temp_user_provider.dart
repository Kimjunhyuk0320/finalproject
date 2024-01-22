import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;

class TempUserProvider extends ChangeNotifier {
  // 로그인 정보
  Map<String, Object> _tempUserInfo = {
    'username': 'gangjinsu',
    'name': '강진수',
    'nickname': 'aster',
    'auth': 1,
    'email': 'gangjinsu4@gmail.com',
    'phone': '01025258725',
    'enabled': 1,
    'updDate': '2024-01-08',
    'profileNo': 0,
  };

  Map get userInfo => _tempUserInfo; //전역변수

}
