import 'package:flutter/material.dart';

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
        title: const Text('마이페이지'),
        centerTitle: true,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.end, // 세로 정렬
        // crossAxisAlignment: CrossAxisAlignment.start, // 가로 정렬
        children: [
          Container(
            width: 400.0, // 가로 크기 (옵션)
            height: 700.0, // 세로 크기 (옵션)
            // color: Colors.yellow, // 배경색
            // margin: EdgeInsets.all(16.0), // 외부 여백
            padding:
                EdgeInsets.symmetric(horizontal: 46.0, vertical: 0.0), // 내부 여백
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.end, // 세로 정렬
              crossAxisAlignment: CrossAxisAlignment.start, // 가로 정렬
              children: [
                SizedBox(
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
                        fontWeight: FontWeight.w800,
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
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가로 정렬
                  // crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                  children: [
                    ElevatedButton(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.end, // 가로 정렬
                        crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                        children: [
                          Icon(Icons.person_outline), // 아이콘 추가
                          SizedBox(height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                          Text("내 정보 보기"),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0E1828),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minimumSize: Size(140, 110),
                          elevation: 5),
                      onPressed: () async {
                        Navigator.pushReplacementNamed(context, "/");
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                        crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                        children: [
                          Icon(Icons.settings), // 아이콘 추가
                          SizedBox(height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                          Text("내 정보 수정"),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey), // 테두리 색상 설정
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minimumSize: Size(140, 110),
                          elevation: 5),
                      onPressed: () async {
                        Navigator.pushReplacementNamed(context, "/");
                      },
                    ),
                  ],
                ), // 자식 위젯
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가로 정렬
                  crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                  children: [
                    ElevatedButton(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                        crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                        children: [
                          Icon(Icons.open_in_new), // 아이콘 추가
                          SizedBox(height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                          Text("티켓 판매 내역"),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey), // 테두리 색상 설정
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minimumSize: Size(140, 110),
                          elevation: 5),
                      onPressed: () async {
                        Navigator.pushReplacementNamed(context, "/");
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                        crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                        children: [
                          Icon(Icons.person_add), // 아이콘 추가
                          SizedBox(height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                          Text("팀 모집 현황"),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0E1828),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minimumSize: Size(140, 110),
                          elevation: 5),
                      onPressed: () async {
                        Navigator.pushReplacementNamed(context, "/mypage/team/state");
                      },
                    ),
                  ],
                ), // 자식 위젯
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가로 정렬
                  crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                  children: [
                    ElevatedButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                        crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                        children: [
                          Icon(Icons.diversity_3), // 아이콘 추가
                          SizedBox(height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
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
                          side: BorderSide(color: Colors.grey), // 테두리 색상 설정
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minimumSize: Size(140, 110),
                          elevation: 5),
                      onPressed: () async {
                        Navigator.pushReplacementNamed(context, "/");
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                        crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                        children: [
                          Icon(Icons.money_outlined), // 아이콘 추가
                          SizedBox(height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
                          Text("티켓 구매 내역"),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey), // 테두리 색상 설정
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minimumSize: Size(140, 110),
                          elevation: 5),
                      onPressed: () async {
                        Navigator.pushReplacementNamed(context, "/");
                      },
                    ),
                  ],
                ), // 자식 위젯
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가로 정렬
                  crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                  children: [
                    ElevatedButton(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start, // 가로 정렬
                        crossAxisAlignment: CrossAxisAlignment.start, // 세로 정렬
                        children: [
                          Icon(Icons.sign_language_outlined), // 아이콘 추가
                          SizedBox(height: 8), // 텍스트와 아이콘이 겹치지 않게 간격 추가
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
                          side: BorderSide(color: Colors.grey), // 테두리 색상 설정
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minimumSize: Size(140, 110),
                          elevation: 5),
                      onPressed: () async {
                        Navigator.pushReplacementNamed(context, "/");
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // 버튼 동작 추가
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: BorderSide(color: Colors.grey), // 테두리 색상 설정
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        minimumSize: Size(140, 110),
                        elevation: 5,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // 모든 자식을 왼쪽으로 정렬
                        children: [
                          Icon(Icons.logout_outlined), // 첫 번째 줄 아이콘 추가
                          SizedBox(height: 8), // 첫 번째 줄과 두 번째 줄 간격 추가
                          Container(
                            alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
                            child: Text("로그아웃"), // 두 번째 줄 텍스트 추가
                          ),
                        ],
                      ),
                    ),
                  ],
                ), // 자식 위젯
              ],
            ),
          ),
        ],
      ),
    );
  }
}
