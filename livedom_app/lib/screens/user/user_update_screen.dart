import 'package:flutter/material.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/config/images.dart';
import 'package:livedom_app/config/text_style.dart';
import 'package:livedom_app/model/users.dart';
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

  @override
  void initState() {
    super.initState();
    
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
      if(currentUser.auth == "ROLE_USER") {
        selectedPermission = "ROLE_USER";
      } else if (currentUser.auth == "ROLE_BAND") {
        selectedPermission = "ROLE_BAND";
      } else {
        selectedPermission = "ROLE_CLUB";
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

    // 비밀번호 유효성 검사 함수
    bool isPasswordValid(String password) {
      // 비밀번호는 대문자, 소문자, 특수문자를 포함하고 8글자 이상이어야 함
      final RegExp regex =
          RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
      return regex.hasMatch(password);
    }

    // 비밀번호 확인 검사 함수
    bool isPasswordCheck(String password, String passwordcheck) {
      if (password == passwordcheck) {
        return true;
      } else {
        return false;
      }
    }

    // 문자열로 들어오는 권한을 권한에 따라 각각 0, 1, 2로 바꾸어줌.
    if (auth == 'ROLE_USER') {
      auth = '0';
    } else if (auth == 'ROLE_CLUB') {
      auth = '1';
    } else {
      auth = '2';
    }

    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)'
    };
    var url = Uri.parse('http://10.0.2.2:8080/users');

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PermissionButton(
                            permission: '유저권한',
                            isSelected: selectedPermission == 'ROLE_USER',
                            onSelect: () => selectPermission('ROLE_USER'),
                          ),
                          PermissionButton(
                            permission: '밴드권한',
                            isSelected: selectedPermission == 'ROLE_BAND',
                            onSelect: () => selectPermission('ROLE_BAND'),
                          ),
                          PermissionButton(
                            permission: '클럽권한',
                            isSelected: selectedPermission == 'ROLE_CLUB',
                            onSelect: () => selectPermission('ROLE_CLUB'),
                          ),
                        ],
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
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
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

// 비밀번호를 통한 정보 수정
void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200, // 원하는 높이 설정
          child: Column(
            children: [
              ListTile(
                title: Text('Option 1'),
                onTap: () {
                  // 원하는 동작 수행
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Option 2'),
                onTap: () {
                  // 원하는 동작 수행
                  Navigator.pop(context);
                },
              ),
              // 추가적인 아이템들을 여기에 추가할 수 있습니다.
            ],
          ),
        );
      },
    );
  }

// 비밀번호가 일치할 때 정보수정이 되도록 변경

// 아이디, 닉네임 중복검사

// 유저 프로필 사진

// 카카오 로그인

// 쉐어드 프리퍼런스
