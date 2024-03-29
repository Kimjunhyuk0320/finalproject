import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/config/images.dart';
import 'package:livedom_app/config/text_style.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/auth_provider.dart';
import 'package:livedom_app/provider/user_provider.dart';
import 'package:livedom_app/screens/myPage/mypage.dart';
import 'package:livedom_app/screens/user/bottem_nav.dart';
import 'package:livedom_app/screens/user/home_view.dart';
import 'package:livedom_app/screens/user/join_screen.dart';
import 'package:livedom_app/widget/custom_back_icon.dart';
import 'package:livedom_app/widget/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Future<void> login() async {
  //   try {
  //     // Provider에서 로그인 처리
  //     await Provider.of<UserProvider>(context, listen: false)
  //         .login(usernameController.text, passwordController.text);

  //     // 이후 로그인 성공 후의 동작을 여기에 추가하면 됩니다.
  //     // 예: Navigator.push(...)
  //   } catch (error) {
  //     print('로그인 실패: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.whiteColor,
      body: WillPopScope(
        onWillPop: () async {
          // 뒤로가기 이벤트를 항상 무시하고 페이지에서 나가지 않음
          return false;
        },
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 15),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: CustomBackIcon(),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "LIVE DOM",
                            style: pBold.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomTextField(
                          hintText: "아이디",
                          controller: usernameController,
                          onChanged: (value) {
                            print('[회원기입] - 아이디 : $value');
                            usernameController.text = value;
                          },
                          prefix: const Padding(
                            padding: EdgeInsets.only(
                                left: 22, right: 30, top: 20, bottom: 20),
                          ),
                          sufix: const SizedBox(width: 10),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: "비밀번호",
                          obscureText: true,
                          controller: passwordController,
                          onChanged: (value) {
                            print('[회원기입] - 비밀번호 : $value');
                            passwordController.text = value;
                          },
                          prefix: const Padding(
                            padding: EdgeInsets.only(
                                left: 22, right: 14, top: 12, bottom: 12),
                            // child: SvgPicture.asset(
                            //   DefaultImages.a2,
                            // ),
                          ),
                          sufix: const Padding(
                            padding:
                                EdgeInsets.only(right: 22, top: 12, bottom: 12),
                            // child: SvgPicture.asset(
                            //   DefaultImages.a3,
                            // ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        InkWell(
                          onTap: () async {
                            String username = usernameController.text;
                            String password = passwordController.text;

                            print('사용자 이름: $username');
                            print('비밀번호: $password');

                            try {
                              // Provider에서 로그인 처리
                              bool loginStatus =
                                  await Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .login(username, password);

                              if (loginStatus) {
                                // 로그인 성공 시 페이지 이동
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainScreen(),
                                  ),
                                );
                              }
                              // 로그인 실패 : 아이디 및 비번 불일치 등
                              else {
                                // 로그인 실패 시 알림창 띄우기
                                showCustomAlertDialog(
                                    context, "로그인 오류 :(", "아이디와 비밀번호를 확인해주세요.");
                              }
                            } catch (error) {
                              print('로그인 실패: $error');
                            }
                          },
                          child: Container(
                            width: 360.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: const Center(
                              child: Text(
                                '로그인',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                color: Colors.grey,
                                height: 1.0,
                              ),
                            ),
                            Container(
                              child: const Center(
                                child: Text(
                                  '   OR   ',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 209, 209, 209),
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.grey,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Consumer<UserProvider>(
                          builder: (context, user, child) {
                            return GestureDetector(
                              onTap: () async {
                                print('카카오로그인 진입');
                                var user = context.read<UserProvider>();

                                // ✔ 로그인 여부 확인
                                user.loginCheck();

                                // 비로그인 시 ➡ 로그인 요청
                                if (!await user.isLogin) {
                                  // 사용자 조건 : 카카오톡 설치 여부
                                  await isKakaoTalkInstalled()
                                      ? user.kakoTalkLogin()
                                      : user.kakoLogin();
                                } else {
                                  // 이미 로그인된 상태 ➡ 로그인 화면
                                  Navigator.pushReplacementNamed(
                                      context, "/logout");
                                }
                              },
                              child: Container(
                                width: 360.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(
                                      15.0), // 숫자를 조절하여 원하는 둥근 정도를 지정
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // 이미지 추가
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const ShapeDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            DefaultImages.kakaoLogo,
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                        shape: OvalBorder(),
                                      ),
                                    ),

                                    // 간격을 주기 위한 SizedBox
                                    SizedBox(width: 8.0),

                                    // 텍스트 추가
                                    Center(
                                      child: Text(
                                        '카카오 로그인',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 130),
                        GestureDetector(
                          onTap: () async {
                            String username = '사용자 이름';
                            String password = '비밀번호';

                            // Provider를 사용하여 로그인 메서드를 호출합니다.
                            Provider.of<AuthProvider>(context, listen: false)
                                .login(username, password);
                            // Container를 눌렀을 때 수행할 동작을 여기에 작성
                            // 예: 다른 페이지로 이동하는 코드
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JoinScreen(),
                              ),
                            );
                          },
                          child: const Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '아직 회원이 아니신가요? ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '회원가입',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 통합 알림창
      ),
    );
  }
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
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      );
    },
  );
}
