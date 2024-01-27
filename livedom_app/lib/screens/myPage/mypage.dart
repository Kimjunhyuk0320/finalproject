import 'package:flutter/material.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/auth_provider.dart';
import 'package:livedom_app/provider/nav_provider.dart';
import 'package:provider/provider.dart';

import '../../config/colors.dart';
import '../../config/text_style.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  int _navIndex = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      int tempIndex = Provider.of<NavProvider>(context, listen: false).navIndex;
      setState(() {
        _navIndex = tempIndex;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end, // 세로 정렬
          // crossAxisAlignment: CrossAxisAlignment.start, // 가로 정렬
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: Image.asset(
                    'images/main9.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Text(
                    'LIVE DOM ',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SafeArea(
                  top: true,
                  child: AppBar(
                    title: const Text(
                      '마이페이지',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new),
                      onPressed: () {
                        Navigator.of(context).pop(); // 뒤로가기 기능
                      },
                      color: Colors.white, // 뒤로가기 버튼 색상
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            // 광고
            // Container(
            //   child: Image.asset(
            //     'images/adver.png',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // 받은쿠폰
                        Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "받은 쿠폰",
                      style: pSemiBold20.copyWith(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(width: 5), // 간격 조절
                  Text(
                    "4",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 400.0, // 가로 크기 (옵션)
              height: 100.0, // 세로 크기 (옵션)
              // color: Colors.yellow, // 배경색
              // margin: EdgeInsets.all(16.0), // 외부 여백
              padding: EdgeInsets.symmetric(
                  horizontal: 30.0, vertical: 0.0), // 내부 여백
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // 수평 스크롤
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // 가로 정렬
                  children: [
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Navigator.pushNamed(context, "/userinfo");
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(100, 80),
                                padding: EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Color(0xFF0E1828),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.workspace_premium,
                                    color: Colors.white,
                                    size: 40,
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Navigator.pushNamed(context, "/userinfo");
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(100, 80),
                                padding: EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Color(0xFF0E1828),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.diamond,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(100, 80),
                                padding: EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Color.fromARGB(255, 244, 244, 244),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.emoji_events,
                                    color: Colors.black,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                // Navigator.pushNamed(context, "/userinfo");
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(100, 80),
                                padding: EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Color(0xFF0E1828),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cruelty_free,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            // 바로가기
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "바로가기",
                  style: pSemiBold20.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ), 
            Container(
              width: 400.0, // 가로 크기 (옵션)
              height: 700.0, // 세로 크기 (옵션)
              // color: Colors.yellow, // 배경색
              // margin: EdgeInsets.all(16.0), // 외부 여백
              padding: EdgeInsets.symmetric(
                  horizontal: 30.0, vertical: 0.0), // 내부 여백
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end, // 세로 정렬
                crossAxisAlignment: CrossAxisAlignment.center, // 가로 정렬
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      if (authProvider.currentUser?.auth == "ROLE_USER") {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/userinfo");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(140, 110),
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Color(0xFF0E1828),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.person_outline,
                                            color: Colors.white),
                                        SizedBox(height: 8),
                                        Text("내 정보 보기",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "/userupdate");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(140, 110),
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 244, 244, 244),
                                      foregroundColor: Colors.black,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.settings,
                                            color: Colors.black),
                                        SizedBox(height: 8),
                                        Text("내 정보 수정",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "/mypage/ticketList");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(140, 110),
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 244, 244, 244),
                                      foregroundColor: Colors.black,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.money_outlined,
                                            color: Colors.black),
                                        SizedBox(height: 8),
                                        Text("티켓 구매 내역",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final authProvider =
                                          Provider.of<AuthProvider>(context,
                                              listen: false);
                                      authProvider.logout();
                                      Navigator.pushReplacementNamed(
                                          context, "/");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(140, 110),
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 244, 244, 244),
                                      foregroundColor: Colors.black,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.logout_outlined,
                                            color: Colors.black),
                                        SizedBox(height: 8),
                                        Text("로그아웃",
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else if (authProvider.currentUser?.auth ==
                          "ROLE_BAND") {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, "/userinfo");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(140, 110),
                                          padding: EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Color(0xFF0E1828),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.person_outline,
                                                color: Colors.white),
                                            SizedBox(height: 8),
                                            Text("내 정보 보기",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, "/userupdate");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(140, 110),
                                          padding: EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Color.fromARGB(
                                              255, 244, 244, 244),
                                          // foregroundColor: Colors.black,
                                          // side: BorderSide(color: Colors.grey),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.settings,
                                                color: Colors.black),
                                            SizedBox(height: 8),
                                            Text("내 정보 수정",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              "/mypage/ticketSaleList");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(140, 110),
                                          padding: EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Color.fromARGB(
                                              255, 244, 244, 244),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.open_in_new,
                                                color: Colors.black),
                                            SizedBox(height: 8),
                                            Text("티켓 판매 내역",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, "/mypage/team/state");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(140, 110),
                                          padding: EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Color(0xFF0E1828),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.person_add,
                                                color: Colors.white),
                                            SizedBox(height: 8),
                                            Text("팀 모집 현황",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, "/mypage/team/myApp");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(140, 110),
                                          padding: EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Color(0xFF0E1828),
                                          foregroundColor: Colors.white,
                                          side: BorderSide(color: Colors.grey),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.diversity_3,
                                                color: Colors.white),
                                            SizedBox(height: 8),
                                            Text(
                                              "신청한 \n참가 내역",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, "/mypage/ticketList");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(140, 110),
                                          padding: EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Color.fromARGB(
                                              255, 244, 244, 244),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.money_outlined,
                                                color: Colors.black),
                                            SizedBox(height: 8),
                                            Text("티켓 구매 내역",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              "/mypage/team/confirmedLive");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(140, 110),
                                          padding: EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Color.fromARGB(
                                              255, 244, 244, 244),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.sign_language_outlined,
                                                color: Colors.black),
                                            SizedBox(height: 8),
                                            Text(
                                              "성사된 \n공연 목록",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final authProvider =
                                              Provider.of<AuthProvider>(context,
                                                  listen: false);
                                          authProvider.logout();
                                          Navigator.pushReplacementNamed(
                                              context, "/");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(140, 110),
                                          padding: EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Color.fromARGB(
                                              255, 244, 244, 244),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.logout_outlined,
                                                color: Colors.black),
                                            SizedBox(height: 8),
                                            Text("로그아웃",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/userinfo");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(140, 110),
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 244, 244, 244),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.person_outline,
                                            color: Color(0xFF0E1828)),
                                        SizedBox(height: 8),
                                        Text("내 정보 보기",
                                            style: TextStyle(
                                                color: Color(0xFF0E1828))),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "/userupdate");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(140, 110),
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Color(0xFF0E1828),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.settings,
                                            color: Colors.white),
                                        SizedBox(height: 8),
                                        Text("내 정보 수정",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "/mypage/ticketList");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(140, 110),
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 244, 244, 244),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.money_outlined,
                                            color: Color(0xFF0E1828)),
                                        SizedBox(height: 8),
                                        Text("티켓 구매 내역",
                                            style: TextStyle(
                                                color: Color(0xFF0E1828))),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "/mypage/ticketSaleList");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(140, 110),
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Color(0xFF0E1828),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.open_in_new,
                                            color: Colors.white),
                                        SizedBox(height: 8),
                                        Text("티켓 판매 내역",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, "/mypage/team/myApp");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(140, 110),
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Color(0xFF0E1828),
                                      side: BorderSide(color: Colors.grey),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.diversity_3,
                                            color: Colors.white),
                                        SizedBox(height: 8),
                                        Text(
                                          "신청한 참가 내역",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final authProvider =
                                          Provider.of<AuthProvider>(context,
                                              listen: false);
                                      authProvider.logout();
                                      Navigator.pushReplacementNamed(
                                          context, "/");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(140, 110),
                                      padding: EdgeInsets.all(16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(255, 244, 244, 244),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.logout_outlined,
                                            color: Color(0xFF0E1828)),
                                        SizedBox(height: 8),
                                        Text("로그아웃",
                                            style: TextStyle(
                                                color: Color(0xFF0E1828))),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),


//
            
//
          ],
        ),
      ),
    );
  }
}
