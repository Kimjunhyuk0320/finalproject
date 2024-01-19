import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/model/user.dart';
import 'package:livedom_app/screens/user/user_info_screen.dart';
import 'package:livedom_app/widget/custom_button.dart';
import 'package:livedom_app/widget/custom_textfield.dart';
import 'package:http/http.dart' as http;

class joinScreen extends StatefulWidget {
  const joinScreen({super.key});

  @override
  State<joinScreen> createState() => _joinScreenState();
}

class _joinScreenState extends State<joinScreen> {
  final TextEditingController usernameController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // final TextEditingController nameController = TextEditingController();
  // final TextEditingController nicknameController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController phoneController = TextEditingController();
  // final TextEditingController authController = TextEditingController();

  // Future<void> register() async {
  //   final String username = usernameController.text;
  //   final String password = passwordController.text;
  //   final String name = nameController.text;
  //   final String nickname = nicknameController.text;
  //   final String email = emailController.text;
  //   final String phone = phoneController.text;
  //   final String auth = authController.text;

  //   final Uri url = Uri.parse('http://10.0.2.2:8080/users');

  //   final Map<String, String> data = {
  //     'username': username,
  //     'password': password,
  //     'name': name,
  //     'nickname': nickname,
  //     'email': email,
  //     'phone': phone,
  //     'auth': auth,
  //   };

