import 'dart:convert';

import 'package:flutter/material.dart';

// Users 클래스 정의
class Users {
  String? username;
  String? password;
  String? name;
  String? nickname;
  String? phone;
  String? email;
  String? auth;

  Users({
    this.username,
    this.password,
    this.name,
    this.nickname,
    this.phone,
    this.email,
    this.auth,
  });

  // JSON 데이터를 객체로 변환
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      username: json['username'],
      password: json['password'],
      name: json['name'],
      nickname: json['nickname'],
      phone: json['phone'],
      email: json['email'],
      auth: json['authList'][0]['auth'],
    );
  }

  // 회원가입을 위한 팩토리 메서드
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'nickname': nickname,
      'phone': phone,
      'email': email,
      'auth': auth,
    };
  }

  // 로그인 이후 유저 정보 업데이트를 위한 메서드
  void updateUserInfo(Map<String, dynamic> json) {
    // 필요한 경우, 업데이트 로직을 추가
    username = json['username'];
    password = json['password'];
    name = json['name'];
    nickname = json['nickname'];
    phone = json['phone'];
    email = json['email'];
    auth = json['auth'];
  }
}
