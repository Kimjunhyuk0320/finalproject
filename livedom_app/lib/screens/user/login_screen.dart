import 'package:flutter/material.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/config/text_style.dart';
import 'package:livedom_app/screens/myPage/mypage.dart';
import 'package:livedom_app/screens/user/home_view.dart';
import 'package:livedom_app/screens/user/join_screen.dart';
import 'package:livedom_app/widget/custom_back_icon.dart';
import 'package:livedom_app/widget/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.whiteColor,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 15),
          const Padding(
            padding: EdgeInsets.only(left: 14, right: 14),
            child: CustomBackIcon(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
              physics: const ClampingScrollPhysics(),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "LIVE DOM",
                        style: pBold.copyWith(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      hintText: "아이디",
                      controller: TextEditingController(),
                      prefix: const Padding(
                        padding: EdgeInsets.only(
                            left: 22, right: 30, top: 20, bottom: 20),
                      ),
                      sufix: const SizedBox(width: 10),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      hintText: "비밀번호",
                      controller: TextEditingController(),
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
                      onTap: () {
                        // Container를 눌렀을 때 수행할 동작을 여기에 작성
                        // 예: 다른 페이지로 이동하는 코드
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const joinScreen(),
                          ),
                        );
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
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Container(
                          color: Colors.grey,
                          width: 168.0,
                          height: 1.0,
                        ),
                        Container(
                          child: const Center(
                            child: Text(
                              ' OR ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 209, 209, 209),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Color.fromARGB(255, 209, 209, 209),
                          width: 168.0,
                          height: 1.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 360.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(
                            15.0), // 숫자를 조절하여 원하는 둥근 정도를 지정
                      ),
                      child: const Center(
                        child: Text(
                          '카카오 로그인',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 130),
                    GestureDetector(
                      onTap: () {
                        // Container를 눌렀을 때 수행할 동작을 여기에 작성
                        // 예: 다른 페이지로 이동하는 코드
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeView(),
                          ),
                        );
                      },
                      child: const Center(
                        child: Text(
                          '아직 회원이 아니신가요? 회원가입',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
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
    );
  }
}
