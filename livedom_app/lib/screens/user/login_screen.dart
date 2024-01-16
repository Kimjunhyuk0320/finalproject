import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:livedom_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인 페이지'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, user, child) =>
          Container(
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Consumer<UserProvider>(
                        builder: (context, user, child) => 
                          Text("home")
                        ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        elevation: 5
                      ),
                      onPressed: () async {
                        Navigator.pushReplacementNamed(context, "/");
                      },
                    ),
                    user.isLogin ?
                      Container(
                        child: Column(
                          children: [
                            Image.network('${user.userInfo.kakaoAccount?.profile?.thumbnailImageUrl}'),
                            Text('${user.userInfo.kakaoAccount?.profile?.nickname}'),
                          ],
                        ),
                      )
                      : Text(''),
                      ElevatedButton(
                        child: Text(
                          !user.isLogin ? '카카오 로그인' : '로그아웃'
                        ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            elevation: 5
                          ),
                          onPressed: () async{
                            // 카카오 로그인 요청
                            // provider 로 부터 사용자 정보 가져와서 확인
                            var user = context.read<UserProvider>();

                            // 로그인 여부 확인
                            user.loginCheck();

                            // 비로그인 시 -> 로그인 요청
                            if( !await user.isLogin){
                            // 사용자 조건 : 카카오톡 설치 여부
                              await isKakaoTalkInstalled() ? user.kakoTalkLogin() : user.kakoLogin();
                            }else{
                              // 이미 로그인 된 상태 -> 로그아웃 화면
                              user.kakoLogout();
                              Navigator.pushReplacementNamed(context, "/logout");

                            }
                          },
                      )
                  ],
                ),
              ),
            ),
          ),
      )
    );
  }
}