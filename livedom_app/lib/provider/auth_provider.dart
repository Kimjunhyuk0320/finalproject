import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/users.dart';

// 카카오에서 사용하는 UserProvider과 이름이 같아서 다음과 같이 변경함
// AuthProvider 클래스
class AuthProvider with ChangeNotifier {
  // 로그인 정보
  Users? _currentUser;
  // 로그인 상태
  bool _loginStat = false;

  // getter
  // get : getter 메소드를 정의하는 키워드
  Users? get currentUser => _currentUser; // 전역변수
  bool get isLogin => _loginStat; // 전역변수

  // 안전한 저장소
  final storage = const FlutterSecureStorage();

  late String _authentication;

  // 로그인 요청 메서드
  Future<bool> login(String username, String password) async {
    // 로그인 로직 - 서버에 로그인 요청을 보내고 응답을 처리한다.
    final String apiUrl = 'http://10.0.2.2:8080/login'; // URL

    var headers = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
    };

    try {
      // 전송할 데이터
      Map<String, String> data = {
        'username': username,
        'password': password,
      };

      // 서버로 POST 요청 보내기
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: data,
      );

      print('서버 응답 코드: ${response.statusCode}');
      print('서버 응답 데이터: ${response.headers['authorization']}');
      if (response.statusCode == 200 &&
          response.headers['authorization'] != null) {
        // 응답 데이터가 비어 있는지 확인

        // 쿠키에 ${response.headers['authorization']} accessToken이라는 이름으로 담기
        _authentication = response.headers['authorization'] ?? '';

        if (_authentication != null) {
          final jwtToken = _authentication.replaceFirst('Bearer ', '');
          print("JWT Token: $jwtToken");
          // jwt 저장
          await storage.write(key: 'jwtToken', value: jwtToken);
          _loginStat = true;
        } else {
          print("Authentication 헤더가 없습니다.");
        }
        // loginCheck라는 함수 호출
        getUserInfo();
        notifyListeners();
      } else if (response.statusCode == 403) {
        print('아이디 또는 비밀번호가 일치하지 않습니다.');
      } else {
        print('로그인 실패: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('오류: $e');
    }

    return true;
  }

  // 유저 정보 가져오기
  Future<void> getUserInfo() async {
    var url = 'http://10.0.2.2:8080/users/info';
    // var headersList = {
    //   'Accept': '*/*',
    //   'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
    //   'Authorization': _authentication
    // };
    try {
      String? token = await storage.read(key: 'jwtToken');
      print('사용자 정보 요청 전 : jwt - $token');

      final res = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('사용자 정보 요청 상태코드 - ${res.statusCode}');
      // var req = http.Request('GET', url);
      // req.headers.addAll(headersList);

      // var res = await req.send();
      // final resBody = await res.stream.bytesToString();

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print('테스트');
        // 서버 응답 데이터를 Map으로 파싱
        var utf8Decoded = utf8.decode(res.bodyBytes);
        var result = json.decode(utf8Decoded);
        final userInfo = result;
        print("userInfo : ${userInfo}");
        // Users.fromJson을 사용하여 Users 객체 생성
        Users currentUser = Users.fromJson(userInfo);
        print("currentUser : ${currentUser}");
        // 현재 유저 정보 업데이트
        _currentUser = currentUser;
        notifyListeners();
      } else {
        print(res.reasonPhrase);
      }
    } catch (e) {
      print('사용자 정보 요청 실패 $e');
    }
  }

  // 로그아웃 메서드
  Future<void> logout() async {
    try {
      // ⬅👨‍💼 로그아웃 처리
      // jwt 토큰 삭제
      await storage.delete(key: 'jwtToken');
      // 사용자 정보 초기화
      _currentUser = null;
      // 로그인 상태 초기화
      _loginStat = false;
      print('로그아웃 성공');
    } catch (error) {
      print('로그아웃 실패');
    }
    notifyListeners();
  }

  // loginCheck() 함수
  // 쿠키에서 accessToken 가져오기
  // 앞으로 보낼 요청에 headers에 authentication이름으로 accessToken 세팅
  // Users/userinfo에 get방식으로 요청하기
  // loginsetting함수 호출 - 매개변수로 Users/userinfo 데이터 accessToken 함 넘겨주기

  // loginsetting함수에서 isLogin을 True로 변경해주기
  // 이용할 유저정보를 Users/userinfo 데이터 뽑아서 세팅해주기 (provider에서 사용할 변수)
  // 쿠키에 accessToken 세팅하기

  // 아이디 중복검사 함수
  Future<String> getLoginIdDup(String username) async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)'
    };
    var url = Uri.parse(
        'http://10.0.2.2:8080/api/user/getLoginIdDup?username=$username');

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print('resBody : ${resBody}');
      return resBody;
    } else {
      throw Exception('Failed to check duplicate ID: ${res.reasonPhrase}');
    }
  }

  // 닉네임 중복검사 함수
  Future<String> getNicknameDup(String nickname) async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)'
    };
    var url = Uri.parse(
        'http://10.0.2.2:8080/api/user/getNicknameDup?nickname=$nickname');

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      return resBody;
    } else {
      throw Exception(
          'Failed to check duplicate nickname: ${res.reasonPhrase}');
    }
  }

  // 연락처 중복검사 함수
  Future<String> getPhoneDup(String phone) async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJleHAiOjE3MDM0MTAyODMsInVubyI6IjMiLCJ1aWQiOiJ0ZXN0Iiwicm9sIjpbIlJPTEVfVVNFUiJdfQ.KfCN0e75DORBg140Oe2yJ9AjevY1s5DdgVxRtZQMDH5rxzqA2NO2A1RuwJKmuH0hnuUNGYpEtWivz_9CQrclpA',
      'Content-Type': 'application/json'
    };
    var url =
        Uri.parse('http://localhost:8080/api/user/getPhoneDup?phone=$phone');

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      return resBody;
    } else {
      return "N";
      // throw Exception('Failed to check duplicate phone: ${res.reasonPhrase}');
    }
  }
}
