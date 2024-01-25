import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/config/images.dart';
import 'package:livedom_app/config/text_style.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/auth_provider.dart';
import 'package:livedom_app/provider/nav_provider.dart';
import 'package:livedom_app/provider/user_provider.dart';
import 'package:livedom_app/screens/user/join_screen.dart';
import 'package:livedom_app/screens/user/user_update_screen.dart';
import 'package:provider/provider.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
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
    // AuthProvider에 접근
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    // AuthProvider에서 현재 유저 정보 가져오기
    Users? currentUser = authProvider.currentUser;
    print("currentUser : ${currentUser}");

    return Scaffold(
      appBar: AppBar(
        title: const Text('내정보'),
        centerTitle: true,
      ),
      body: Padding(
        // child: Consumer<AuthProvider>(
        //   builder: (context, authProvider, child) {
        //     final user = UserProvider.user;
        //   }
        // )
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: MediaQuery.of(context).padding.top + 15),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       "",
            //       style: pSemiBold20.copyWith(
            //         fontSize: 18,
            //       ),
            //     ),
            //   ],
            // ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                children: [
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            print('터치스크린 이벤트 발생');
                            // GestureDetector를 터치했을 때 팝업 띄우기
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'profileImage',
                            child: Container(
                              width: 120,
                              height: 120,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 120,
                                      height: 120,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              width: 120,
                                              height: 120,
                                              decoration: const ShapeDecoration(
                                                color: Colors.white,
                                                shape: OvalBorder(),
                                                shadows: [
                                                  BoxShadow(
                                                    color: Color(0x1E9BA3AF),
                                                    blurRadius: 50,
                                                    offset: Offset(5, 15),
                                                    spreadRadius: 0,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 10,
                                            top: 10,
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: const ShapeDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    DefaultImages.lee,
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                                shape: OvalBorder(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 85,
                                    top: 85,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF111827),
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            width: 2,
                                            strokeAlign:
                                                BorderSide.strokeAlignOutside,
                                            color: Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 5,
                                            top: 5,
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              child: Stack(
                                                children: [
                                                  Icon(
                                                    Icons.add, // 원하는 아이콘을 설정
                                                    color:
                                                        Colors.white, // 아이콘의 색상
                                                    size: 20.0, // 아이콘의 크기
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Personal Info",
                          style: pSemiBold20.copyWith(
                            color: ConstColors.greyColor,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        child: Container(
                          // color: Colors.green,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '아이디',
                                  style: TextStyle(
                                    color: ConstColors.greyColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: 20), // 텍스트 간격 조절을 위한 SizedBox
                                Text(
                                  currentUser?.username ?? '로그인 필요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        child: Container(
                          // color: Colors.green,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '이름',
                                  style: TextStyle(
                                    color: ConstColors.greyColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: 20), // 텍스트 간격 조절을 위한 SizedBox
                                Text(
                                  currentUser?.name ?? '로그인 필요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        child: Container(
                          // color: Colors.green,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '닉네임',
                                  style: TextStyle(
                                    color: ConstColors.greyColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: 20), // 텍스트 간격 조절을 위한 SizedBox
                                Text(
                                  currentUser?.nickname ?? '로그인 필요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        child: Container(
                          // color: Colors.green,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '권한',
                                  style: TextStyle(
                                    color: ConstColors.greyColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: 20), // 텍스트 간격 조절을 위한 SizedBox
                                Text(
                                  currentUser?.auth ?? '로그인 필요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Personal Info",
                          style: pSemiBold20.copyWith(
                            color: ConstColors.greyColor,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        child: Container(
                          // color: Colors.green,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '연락처',
                                  style: TextStyle(
                                    color: ConstColors.greyColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: 20), // 텍스트 간격 조절을 위한 SizedBox
                                Text(
                                  currentUser?.phone ?? '로그인 필요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        child: Container(
                          // color: Colors.green,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '이메일',
                                  style: TextStyle(
                                    color: ConstColors.greyColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(width: 20), // 텍스트 간격 조절을 위한 SizedBox
                                Text(
                                  currentUser?.email ?? '로그인 필요',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserUpdateScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // 원하는 배경색을 설정
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          child: Container(
                            width: 320.0,
                            height: 50.0,
                            child: const Center(
                              child: Text(
                                '정보 수정',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (index) {
          setState(() {
            _navIndex = index;
            Provider.of<NavProvider>(context, listen: false).navIndex =
                _navIndex;
            Navigator.pushReplacementNamed(context, '/main');
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.layers,
              color: Colors.black,
            ),
            label: '클럽대관',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_alt_rounded,
              color: Colors.black,
            ),
            label: '팀 모집',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.devices_rounded,
              color: Colors.black,
            ),
            label: '공연',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: '내정보',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedLabelStyle: TextStyle(color: Colors.black),
        showUnselectedLabels: true,
      ),
    );
  }
}

Widget row(String image, String text, VoidCallback onTap) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ConstColors.lightGrayColor,
          ),
          // child: Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: SvgPicture.asset(
          //     image,
          //   ),
          // ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: pSemiBold18.copyWith(
              fontSize: 14,
            ),
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios,
          color: ConstColors.greyColor,
          size: 15,
        ),
      ],
    ),
  );
}

// 프로필 스크린
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: 'profileImage', // 홈 화면에서 사용한 태그와 동일해야 합니다.
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: AssetImage(
                    DefaultImages.lee,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
