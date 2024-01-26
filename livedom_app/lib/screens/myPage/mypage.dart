import 'package:flutter/material.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/auth_provider.dart';
import 'package:livedom_app/provider/nav_provider.dart';
import 'package:provider/provider.dart';

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
                crossAxisAlignment: CrossAxisAlignment.center, // 가로 정렬
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person_outline, color: Colors.white),
                SizedBox(height: 8),
                Text("내 정보 보기", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/userupdate");
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(140, 110),
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.settings, color: Colors.black),
                SizedBox(height: 8),
                Text("내 정보 수정", style: TextStyle(color: Colors.black)),
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
              Navigator.pushNamed(context, "/mypage/ticketList");
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(140, 110),
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.money_outlined, color: Colors.black),
                SizedBox(height: 8),
                Text("티켓 구매 내역", style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.pushReplacementNamed(context, "/");
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(140, 110),
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.logout_outlined, color: Colors.black),
                SizedBox(height: 8),
                Text("로그아웃", style: TextStyle(color: Colors.black)),
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
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.person_outline, color: Colors.white),
                    SizedBox(height: 8),
                    Text("내 정보 보기", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/userupdate");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(140, 110),
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.settings, color: Colors.black),
                    SizedBox(height: 8),
                    Text("내 정보 수정", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/mypage/ticketSaleList");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(140, 110),
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.open_in_new, color: Colors.black),
                    SizedBox(height: 8),
                    Text("티켓 판매 내역", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/mypage/team/state");
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.person_add, color: Colors.white),
                    SizedBox(height: 8),
                    Text("팀 모집 현황", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/mypage/team/myApp");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(140, 110),
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Color(0xFF0E1828),
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.diversity_3, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      "신청한 참가 내역",
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/mypage/ticketList");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(140, 110),
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.money_outlined, color: Colors.black),
                    SizedBox(height: 8),
                    Text("티켓 구매 내역", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/mypage/team/confirmedLive");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(140, 110),
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.sign_language_outlined, color: Colors.black),
                    SizedBox(height: 8),
                    Text(
                      "성사된 공연 목록",
                      style: TextStyle(color: Colors.black, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  authProvider.logout();
                  Navigator.pushReplacementNamed(context, "/");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(140, 110),
                  padding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.logout_outlined, color: Colors.black),
                    SizedBox(height: 8),
                    Text("로그아웃", style: TextStyle(color: Colors.black)),
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
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person_outline, color: Color(0xFF0E1828)),
                SizedBox(height: 8),
                Text("내 정보 보기", style: TextStyle(color: Color(0xFF0E1828))),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/userupdate");
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.settings, color: Colors.white),
                SizedBox(height: 8),
                Text("내 정보 수정", style: TextStyle(color: Colors.white)),
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
              Navigator.pushNamed(context, "/mypage/ticketList");
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(140, 110),
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.money_outlined, color: Color(0xFF0E1828)),
                SizedBox(height: 8),
                Text("티켓 구매 내역", style: TextStyle(color: Color(0xFF0E1828))),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/mypage/ticketSaleList");
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.open_in_new, color: Colors.white),
                SizedBox(height: 8),
                Text("티켓 판매 내역", style: TextStyle(color: Colors.white)),
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
              Navigator.pushNamed(context, "/mypage/team/myApp");
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.diversity_3, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  "신청한 참가 내역",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.pushReplacementNamed(context, "/");
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(140, 110),
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.logout_outlined, color: Color(0xFF0E1828)),
                SizedBox(height: 8),
                Text("로그아웃", style: TextStyle(color: Color(0xFF0E1828))),
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
          ],
        ),
      ),
    );
  }
}
