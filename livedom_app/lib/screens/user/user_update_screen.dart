import 'package:flutter/material.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/config/images.dart';
import 'package:livedom_app/config/text_style.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/nav_provider.dart';
import 'package:livedom_app/screens/user/user_info_screen.dart';
import 'package:livedom_app/widget/custom_back_icon.dart';
import 'package:livedom_app/widget/custom_button.dart';
import 'package:livedom_app/widget/custom_textfield.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';

class UserUpdateScreen extends StatefulWidget {
  const UserUpdateScreen({Key? key}) : super(key: key);

  @override
  State<UserUpdateScreen> createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
    // AuthProvider에서 사용자 정보를 가져와서 컨트롤러에 설정
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.getUserInfo();
    final currentUser = authProvider.currentUser;

    if (currentUser != null) {
      // usernameController.text = currentUser.username ?? '';
      usernameController.text = currentUser.username ?? '';
      nameController.text = currentUser.name ?? '';
      nickNameController.text = currentUser.nickname ?? '';
      phoneController.text = currentUser.phone ?? '';
      emailController.text = currentUser.email ?? '';
      print("currentUser.auth : ${currentUser.auth}");

      // 초기에 페이지에 들어갈 때 권한을 설정하는 코드
      if (currentUser.auth == "ROLE_USER") {
        selectedPermission = "0";
      } else if (currentUser.auth == "ROLE_BAND") {
        selectedPermission = "2";
      } else {
        selectedPermission = "1";
      }
    }
  }

  // 유저 정보 수정
  Future<void> userUpdate() async {
    // 각 컨트롤러에서 현재 입력된 값을 가져옴
    String username = usernameController.text;
    String password = passwordController.text;
    String passwordCheck = passwordCheckController.text;
    String name = nameController.text;
    String nickname = nickNameController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    String auth = selectedPermission;

    print("username: $username");
    print("password: $password");
    print("passwordCheck: $passwordCheck");
    print("nickname: $nickname");
    print("username: $username");
    print("phone: $phone");
    print("email: $email");
    print("auth: $auth");

    // 비밀번호 유효성 검사 함수
    bool isPasswordValid(String password) {
      // 비밀번호는 대문자, 소문자, 특수문자를 포함하고 8글자 이상이어야 함
      final RegExp regex =
          RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
      return regex.hasMatch(password);
    }

    // 비밀번호가 비어있는지 확인
    if (password.isEmpty) {
      // 비밀번호가 비어있을 때 처리할 로직
      print("비밀번호를 입력해주세요.");
      return;
    }

    // 비밀번호 확인이 비어있는지 확인
    if (passwordCheck.isEmpty) {
      // 비밀번호 확인이 비어있을 때 처리할 로직
      print("비밀번호 확인을 입력해주세요.");
      return;
    }

    // 비밀번호와 비밀번호 확인이 다른지 확인
    if (password != passwordCheck) {
      // 비밀번호와 비밀번호 확인이 다를 때 처리할 로직
      print("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
      return;
    }

    // 비밀번호 유효성 검사
    if (!isPasswordValid(password)) {
      // 비밀번호가 유효하지 않을 때 처리할 로직
      print("비밀번호는 대문자, 소문자, 특수문자를 포함하여 8자 이상이어야 합니다.");
      return;
    }

    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)'
    };
    var url = Uri.parse('http://13.209.77.161/users');

    var body = {
      'username': username,
      'password': password,
      'name': name,
      'nickname': nickname,
      'email': email,
      'phone': phone,
      'auth': auth,
    };

    var req = http.MultipartRequest('PUT', url);
    req.headers.addAll(headersList);
    req.fields.addAll(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }

  String selectedPermission = ''; // 선택된 권한

  void selectPermission(String permission) {
    setState(
      () {
        selectedPermission = permission;
        print('selectedPermission : ${selectedPermission}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.whiteColor,
      appBar: AppBar(
        title: const Text(
          '정보 수정',
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
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                children: [
                  // Center 부분 : 이미지 관련 위젯
                  const SizedBox(height: 40),
                  Center(
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
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(1000),
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
                                      child: Stack(children: [
                                        Icon(
                                          Icons.edit, // 원하는 아이콘을 설정
                                          color: Colors.white, // 아이콘의 색상
                                          size: 20.0, // 아이콘의 크기
                                        ),
                                      ]),
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
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      CustomTextWithoutPrefixField(
                        readOnly: true,
                        hintText: "아이디", // 인풋의 힌트가 여기에 담긴다.
                        controller: usernameController,
                        title: "아이디", // 인풋이 뭔지 설명하는 위쪽 텍스트
                        sufix: const SizedBox(),
                      ),
                      const SizedBox(height: 30),
                      CustomTextWithoutPrefixField(
                        obscureText: true,
                        hintText: "비밀번호", // 인풋의 힌트가 여기에 담긴다.
                        controller: passwordController,
                        title: "비밀번호", // 인풋이 뭔지 설명하는 위쪽 텍스트
                        sufix: const SizedBox(),
                      ),
                      const SizedBox(height: 30),
                      CustomTextWithoutPrefixField(
                        obscureText: true,
                        hintText: "비밀번호 확인", // 인풋의 힌트가 여기에 담긴다.
                        controller: passwordCheckController,
                        title: "비밀번호 확인", // 인풋이 뭔지 설명하는 위쪽 텍스트
                        sufix: const SizedBox(),
                      ),
                      const SizedBox(height: 20),
                      CustomTextWithoutPrefixField(
                        hintText: "이름", // 인풋의 힌트가 여기에 담긴다.
                        controller: nameController,
                        title: "이름", // 인풋이 뭔지 설명하는 위쪽 텍스트
                        sufix: const SizedBox(),
                      ),
                      const SizedBox(height: 20),
                      CustomTextWithoutPrefixField(
                        hintText: "닉네임", // 인풋의 힌트가 여기에 담긴다.
                        controller: nickNameController,
                        title: "닉네임", // 인풋이 뭔지 설명하는 위쪽 텍스트
                        sufix: const SizedBox(),
                      ),
                      const SizedBox(height: 20),
                      CustomTextWithoutPrefixField(
                        hintText: "연락처",
                        controller: phoneController,
                        title: "연락처",
                        sufix: const SizedBox(),
                      ),
                      const SizedBox(height: 20),
                      CustomTextWithoutPrefixField(
                        hintText: "이메일",
                        controller: emailController,
                        title: "이메일",
                        sufix: const SizedBox(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "권한",
                        style: TextStyle(
                          color: ConstColors.greyColor,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w900,
                          // height: 0,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PermissionButton(
                              permission: '유저권한',
                              isSelected: selectedPermission == '0',
                              onSelect: () => selectPermission('0'),
                            ),
                            PermissionButton(
                              permission: '밴드권한',
                              isSelected: selectedPermission == '1',
                              onSelect: () => selectPermission('1'),
                            ),
                            PermissionButton(
                              permission: '클럽권한',
                              isSelected: selectedPermission == '2',
                              onSelect: () => selectPermission('2'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
            CustomButton(
              text: "정보 수정",
              onTap: () {
                print("정보 수정 버튼을 눌렀습니다.");
                // _showModalBottomSheet(context);
                // 비밀번호와 비밀번호 확인을 모두 입력하였을 때,
                userUpdate();
                CustomAlertDialog(context);
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                authProvider.logout();
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.pushReplacementNamed(context, "/");
                });
              },
            ),
            const SizedBox(height: 20),
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

// 권한 선택 버튼 관련
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
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: onSelect,
        style: ElevatedButton.styleFrom(
          primary: isSelected
              ? Color.fromRGBO(16, 24, 39, 1)
              : ConstColors.lightGrayColor,
          onPrimary: isSelected ? Colors.white : Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            // side: BorderSide(color: Colors.grey),
          ),
          minimumSize: Size(101, 56),
        ),
        child: Text(
          permission,
          style: const TextStyle(
            // color: Color.fromRGBO(0, 0, 0, 1),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// 통합 알림창
void CustomAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 50.0,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
