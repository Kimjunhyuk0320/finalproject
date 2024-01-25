import 'package:flutter/material.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPage',
          style: TextStyle(
            color: Color(0xFF0E1828),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w900,
            height: 0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end, // 세로 정렬
          // crossAxisAlignment: CrossAxisAlignment.start, // 가로 정렬
          children: [
            Container(
              width: 400.0, // 가로 크기 (옵션)
              height: 700.0, // 세로 크기 (옵션)
              // color: Colors.yellow, // 배경색
              // margin: EdgeInsets.all(16.0), // 외부 여백
              padding: EdgeInsets.symmetric(
                  horizontal: 46.0, vertical: 0.0), // 내부 여백
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end, // 세로 정렬
                crossAxisAlignment: CrossAxisAlignment.start, // 가로 정렬
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Column(
                    // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                    crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                    children: [
                      Text(
                        'Hello LIVEDOM :)',
                        style: TextStyle(
                          color: Color(0xFF0E1828),
                          fontSize: 29,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w900,
                          height: 0,
                        ),
                      ),
                      Text(
                        '클럽 대관, 티켓팅, 팀 모집 ',
                        style: TextStyle(
                          color: Color(0xFF0E1828),
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w200,
                          height: 0,
                        ),
                      ),
                    ],
                  ), // 자식 위젯
                  const SizedBox(
                    height: 40,
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      if (authProvider.currentUser?.auth == "ROLE_USER") {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // 가로 정렬
                              // crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                              children: [
                                // 내 정보 보기
                                ElevatedButton(
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.end, // 가로 정렬
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // 세로 정렬
                                    children: [
                                      Icon(Icons.person_outline), // 아이콘 추가
                                      SizedBox(
                                          height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                      Text("내 정보 보기"),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF0E1828),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      minimumSize: Size(140, 110),
                                      elevation: 5),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context, "/userinfo");
                                  },
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                // 내 정보 수정
                                ElevatedButton(
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // 세로 정렬
                                    children: [
                                      Icon(Icons.settings), // 아이콘 추가
                                      SizedBox(
                                          height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                      Text("내 정보 수정"),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      side: BorderSide(
                                          color: Colors.grey), // 테두리 색상 설정
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      minimumSize: Size(140, 110),
                                      elevation: 5),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context, "/userupdate");
                                  },
                                ),
                              ],
                            ), // 자식 위젯
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // 가로 정렬
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 세로 정렬
                              children: [
                                // 티켓 구매 내역
                                ElevatedButton(
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // 세로 정렬
                                    children: [
                                      Icon(Icons.money_outlined), // 아이콘 추가
                                      SizedBox(
                                          height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                      Text("티켓 구매 내역"),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      side: BorderSide(
                                          color: Colors.grey), // 테두리 색상 설정
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      minimumSize: Size(140, 110),
                                      elevation: 5),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context, "/mypage/ticketList");
                                  },
                                ),
                                const SizedBox(
                                  width: 20,
                                ), // 로그아웃 버튼
                                ElevatedButton(
                                  onPressed: () async {
                                    // 버튼 동작 추가
                                    print('로그아웃 처리...');
                                    final authProvider =
                                        Provider.of<AuthProvider>(context,
                                            listen: false);
                                    authProvider.logout();
                                    Navigator.pushReplacementNamed(context, "/");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    side: const BorderSide(
                                        color: Colors.grey), // 테두리 색상 설정
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    minimumSize: const Size(140, 110),
                                    elevation: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // 모든 자식을 왼쪽으로 정렬
                                    children: [
                                      const Icon(Icons
                                          .logout_outlined), // 첫 번째 줄 아이콘 추가
                                      const SizedBox(
                                          height: 8), // 첫 번째 줄과 두 번째 줄 간격 추가
                                      Container(
                                        alignment: Alignment
                                            .centerLeft, // 텍스트를 왼쪽으로 정렬
                                        child:
                                            const Text("로그아웃"), // 두 번째 줄 텍스트 추가
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ), // 자식 위젯자식 위젯
                          ],
                        );
                      } else if (authProvider.currentUser?.auth ==
                          "ROLE_BAND") {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center, // 가로 정렬
                                // crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                                children: [
                                  ElevatedButton(
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.end, // 가로 정렬
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, // 세로 정렬
                                      children: [
                                        Icon(Icons.person_outline), // 아이콘 추가
                                        SizedBox(
                                            height:
                                                8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                        Text("내 정보 보기"),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF0E1828),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minimumSize: Size(140, 110),
                                        elevation: 5),
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                          context, "/userinfo");
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, // 세로 정렬
                                      children: [
                                        Icon(Icons.settings), // 아이콘 추가
                                        SizedBox(
                                            height:
                                                8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                        Text("내 정보 수정"),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        side: BorderSide(
                                            color: Colors.grey), // 테두리 색상 설정
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minimumSize: Size(140, 110),
                                        elevation: 5),
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                          context, "/userupdate");
                                    },
                                  ),
                                ],
                              ), // 자식 위젯
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center, // 가로 정렬
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // 세로 정렬
                                children: [
                                  ElevatedButton(
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, // 세로 정렬
                                      children: [
                                        Icon(Icons.open_in_new), // 아이콘 추가
                                        SizedBox(
                                            height:
                                                8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                        Text("티켓 판매 내역"),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        side: BorderSide(
                                            color: Colors.grey), // 테두리 색상 설정
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minimumSize: Size(140, 110),
                                        elevation: 5),
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                          context, "/mypage/ticketSaleList");
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, // 세로 정렬
                                      children: [
                                        Icon(Icons.person_add), // 아이콘 추가
                                        SizedBox(
                                            height:
                                                8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                        Text("팀 모집 현황"),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF0E1828),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minimumSize: Size(140, 110),
                                        elevation: 5),
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                          context, "/mypage/team/state");
                                    },
                                  ),
                                ],
                              ), // 자식 위젯
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center, // 가로 정렬
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // 세로 정렬
                                children: [
                                  ElevatedButton(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start, // 가로 정렬
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, // 세로 정렬
                                      children: [
                                        Icon(Icons.diversity_3), // 아이콘 추가
                                        SizedBox(
                                            height:
                                                8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                        Text(
                                          "신청한 참가 내역",
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF0E1828),
                                        foregroundColor: Colors.white,
                                        side: BorderSide(
                                            color: Colors.grey), // 테두리 색상 설정
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minimumSize: Size(140, 110),
                                        elevation: 5),
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                          context, "/mypage/team/myApp");
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, // 세로 정렬
                                      children: [
                                        Icon(Icons.money_outlined), // 아이콘 추가
                                        SizedBox(
                                            height:
                                                8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                        Text("티켓 구매 내역"),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        side: BorderSide(
                                            color: Colors.grey), // 테두리 색상 설정
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minimumSize: Size(140, 110),
                                        elevation: 5),
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                          context, "/mypage/ticketList");
                                    },
                                  ),
                                ],
                              ), // 자식 위젯
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center, // 가로 정렬
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // 세로 정렬
                                children: [
                                  ElevatedButton(
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, // 세로 정렬
                                      children: [
                                        Icon(Icons
                                            .sign_language_outlined), // 아이콘 추가
                                        SizedBox(
                                            height:
                                                8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                        Text(
                                          "성사된 공연 목록",
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        side: BorderSide(
                                            color: Colors.grey), // 테두리 색상 설정
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minimumSize: Size(140, 110),
                                        elevation: 5),
                                    onPressed: () async {
                                      Navigator.pushNamed(context,
                                          "/mypage/team/confirmedLive");
                                    },
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  // 로그아웃 버튼
                                  ElevatedButton(
                                    onPressed: () async {
                                      // 버튼 동작 추가
                                      print('로그아웃 처리...');
                                      final authProvider =
                                          Provider.of<AuthProvider>(context,
                                              listen: false);
                                      authProvider.logout();
                                      Navigator.pushReplacementNamed(context, "/");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      side: const BorderSide(
                                          color: Colors.grey), // 테두리 색상 설정
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      minimumSize: const Size(140, 110),
                                      elevation: 5,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // 모든 자식을 왼쪽으로 정렬
                                      children: [
                                        const Icon(Icons
                                            .logout_outlined), // 첫 번째 줄 아이콘 추가
                                        const SizedBox(
                                            height: 8), // 첫 번째 줄과 두 번째 줄 간격 추가
                                        Container(
                                          alignment: Alignment
                                              .centerLeft, // 텍스트를 왼쪽으로 정렬
                                          child: const Text(
                                              "로그아웃"), // 두 번째 줄 텍스트 추가
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ), // 자식 위젯
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // 가로 정렬
                              // crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                              children: [
                                ElevatedButton(
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.end, // 가로 정렬
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // 세로 정렬
                                    children: [
                                      Icon(Icons.person_outline), // 아이콘 추가
                                      SizedBox(
                                          height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                      Text("내 정보 보기"),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF0E1828),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      minimumSize: Size(140, 110),
                                      elevation: 5),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context, "/userinfo");
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                ElevatedButton(
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // 세로 정렬
                                    children: [
                                      Icon(Icons.settings), // 아이콘 추가
                                      SizedBox(
                                          height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                      Text("내 정보 수정"),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      side: BorderSide(
                                          color: Colors.grey), // 테두리 색상 설정
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      minimumSize: Size(140, 110),
                                      elevation: 5),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context, "/userupdate");
                                  },
                                ),
                              ],
                            ), // 자식 위젯
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // 가로 정렬
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 세로 정렬
                              children: [
                                ElevatedButton(
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // 세로 정렬
                                    children: [
                                      Icon(Icons.money_outlined), // 아이콘 추가
                                      SizedBox(
                                          height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                      Text("티켓 구매 내역"),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      side: BorderSide(
                                          color: Colors.grey), // 테두리 색상 설정
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      minimumSize: Size(140, 110),
                                      elevation: 5),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context, "/mypage/ticketList");
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                // 티켓 판매
                                ElevatedButton(
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // 세로 정렬
                                    children: [
                                      Icon(Icons.open_in_new), // 아이콘 추가
                                      SizedBox(
                                          height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                      Text("티켓 판매 내역"),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      side: BorderSide(
                                          color: Colors.grey), // 테두리 색상 설정
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      minimumSize: Size(140, 110),
                                      elevation: 5),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context, "/mypage/ticketSaleList");
                                  },
                                ),
                              ],
                            ), // 자식 위젯

                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // 가로 정렬
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 세로 정렬
                              children: [
                                ElevatedButton(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start, // 가로 정렬
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start, // 세로 정렬
                                    children: [
                                      Icon(Icons.diversity_3), // 아이콘 추가
                                      SizedBox(
                                          height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                                      Text(
                                        "신청한 참가 내역",
                                        style: TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF0E1828),
                                      foregroundColor: Colors.white,
                                      side: BorderSide(
                                          color: Colors.grey), // 테두리 색상 설정
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      minimumSize: Size(140, 110),
                                      elevation: 5),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context, "/mypage/team/myApp");
                                  },
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                // 로그아웃 버튼
                                ElevatedButton(
                                  onPressed: () async {
                                    // 버튼 동작 추가
                                    print('로그아웃 처리...');
                                    final authProvider =
                                        Provider.of<AuthProvider>(context,
                                            listen: false);
                                    authProvider.logout();
                                    Navigator.pushReplacementNamed(context, "/");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    side: const BorderSide(
                                        color: Colors.grey), // 테두리 색상 설정
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    minimumSize: const Size(140, 110),
                                    elevation: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // 모든 자식을 왼쪽으로 정렬
                                    children: [
                                      const Icon(Icons
                                          .logout_outlined), // 첫 번째 줄 아이콘 추가
                                      const SizedBox(
                                          height: 8), // 첫 번째 줄과 두 번째 줄 간격 추가
                                      Container(
                                        alignment: Alignment
                                            .centerLeft, // 텍스트를 왼쪽으로 정렬
                                        child:
                                            const Text("로그아웃"), // 두 번째 줄 텍스트 추가
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ), // 자식 위젯
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
