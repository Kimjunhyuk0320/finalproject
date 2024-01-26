import 'package:flutter/material.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/config/images.dart';
import 'package:livedom_app/config/text_style.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/screens/liveBoard/liveboard_list.dart';
import 'package:livedom_app/screens/user/home_view.dart';
import 'package:livedom_app/screens/user/join_screen.dart';
import 'package:livedom_app/screens/user/login_screen.dart';
import 'package:livedom_app/widget/custom_button.dart';

import 'package:http/http.dart' as http;

class JoinCompleteScreen extends StatefulWidget {
  const JoinCompleteScreen({Key? key});

  @override
  _JoinCompleteScreenState createState() => _JoinCompleteScreenState();
}

class _JoinCompleteScreenState extends State<JoinCompleteScreen> {

  Future<void> registerUser(Users user) async {
    final String apiUrl = 'http://13.209.77.161/users';

    try {
      // Create a MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add form fields
      request.fields['username'] = user.username!;
      request.fields['password'] = user.password!;
      request.fields['name'] = user.name!;
      request.fields['nickname'] = user.nickname!;
      request.fields['phone'] = user.phone!;
      request.fields['email'] = user.email!;
      request.fields['auth'] = user.auth.toString();

      // Send the request
      var response = await request.send();

      // Read and print the server response
      var resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // 회원가입 성공
        print('회원가입 성공');
        print('서버 응답: $resBody');
      } else {
        // 회원가입 실패
        print('회원가입 실패: ${response.reasonPhrase}');
        print('서버 응답: $resBody');
      }
    } catch (e) {
      print('오류: $e');
    }
  }
  // - 계속 회원가입이 실패했던 이유
  // 서버는 http.MultipartRequest를 받도록 설정되어 있었는데
  // http.post로 요청했기 때문에

  // 번호에 따른 권한 출력을 위한 함수
  String getAuthName(String authValue) {
    switch (authValue) {
      case '0':
        return '유저권한';
      case '1':
        return '클럽권한';
      case '2':
        return '밴드권한';
      default:
        return '알 수 없는 권한';
    }
  }

  // 모달이 현재 보이는지 여부를 나타내는 플래그
  bool isModalVisible = false;
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as Users?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('정보확인'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: MediaQuery.of(context).padding.top + 15),
            // if (user != null)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text('아이디: ${user.username}'),
            //       Text('이름: ${user.name}'),
            //       Text('닉네임: ${user.nickname}'),
            //       Text('전화번호: ${user.phone}'),
            //       Text('이메일: ${user.email}'),
            //       Text('권한: ${user.auth}'),
            //     ],
            //   ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                children: [
                  // const SizedBox(height: 40),
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
                      const SizedBox(height: 10),
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

                                if (user != null)
                                  Text(
                                    '${user.username}',
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
                                if (user != null)
                                  Text(
                                    '${user.name}',
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
                                if (user != null)
                                  Text(
                                    '${user.nickname}',
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
                                if (user != null)
                                  Text(
                                    '${getAuthName(user.auth!)}',
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
                                if (user != null)
                                  Text(
                                    '${user.phone}',
                                    style: TextStyle(
                                      color: ConstColors.greyColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                SizedBox(width: 20), // 텍스트 간격 조절을 위한 SizedBox
                                Text(
                                  '01023250724',
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
                                if (user != null)
                                  Text(
                                    '${user.email}',
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
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (user != null) {
                              registerUser(user);
                            } else {
                              print('사용자 정보가 없습니다.');
                            }
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false, // 이전 페이지가 없도록 설정
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
                                '가입 완료',
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
    );
  }
}

// row 커스텀
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