  //   try {
  //     final http.Response response = await http.post(
  //       url,
  //       body: jsonEncode(data),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       // 회원가입 성공
  //       print('Registration successful!');
  //     } else {
  //       // 회원가입 실패
  //       print('Registration failed. ${response.body}');
  //     }
  //   } catch (error) {
  //     print('Error during registration: $error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('1/6'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  '아이디를 설정해주세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  '아이디는 n글자 이상으로 설정해주세요',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "아이디",
                  controller: usernameController,
                  onChanged: (value) {
                    print('[회원기입] - 아이디 : $value');
                    usernameController.text = value;
                  },
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.account_circle, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 420),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  text: "다음",
                  onTap: () {
                    User inputUser = User();
                    inputUser.username = usernameController.text;
                    Navigator.pushNamed(
                      context,
                      '/join/pw',
                      arguments: inputUser,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 페이지 2
class JoinPwScreen extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User?;
    print('JoinScreen -> JoinPwSreen : ${user?.username}');

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('2/6'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  '비밀번호를 설정해주세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '비밀번호는 ',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '대문자',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '와 ',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '소문자,',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '특수문자',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '를 \n포함하고 ',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: 'n글자 이상',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '으로 설정해주세요.',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "비밀번호",
                  controller: passwordController,
                  onChanged: (value) {
                    print('[회원기입] - 비밀번호 : $value');
                    // passwordController.text = value;
                  },
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.lock, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "비밀번호 확인",
                  controller: TextEditingController(),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.lock, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 320),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  text: "다음",
                  onTap: () {
                    User? inputUser = user;
                    inputUser?.password = passwordController.text;
                    Navigator.pushNamed(
                      context,
                      '/join/name',
                      arguments: inputUser,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 페이지 3
class JoinNameScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User?;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('3/6'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  '이름과 별명을 설정해주세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '이름',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '은 ',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '실명',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '을 작성해주세요. \n',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '(*티켓 구매시 불이익을 받을 수 있습니다.)',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "이름",
                  controller: nameController,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.person, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "별명",
                  controller: nickNameController,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.sentiment_satisfied, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 320),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  text: "다음",
                  onTap: () {
                    User? inputUser = user;
                    inputUser?.name = nameController.text;
                    inputUser?.nickName = nickNameController.text;
                    Navigator.pushNamed(
                      context,
                      '/join/phone',
                      arguments: inputUser,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 페이지 4
class JoinPhoneScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User?;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('4/6'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  '연락처를 설정해주세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '연락처는 (-)기호를 제외하고 설정해주세요.\n',
                        style: TextStyle(
                          color: Color(0xFF8D8D8D),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w200,
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: '(*다른 연락처를 작성시 불이익을 받을 수 있습니다.)',
                        style: TextStyle(
                          color: Color(0xFF8D8D8D),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w200,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "01012345678",
                  controller: phoneController,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.phone, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 390),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  text: "다음",
                  onTap: () {
                    user?.phone = phoneController.text;
                    Navigator.pushNamed(
                      context,
                      '/join/email',
                      arguments:user,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 페이지 5
class JoinEmailScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User?;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('5/6'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  '이메일을 설정해주세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '이메일을 작성해주세요. \n',
                        style: TextStyle(
                          color: Color(0xFF8D8D8D),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w200,
                          height: 0,
                        ),
                      ),
                      TextSpan(
                        text: '(*다른 이메일을 작성시 불이익을 받을 수 있습니다.)',
                        style: TextStyle(
                          color: Color(0xFF8D8D8D),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w200,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomTextField(
                  hintText: "example.mail.com",
                  controller: emailController,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 20, bottom: 20),
                    child: Icon(
                      Icons.phone, // 원하는 아이콘을 설정
                      color: Colors.grey, // 아이콘의 색상
                      size: 20.0, // 아이콘의 크기
                    ),
                  ),
                  sufix: const SizedBox(width: 10),
                ),
              ),
              const SizedBox(height: 390),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  text: "다음",
                  onTap: () {
                    user!.email = emailController.text;
                    Navigator.pushNamed(
                      context,
                      '/join/auth',
                      arguments: user,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 페이지 6
class JoinAuthScreen extends StatefulWidget {
  @override
  JoinAuthScreenState createState() => JoinAuthScreenState();
}

class JoinAuthScreenState extends State<JoinAuthScreen> {
  String selectedPermission = ''; // 선택된 권한

  void selectPermission(String permission) {
    setState(() {
      selectedPermission = permission;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User?;
    final TextEditingController authController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('6/6'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    '아래에 해당하는 \n권한을 설정해주세요.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '하나의 권한을 선택해주세요.',
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w200,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PermissionButton(
                  permission: '유저권한',
                  isSelected: selectedPermission == '유저권한',
                  onSelect: () => selectPermission('유저권한'),
                ),
                PermissionButton(
                  permission: '밴드권한',
                  isSelected: selectedPermission == '밴드권한',
                  onSelect: () => selectPermission('밴드권한'),
                ),
                PermissionButton(
                  permission: '클럽권한',
                  isSelected: selectedPermission == '클럽권한',
                  onSelect: () => selectPermission('클럽권한'),
                ),
                const SizedBox(height: 30),
                Text(
                  selectedPermission.isEmpty
                      ? '권한을 선택하지 않았습니다.'
                      : '"$selectedPermission"을 선택하였습니다',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: CustomButton(
                    text: "가입 완료",
                    onTap: () {
                      user!.auth = selectedPermission;

                      print('User객체 확인 아이디 : ${user.username}');
                      print('User객체 확인 비번 : ${user.password}');
                      print('User객체 확인 실명 : ${user.name}');
                      print('User객체 확인 닉네임 : ${user.nickName}');
                      print('User객체 확인 연락처 : ${user.phone}');
                      print('User객체 확인 이메일 : ${user.email}');
                      print('User객체 확인 권한 : ${user.auth}');

                      // Navigator.pushNamed(
                      //   context,
                      //   '/join/phone',
                      //   arguments: inputUser,
                      // );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 권한 설정 선택 버튼 관련
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
      margin: EdgeInsets.all(8), // 여백을 조절하려면 여기서 조절합니다.
      child: ElevatedButton(
        onPressed: onSelect,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Color.fromRGBO(16, 24, 39, 1)
              : ConstColors.lightGrayColor,
          onPrimary: isSelected ? Colors.white : Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            // side: BorderSide(color: Colors.grey),
          ),
          minimumSize: Size(320, 100),
        ),
        child: Text(
          permission,
          style: const TextStyle(
            // color: Color.fromRGBO(0, 0, 0, 1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
