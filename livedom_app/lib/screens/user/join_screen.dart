import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/screens/user/home_view.dart';
import 'package:livedom_app/screens/user/login_screen.dart';
import 'package:livedom_app/widget/custom_button.dart';
import 'package:livedom_app/widget/custom_textfield.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

// 페이지 1 - 아이디 설정
class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController usernameController = TextEditingController();

  // 아이디 유효성 검사 함수
  bool isValidUsername(String username) {
    // 정규표현식을 사용하여 유효성 검사
    RegExp regExp = RegExp(r'^[a-zA-Z0-9]+$');
    return regExp.hasMatch(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('1/6'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  '아이디를 설정해주세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  '아이디는 5글자 이상으로 설정해주세요',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "아이디",
                  controller: usernameController,
                  onChanged: (value) {
                    print('[회원기입] - 아이디 : $value');
                    usernameController.text = value;
                  },
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.account_circle, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 420),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  text: "다음",
                  onTap: () async {
                    // 입력된 아이디
                    String username = usernameController.text;
                    if (username.length <= 5) {
                      showCustomAlertUsernameLenthDialog(context);
                      return;
                    }
                    // 입력된 값이 없다면 다음 함수 실행
                    if (username == '') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('알림'),
                            content: Text('아이디를 설정해주세요.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // 팝업 닫기
                                },
                                child: Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                    // 아이디 유효성 검사 추가
                    if (!isValidUsername(usernameController.text)) {
                      // 유효하지 않은 경우 팝업 표시
                      showInvalidUsernamePopup(context);
                      return;
                    }

                    // 프로바이더에 저장된 아이디 중복검사
                    try {
                      String loginStatus = await Provider.of<AuthProvider>(
                              context,
                              listen: false)
                          .getLoginIdDup(username);

                      if (loginStatus == 'N') {
                        // 회원 아이디가 없는 경우
                        showCustomAlertDialog(context);
                      }
                      // 회원 아이디가 없는 경우
                      else {
                        // 로그인 실패 시 알림창 띄우기
                        Users inputUser = Users();
                        inputUser.username = usernameController.text;
                        Navigator.pushNamed(
                          context,
                          '/join/pw',
                          arguments: inputUser,
                        );
                      }
                    } catch (error) {
                      print('로그인 실패: $error');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 아이디 유효성 검사 실패 팝업
  void showInvalidUsernamePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              // decoration: BoxDecoration(
              //   color: Colors.transparent, // 배경을 투명하게 설정
              //   borderRadius: BorderRadius.circular(16.0),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.3),
              //       spreadRadius: 2,
              //       blurRadius: 8,
              //       offset: Offset(0, 3),
              //     ),
              //   ],
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "특수문자 포함 :(",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "영문과 숫자로만 설정할 수 있어요",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.black,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //   ),
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  //     child: Text(
                  //       '확인',
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 아이디 글자수 알림창
  void showCustomAlertUsernameLenthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              // decoration: BoxDecoration(
              //   color: Colors.transparent, // 배경을 투명하게 설정
              //   borderRadius: BorderRadius.circular(16.0),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.3),
              //       spreadRadius: 2,
              //       blurRadius: 8,
              //       offset: Offset(0, 3),
              //     ),
              //   ],
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "글자수 5글자 미만 :(",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "5글자 이상으로 설정해주세요.",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.black,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //   ),
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  //     child: Text(
                  //       '확인',
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 아이디 중복 알림창
  void showCustomAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              // decoration: BoxDecoration(
              //   color: Colors.transparent, // 배경을 투명하게 설정
              //   borderRadius: BorderRadius.circular(16.0),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.3),
              //       spreadRadius: 2,
              //       blurRadius: 8,
              //       offset: Offset(0, 3),
              //     ),
              //   ],
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "아이디 중복 :(",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "다른 아이디로 설정해주세요.",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.black,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //   ),
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  //     child: Text(
                  //       '확인',
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// 페이지 2 - 비밀번호 설정
class JoinPwScreen extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();

  // 비밀번호 유효성 검사 함수
  bool isPasswordValid(String password) {
    // 비밀번호는 대문자, 소문자, 특수문자를 포함하고 8글자 이상이어야 함
    final RegExp regex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return regex.hasMatch(password);
  }

  // 비밀번호 확인 검사 함수
  bool isPasswordCheck(String password, String passwordcheck) {
    if (password == passwordcheck) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Users?;
    // print('JoinScreen -> JoinPwSreen : ${user?.username}');

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('2/6'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  '비밀번호를 설정해주세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '비밀번호는 ',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '대문자',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '와 ',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '소문자,',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '특수문자',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '를 \n포함하고 ',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '8글자 이상',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '으로 설정해주세요.',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "비밀번호",
                  obscureText: true, // 비밀번호 숨기기 설정
                  controller: passwordController,
                  onChanged: (value) {
                    print('[회원기입] - 비밀번호 : $value');
                    passwordController.text = value;
                  },
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.lock, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "비밀번호 확인",
                  controller: passwordCheckController,
                  onChanged: (value) {
                    print('[회원기입] - 비밀번호 확인 : $value');
                    passwordCheckController.text = value;
                  },
                  obscureText: true, // 비밀번호 숨기기 설정
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.lock, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 320),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  text: "다음",
                  onTap: () {
                    // 입력된 비밀번호
                    String password = passwordController.text;
                    String passwordCheck = passwordCheckController.text;

                    // 비밀번호 유효성 검사
                    if (!isPasswordValid(password)) {
                      // 비밀번호가 유효하지 않을 때 팝업 표시
                      showInvalidUsernamePopup(context);
                      return; // 이후 코드 실행을 중지
                    }

                    // 비밀번호 확인 검사
                    if (!isPasswordCheck(password, passwordCheck)) {
                      // 두 비밀번호가 일치하지 않을 때 팝업 표시
                      showPasswordCheckPopup(context);
                      return; // 이후 코드 실행 중지
                    }

                    // 유효성 검사를 실시한 후 다음 화면으로 이동하는 코드
                    Users? inputUser = user;
                    inputUser?.password = passwordController.text;
                    Navigator.pushNamed(
                      context,
                      '/join/name',
                      arguments: inputUser,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 비밀번호 유효성 검사 팝업
  void showInvalidUsernamePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              // decoration: BoxDecoration(
              //   color: Colors.transparent, // 배경을 투명하게 설정
              //   borderRadius: BorderRadius.circular(16.0),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.3),
              //       spreadRadius: 2,
              //       blurRadius: 8,
              //       offset: Offset(0, 3),
              //     ),
              //   ],
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  SizedBox(height: 15.0),
                  Text(
                    "유효하지 않는 비밀번호 :(",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "대문자와 소문자, 특수문자를 포함하여 \n설정해주세요.",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.black,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //   ),
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  //     child: Text(
                  //       '확인',
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 비밀번호 불일치 검사 팝업
  void showPasswordCheckPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              // decoration: BoxDecoration(
              //   color: Colors.transparent, // 배경을 투명하게 설정
              //   borderRadius: BorderRadius.circular(16.0),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.3),
              //       spreadRadius: 2,
              //       blurRadius: 8,
              //       offset: Offset(0, 3),
              //     ),
              //   ],
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "아이디가 중복되었네요 :(",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "다른 아이디로 설정해주세요.",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.black,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //   ),
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  //     child: Text(
                  //       '확인',
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// 페이지 3 - 닉네임, 이름 설정
class JoinNameScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Users?;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('3/6'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  '이름과 별명을 설정해주세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '이름',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '은 ',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '실명',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '을 작성해주세요. \n',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '(*티켓 구매시 불이익을 받을 수 있습니다.)',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "이름",
                  controller: nameController,
                  onChanged: (value) {
                    print('[회원기입] - 이름 : $value');
                    nameController.text = value;
                  },
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.person, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "별명",
                  controller: nicknameController,
                  onChanged: (value) {
                    print('[회원기입] - 닉네임 : $value');
                    nicknameController.text = value;
                  },
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.sentiment_satisfied, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 320),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  text: "다음",
                  onTap: () async {
                    // 입력된 이름과 별명
                    String name = nicknameController.text;
                    String nickname = nicknameController.text;
                    // 입력된 값이 없다면 다음 함수 실행
                    if (name == '' || nickname == '') {
                      showCustomAlertDialog(
                          context, "필수가입항목 :(", "필수가입항목을 작성해주세요.");
                      return;
                    }
                    // 프로바이더에 저장된 닉네임 중복검사
                    try {
                      String loginStatus = await Provider.of<AuthProvider>(
                              context,
                              listen: false)
                          .getNicknameDup(nickname);

                      if (loginStatus == 'Y') {
                        // Provider에 정의해둔 User객체에 넣어줌.
                        Users? inputUser = user;
                        inputUser?.name = nameController.text;
                        inputUser?.nickname = nicknameController.text;
                        Navigator.pushNamed(
                          context,
                          '/join/phone',
                          arguments: inputUser,
                        );
                      }
                      // 닉네임 중복이 되지 않는 경우
                      else {
                        // 닉네임이 있는 경우
                        showCustomAlertDialog(
                            context, "별명 중복 :(", "다른 별명을 작성해주세요.");
                      }
                    } catch (error) {
                      print('로그인 실패: $error');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 통합 알림창
  void showCustomAlertDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              // decoration: BoxDecoration(
              //   color: Colors.transparent, // 배경을 투명하게 설정
              //   borderRadius: BorderRadius.circular(16.0),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.3),
              //       spreadRadius: 2,
              //       blurRadius: 8,
              //       offset: Offset(0, 3),
              //     ),
              //   ],
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.black,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //   ),
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  //     child: Text(
                  //       '확인',
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// 페이지 4 - 연락처 설정
class JoinPhoneScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  // 전화번호 유효성 검사 함수
  bool isValidPhoneNumber(String phoneNumber) {
    // 정규표현식을 사용하여 유효성 검사
    RegExp regExp = RegExp(r'^\d{11}$');
    return regExp.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Users?;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('4/6'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  '연락처를 설정해주세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '연락처는 (-)기호를 제외하고 설정해주세요.\n',
                        style: TextStyle(
                          color: Color(0xFF8D8D8D),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w200,
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: '(*다른 연락처를 작성시 불이익을 받을 수 있습니다.)',
                        style: TextStyle(
                          color: Color(0xFF8D8D8D),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w200,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "01012345678",
                  keyboardType: TextInputType.number,
                  controller: phoneController,
                  onChanged: (value) {
                    print('[회원기입] - 연락처 : $value');
                    phoneController.text = value;
                  },
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.phone, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 390),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  text: "다음",
                  onTap: () async {
                    String phone = phoneController.text;
                    // 연락처 유효성 검사
                    if (!isValidPhoneNumber(phoneController.text)) {
                      // 유효하지 않은 경우의 처리
                      showCustomAlertDialog(context, "연락처 형식 :(",
                          "연락처의 형식에 알맞지 않습니다.\n(예시 : 01012341234)");
                      return;
                    }
                    // 연락처 중복검사
                    // 프로바이더에 저장된 닉네임 중복검사
                    try {
                      String loginStatus = await Provider.of<AuthProvider>(
                              context,
                              listen: false)
                          .getNicknameDup(phone);

                      if (loginStatus == 'N') {
                        // Provider에 정의해둔 User객체에 넣어줌.
                        print("sadofuhsdlkfh");
                        showCustomAlertDialog(
                            context, "연락처 중복 :(", "다른 연락처를 작성해주세요.");
                      }
                      // 연락처 중복이 되지 않는 경우
                      else {
                        // 연락처이 있는 경우
                        user?.phone = phoneController.text;
                        Navigator.pushNamed(
                          context,
                          '/join/email',
                          arguments: user,
                        );
                      }
                    } catch (error) {
                      print('로그인 실패: $error');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 통합 알림창
  void showCustomAlertDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              // decoration: BoxDecoration(
              //   color: Colors.transparent, // 배경을 투명하게 설정
              //   borderRadius: BorderRadius.circular(16.0),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.3),
              //       spreadRadius: 2,
              //       blurRadius: 8,
              //       offset: Offset(0, 3),
              //     ),
              //   ],
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.black,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //   ),
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  //     child: Text(
                  //       '확인',
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// 페이지 5 - 이메일 설정
class JoinEmailScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  // 이메일 유효성 검사 함수
  bool isValidEmail(String email) {
    // 정규표현식을 사용하여 유효성 검사
    RegExp regExp = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return regExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Users?;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('5/6'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  '이메일을 설정해주세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '이메일을 작성해주세요. \n',
                        style: TextStyle(
                          color: Color(0xFF8D8D8D),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w200,
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: '(*다른 이메일을 작성시 불이익을 받을 수 있습니다.)',
                        style: TextStyle(
                          color: Color(0xFF8D8D8D),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w200,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "example@mail.com",
                  controller: emailController,
                  onChanged: (value) {
                    print('[회원기입] - 이름 : $value');
                    emailController.text = value;
                  },
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.phone, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 390),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  text: "다음",
                  onTap: () {
                    // 이메일 유효성 검사 추가
                    if (!isValidEmail(emailController.text)) {
                      // 유효하지 않은 경우 팝업 표시
                      showCustomAlertDialog(
                          context, "이메일 형식 :(", "올바른 이메일 형식으로 입력해주세요.");
                      return;
                    }

                    user!.email = emailController.text;
                    Navigator.pushNamed(
                      context,
                      '/join/auth',
                      arguments: user,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 통합 알림창
  void showCustomAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              // decoration: BoxDecoration(
              //   color: Colors.transparent, // 배경을 투명하게 설정
              //   borderRadius: BorderRadius.circular(16.0),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.3),
              //       spreadRadius: 2,
              //       blurRadius: 8,
              //       offset: Offset(0, 3),
              //     ),
              //   ],
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.black,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //   ),
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  //     child: Text(
                  //       '확인',
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// 페이지 6 - 권한 선택 페이지
class JoinAuthScreen extends StatefulWidget {
  @override
  JoinAuthScreenState createState() => JoinAuthScreenState();
}

class JoinAuthScreenState extends State<JoinAuthScreen> {
  void selectPermission(String permission) {
    setState(() {
      selectedPermission = permission;
    });
  }

  String selectedPermission = ''; // 선택된 권한

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Users?;
    // final TextEditingController authController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('6/6'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    '아래에 해당하는 \n권한을 설정해주세요.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '하나의 권한을 선택해주세요.',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PermissionButton(
                  permission: '유저권한',
                  isSelected: selectedPermission == '유저권한',
                  onSelect: () => selectPermission('유저권한'),
                ),
                PermissionButton(
                  permission: '밴드권한',
                  isSelected: selectedPermission == '밴드권한',
                  onSelect: () => selectPermission('밴드권한'),
                ),
                PermissionButton(
                  permission: '클럽권한',
                  isSelected: selectedPermission == '클럽권한',
                  onSelect: () => selectPermission('클럽권한'),
                ),
                const SizedBox(height: 30),
                Text(
                  selectedPermission.isEmpty
                      ? '권한을 선택하지 않았습니다.'
                      : '"$selectedPermission"을 선택하였습니다',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomButton(
                    text: "가입 완료",
                    onTap: () {
                      if (selectedPermission == '') {
                        showCustomAlertDialog(
                            context, "권한 설정 :(", "선택한 권한이 없습니다.");
                        return;
                      }

                      if (user != null) {
                        if (selectedPermission == "유저권한") {
                          user.auth = '0';
                        } else if (selectedPermission == "클럽권한") {
                          user.auth = '1';
                        } else if (selectedPermission == "밴드권한") {
                          user.auth = '2';
                        }

                        print('User객체 확인 아이디 : ${user.username}');
                        print('User객체 확인 비번 : ${user.password}');
                        print('User객체 확인 실명 : ${user.name}');
                        print('User객체 확인 닉네임 : ${user.nickname}');
                        print('User객체 확인 연락처 : ${user.phone}');
                        print('User객체 확인 이메일 : ${user.email}');
                        print('User객체 확인 권한 : ${user.auth}');
                      }

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (route) => false, // 이전 페이지가 없도록 설정
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 통합 알림창
  void showCustomAlertDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(20.0),
              // decoration: BoxDecoration(
              //   color: Colors.transparent, // 배경을 투명하게 설정
              //   borderRadius: BorderRadius.circular(16.0),
              //   boxShadow: [
              //     BoxShadow(
              //       color: Colors.grey.withOpacity(0.3),
              //       spreadRadius: 2,
              //       blurRadius: 8,
              //       offset: Offset(0, 3),
              //     ),
              //   ],
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Colors.black,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12.0),
                  //     ),
                  //   ),
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  //     child: Text(
                  //       '확인',
                  //       style: TextStyle(
                  //         fontSize: 18.0,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// 권한 설정 선택 버튼 관련
class PermissionButton extends StatelessWidget {
  final String permission;
  final bool isSelected;
  final VoidCallback onSelect;

  PermissionButton({
    required this.permission,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8), // 여백을 조절하려면 여기서 조절합니다.
      child: ElevatedButton(
        onPressed: onSelect,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Color.fromRGBO(16, 24, 39, 1)
              : ConstColors.lightGrayColor,
          onPrimary: isSelected ? Colors.white : Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            // side: BorderSide(color: Colors.grey),
          ),
          minimumSize: Size(320, 100),
        ),
        child: Text(
          permission,
          style: const TextStyle(
            // color: Color.fromRGBO(0, 0, 0, 1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
