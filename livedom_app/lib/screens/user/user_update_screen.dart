import 'package:flutter/material.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/config/images.dart';
import 'package:livedom_app/config/text_style.dart';
import 'package:livedom_app/screens/user/user_info_screen.dart';
import 'package:livedom_app/widget/custom_back_icon.dart';
import 'package:livedom_app/widget/custom_button.dart';
import 'package:livedom_app/widget/custom_textfield.dart';

class UserUpdateScreen extends StatefulWidget {
  const UserUpdateScreen({Key? key}) : super(key: key);

  @override
  State<UserUpdateScreen> createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  String selectedPermission = ''; // 선택된 권한

  void selectPermission(String permission) {
    setState(
      () {
        selectedPermission = permission;
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
                        hintText: "아이디", // 인풋의 힌트가 여기에 담긴다.
                        controller: TextEditingController(
                            text: "아이디"), // 유저 정보가 여기에 들어가게 될 것이다.
                        title: "아이디", // 인풋이 뭔지 설명하는 위쪽 텍스트
                        sufix: const SizedBox(),
                      ),
                      const SizedBox(height: 20),
                      CustomTextWithoutPrefixField(
                        hintText: "이름", // 인풋의 힌트가 여기에 담긴다.
                        controller: TextEditingController(
                            text: "이름"), // 유저 정보가 여기에 들어가게 될 것이다.
                        title: "이름", // 인풋이 뭔지 설명하는 위쪽 텍스트
                        sufix: const SizedBox(),
                      ),
                      const SizedBox(height: 20),
                      CustomTextWithoutPrefixField(
                        hintText: "연락처",
                        controller: TextEditingController(text: "연락처"),
                        title: "연락처",
                        sufix: const SizedBox(),
                      ),
                      const SizedBox(height: 20),
                      CustomTextWithoutPrefixField(
                        hintText: "이메일",
                        controller: TextEditingController(text: "이메일"),
                        title: "이메일",
                        sufix: const SizedBox(),
                      ),
                      const SizedBox(height: 20),
                      // CustomTextWithoutPrefixField(
                      //   hintText: "권한",
                      //   controller:
                      //       TextEditingController(text: "$selectedPermission"),
                      //   title: "권한",
                      //   sufix: const SizedBox(),
                      // ),
                      // const SizedBox(height: 20),
                      // CustomTextWithoutPrefixField(
                      //   hintText: "연락처",
                      //   controller: TextEditingController(text: "연락처"),
                      //   title: "연락처",
                      //   sufix: const Icon(
                      //     Icons.keyboard_arrow_down,
                      //     color: ConstColors.greyColor,
                      //     size: 18,
                      //   ),
                      // ),
                      // const SizedBox(height: 30),
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
                          // const SizedBox(height: 30),
                          // Text(
                          //   selectedPermission.isEmpty
                          //       ? '권한을 선택하지 않았습니다.'
                          //       : '"$selectedPermission"을 선택하였습니다',
                          //   style: const TextStyle(
                          //     fontSize: 20,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          // const SizedBox(height: 70),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 30),
                          //   child: ElevatedButton(
                          //     onPressed: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => UserInfoScreen()),
                          //       );
                          //     },
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.black,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(15.0),
                          //       ),
                          //     ),
                          //     child: Container(
                          //       width: 320.0,
                          //       height: 60.0,
                          //       child: const Center(
                          //         child: Text(
                          //           '회원가입 완료',
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 20.0,
                          //             fontWeight: FontWeight.w700,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
