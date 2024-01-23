import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/config/images.dart';
import 'package:livedom_app/config/text_style.dart';
import 'package:livedom_app/model/liveboard.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/user_provider.dart';
import 'package:livedom_app/screens/liveBoard/liveboard_list.dart';
import 'package:livedom_app/screens/user/home_screen.dart';
import 'package:livedom_app/widget/custom_textfield.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // UserProvider 참조
  // final AuthProvider _authProvider = Get.find<AuthProvider>();

  final List<String> slideList = [
    'assets/images/newJS.png',
    'assets/images/aespa.jpg',
    'assets/images/SLan.webp',
  ];

  @override
  Widget build(BuildContext context) {
    // 현재 로그인한 사용자 정보 가져오기
    // final String username = _authProvider.;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LIVE DOM",
          style: pBold.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                                if (authProvider.currentUser != null) {
                                  return Text(
                                    '환영합니다, ${authProvider.currentUser!.username}님!',
                                    style: pRegular14.copyWith(
                                      fontSize: 12,
                                    ),
                                  );
                                } else {
                                  return Text('로그인이 필요합니다.');
                                }
                              },
                            ),
                            const SizedBox(height: 1),
                            Text(
                              "Welcome Back!",
                              style: pBold.copyWith(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/mypage");
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                DefaultImages.h3,
                              ),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  CarouselSlider.builder(
                    itemCount: slideList.length,
                    itemBuilder: (context, index, realIndex) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              "${slideList[index]}",
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ],
                      );
                    },
                    options: CarouselOptions(viewportFraction: 1.0),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        // width: Get.width,
                        decoration: BoxDecoration(
                          color: ConstColors.lightGrayColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            icon(
                              DefaultImages.h5,
                              "클럽 대관",
                              () {
                                Navigator.pushNamed(context, "/liveboard");
                              },
                            ),
                            icon(
                              DefaultImages.h7,
                              "밴드 모집",
                              () {
                                Navigator.pushNamed(context, "/team");
                              },
                            ),
                            icon(
                              DefaultImages.h6,
                              "티켓팅",
                              () {
                                Navigator.pushNamed(context, "/rental");
                              },
                            ),
                            icon(
                              DefaultImages.h1,
                              "More",
                              () {
                                Navigator.pushNamed(context, "/mypage");
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // 원하는 기능 수행
                          print("Container를 눌렀습니다.");
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return _BottomSheetScreen();
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 5),
                            decoration: BoxDecoration(
                              color: ConstColors.lightGrayColor,
                              // border: Border.all(color: Colors.grey), // 테두리 추가
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 30.0,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "검색",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "밴드 모집 조회",
                            style: pSemiBold18.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/team');
                            },
                            child: Row(
                              children: [
                                Text(
                                  "더보기",
                                  style: pBold.copyWith(
                                    fontSize: 14,
                                    color: ConstColors.greyColor,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: ConstColors.primaryColor,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // for (var i = 0; i < 3; i++)
                          //   Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       transaction(
                          //         i == 0
                          //             ? DefaultImages.h8
                          //             : i == 1
                          //                 ? DefaultImages.h4
                          //                 : DefaultImages.h2,
                          //         i == 0
                          //             ? "Gym"
                          //             : i == 1
                          //                 ? "Bank of America"
                          //                 : "To Brody Zmymo",
                          //         i == 0
                          //             ? "Payment"
                          //             : i == 1
                          //                 ? "Deposit"
                          //                 : "Sent",
                          //         i == 0
                          //             ? "- \$55.99"
                          //             : i == 1
                          //                 ? "+ \$2,519.00"
                          //                 : "- \$726.00",
                          //         i == 0
                          //             ? ConstColors.fontColor
                          //             : i == 1
                          //                 ? ConstColors.primaryColor
                          //                 : ConstColors.fontColor,
                          //       ),
                          //       const SizedBox(height: 10),
                          //       Divider(
                          //           color:
                          //               ConstColors.iconColor.withOpacity(0.2)),
                          //       const SizedBox(height: 10),
                          //     ],
                          //   )
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '(홍대) 우주정거장 공연 같이하실 분 구합니다!!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '안녕하세요. 저희는 5년차 직장인 밴드 dofnas입니다. 이번에 홍대 우주정거장에서 공연을 진행하기로 결정했는데요! 혹시 03월 23일에 같이 ..... [ 자세히 보기 ]',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                              color: ConstColors.iconColor.withOpacity(0.2)),
                          const SizedBox(height: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '(홍대) 우주정거장 공연 같이하실 분 구합니다!!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '안녕하세요. 저희는 5년차 직장인 밴드 dofnas입니다. 이번에 홍대 우주정거장에서 공연을 진행하기로 결정했는데요! 혹시 03월 23일에 같이 ..... [ 자세히 보기 ]',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                              color: ConstColors.iconColor.withOpacity(0.2)),
                          const SizedBox(height: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '(홍대) 우주정거장 공연 같이하실 분 구합니다!!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '안녕하세요. 저희는 5년차 직장인 밴드 dofnas입니다. 이번에 홍대 우주정거장에서 공연을 진행하기로 결정했는데요! 혹시 03월 23일에 같이 ..... [ 자세히 보기 ]',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                              color: ConstColors.iconColor.withOpacity(0.2)),
                          const SizedBox(height: 10),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "티켓 조회",
                            style: pSemiBold18.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/liveboard');
                            },
                            child: Row(
                              children: [
                                Text(
                                  "더보기",
                                  style: pBold.copyWith(
                                    fontSize: 14,
                                    color: ConstColors.greyColor,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: ConstColors.primaryColor,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 140,
                                width: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      DefaultImages.newJS,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '일테노래',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '홍광호',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '(홍대) 우주정거장,',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '2024-02-19 ~ 2024-02-24',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '서울',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(color: ConstColors.iconColor.withOpacity(0.2)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 140,
                                width: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      DefaultImages.newJS,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '일테노래',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '홍광호',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '(홍대) 우주정거장,',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '2024-02-19 ~ 2024-02-24',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '서울',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                          Divider(
                              color: ConstColors.iconColor.withOpacity(0.2)),
                          const SizedBox(height: 30),
                        ],
                      ),
                      Divider(color: ConstColors.iconColor.withOpacity(0.2)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 140,
                                width: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      DefaultImages.newJS,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '일테노래',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '홍광호',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '(홍대) 우주정거장,',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '2024-02-19 ~ 2024-02-24',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '서울',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                          Divider(
                              color: ConstColors.iconColor.withOpacity(0.2)),
                          const SizedBox(height: 30),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "클럽 대관 조회",
                            style: pSemiBold18.copyWith(
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/rental');
                            },
                            child: Row(
                              children: [
                                Text(
                                  "더보기",
                                  style: pBold.copyWith(
                                    fontSize: 14,
                                    color: ConstColors.greyColor,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: ConstColors.primaryColor,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 140,
                                width: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      DefaultImages.newJS,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '일테노래',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '홍광호',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '(홍대) 우주정거장,',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '2024-02-19 ~ 2024-02-24',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '서울',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(color: ConstColors.iconColor.withOpacity(0.2)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 140,
                                width: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      DefaultImages.newJS,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '일테노래',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '홍광호',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '(홍대) 우주정거장,',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '2024-02-19 ~ 2024-02-24',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '서울',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                          Divider(
                              color: ConstColors.iconColor.withOpacity(0.2)),
                          const SizedBox(height: 30),
                        ],
                      ),
                      Divider(color: ConstColors.iconColor.withOpacity(0.2)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 140,
                                width: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      DefaultImages.newJS,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '일테노래',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '홍광호',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '(홍대) 우주정거장,',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '2024-02-19 ~ 2024-02-24',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '서울',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                          Divider(
                              color: ConstColors.iconColor.withOpacity(0.2)),
                          const SizedBox(height: 30),
                        ],
                      ),
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

Widget icon(String image, String text, VoidCallback onTap) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: SvgPicture.asset(
            image,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: pSemiBold18.copyWith(
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

Widget transaction(
    String image, String text, String text1, String text2, Color color) {
  return Row(
    children: [
      Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ConstColors.lightGrayColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(
            image,
          ),
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: pSemiBold20.copyWith(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              text1,
              style: pRegular14.copyWith(
                fontSize: 12,
                color: ConstColors.greyColor,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
      Text(
        text2,
        style: pSemiBold20.copyWith(
          fontSize: 14,
          color: color,
        ),
      ),
    ],
  );
}

// class _BottomSheetScreen extends StatelessWidget {

class _BottomSheetScreen extends StatefulWidget {
  @override
  _BottomSheetScreenState createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<_BottomSheetScreen> {
  String selectedPermission = ''; // 선택한 글이 담기는 변수
  final TextEditingController _keywordHintController =
      TextEditingController(text: '');

  void selectPermission(String permission) {
    setState(() {
      selectedPermission = permission;
      _keywordHintController.text = selectedPermission;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400, // 원하는 높이로 설정
      width: 390,
      decoration: BoxDecoration(
        color: Colors.white, // 배경색을 원하는 색상으로 설정
        // 다른 스타일 속성들을 추가할 수 있습니다.
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // BottomSheet
          SizedBox(
            // BottomSheet 검색창 높이
            height: 120,
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  width: 110,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4), // 굴곡을 위한 반지름 설정
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    hintText: '검색',
                    controller: _keywordHintController,
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 5, top: 14, bottom: 20),
                      child: Icon(
                        Icons.search, // 원하는 아이콘을 설정
                        color: Colors.black, // 아이콘의 색상
                        size: 30.0, // 아이콘의 크기
                      ),
                    ),
                    sufix: const SizedBox(width: 10),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          // 스크롤 영역
          SizedBox(
            // BottomSheet 의 스크롤 높이
            height: 280,
            child: ListView(
              children: [
                PermissionButton(
                  numbering: '01.',
                  permission: '임재현',
                  isSelected: selectedPermission == '임재현',
                  onSelect: () => selectPermission('임재현'),
                ),
                PermissionButton(
                  numbering: '02.',
                  permission: '태연',
                  isSelected: selectedPermission == '태연',
                  onSelect: () => selectPermission('태연'),
                ),
                PermissionButton(
                  numbering: '03.',
                  permission: 'LE SSERAFIM (르세라핌)',
                  isSelected: selectedPermission == 'LE SSERAFIM (르세라핌)',
                  onSelect: () => selectPermission('LE SSERAFIM (르세라핌)'),
                ),
                PermissionButton(
                  numbering: '04.',
                  permission: 'easpa',
                  isSelected: selectedPermission == 'easpa',
                  onSelect: () => selectPermission('easpa'),
                ),
                PermissionButton(
                  numbering: '05.',
                  permission: '이무진',
                  isSelected: selectedPermission == '이무진',
                  onSelect: () => selectPermission('이무진'),
                ),
                PermissionButton(
                  numbering: '06.',
                  permission: '박재정',
                  isSelected: selectedPermission == '박재정',
                  onSelect: () => selectPermission('박재정'),
                ),
                const SizedBox(height: 30),
                // Text(
                //   selectedPermission.isEmpty
                //       ? '권한을 선택하지 않았습니다.'
                //       : '"$selectedPermission"을 선택하였습니다',
                //   style: const TextStyle(
                //     fontSize: 20,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),

                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     // 아래에서 위로 올라오는 화면을 닫습니다.
                //     Navigator.of(context).pop();
                //   },
                //   child: Text("닫기"),
                // ),
              ],
            ),
          )

          // SingleChildScrollView(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       PermissionButton(
          //         permission: '1',
          //         isSelected: selectedPermission == '유저권한',
          //         onSelect: () => selectPermission('유저권한'),
          //       ),
          //       PermissionButton(
          //         permission: '2',
          //         isSelected: selectedPermission == '밴드권한',
          //         onSelect: () => selectPermission('밴드권한'),
          //       ),
          //       PermissionButton(
          //         permission: '3',
          //         isSelected: selectedPermission == '클럽권한',
          //         onSelect: () => selectPermission('클럽권한'),
          //       ),
          //       PermissionButton(
          //         permission: '1',
          //         isSelected: selectedPermission == '유저권한',
          //         onSelect: () => selectPermission('유저권한'),
          //       ),
          //       PermissionButton(
          //         permission: '2',
          //         isSelected: selectedPermission == '밴드권한',
          //         onSelect: () => selectPermission('밴드권한'),
          //       ),
          //       PermissionButton(
          //         permission: '3',
          //         isSelected: selectedPermission == '클럽권한',
          //         onSelect: () => selectPermission('클럽권한'),
          //       ),
          //       const SizedBox(height: 30),
          //       Text(
          //         selectedPermission.isEmpty
          //             ? '권한을 선택하지 않았습니다.'
          //             : '"$selectedPermission"을 선택하였습니다',
          //         style: const TextStyle(
          //           fontSize: 20,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),

          //       SizedBox(height: 20),
          //       // ElevatedButton(
          //       //   onPressed: () {
          //       //     // 아래에서 위로 올라오는 화면을 닫습니다.
          //       //     Navigator.of(context).pop();
          //       //   },
          //       //   child: Text("닫기"),
          //       // ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

// 선택할 수 있는 버튼
class PermissionButton extends StatelessWidget {
  final String numbering;
  final String permission;
  final bool isSelected;
  final VoidCallback onSelect;

  PermissionButton({
    required this.permission,
    required this.isSelected,
    required this.onSelect,
    required this.numbering,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 20,
        left: 20,
        top: 14,
      ), // 여백을 조절하려면 여기서 조절합니다.
      child: ElevatedButton(
        onPressed: onSelect,
        style: ElevatedButton.styleFrom(
          primary: isSelected ? Colors.black : Colors.white,
          onPrimary: isSelected ? Colors.white : Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.white),
          ),
          minimumSize: Size(350, 70),
        ),
        child: Row(
          children: [
            Text(
              numbering,
              style: const TextStyle(
                // color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              permission,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
