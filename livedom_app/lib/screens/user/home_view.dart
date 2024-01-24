import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livedom_app/config/colors.dart';
import 'package:livedom_app/config/images.dart';
import 'package:livedom_app/config/text_style.dart';
import 'package:livedom_app/model/liveboard.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/total_search_provider.dart';
import 'package:livedom_app/provider/user_provider.dart';
import 'package:livedom_app/screens/liveBoard/liveboard_list.dart';
import 'package:livedom_app/screens/user/home_screen.dart';
import 'package:livedom_app/widget/custom_textfield.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

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
  final ScrollController _controller = ScrollController();

  // LivdBoardList
  // 여기에 값을 세팅해 주어야한다.
  List<dynamic> liveBoardList = [];

  int _page = 1;

  Map<String, dynamic> _pageObj = {'last': 10};

  //스켈레톤 UI용 다음 데이터 갯수
  int _nextCount = 0;

  //캐싱 여부
  String isCaching = '';

  var _pageObject = {};

  //데이터 중복 호출 방지 스위치
  bool isFetching = false;
  // 말 줄이기 함수
  String truncateText(String text, int length) {
    if (text.length <= length) {
      return text;
    } else {
      return '${text.substring(0, length)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 로그인한 사용자 정보 가져오기
    TotalSearchProvider totalSearchProvider =
        Provider.of<TotalSearchProvider>(context);
    // List<dynamic> liveBoardList = totalSearchProvider.liveBoardList;
    List<dynamic> frList = totalSearchProvider.frList;
    // List teamList = totalSearchProvider.teamList;

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
      body: Consumer<TotalSearchProvider>(
        builder: (context, totalSearchProvider, child) {
          // LiveBoard 데이터를 가져와서 화면에 표시

          return Padding(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
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
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.all(8),
                                itemBuilder: (context, index) {
                                  if (index < totalSearchProvider.teamList.length) {
                                    final item = totalSearchProvider.teamList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/team/read',
                                          arguments: item,
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1.0,
                                              color: Colors.black12,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(18.0)),
                                        height: 130.0,
                                        child: ListTile(
                                          title: Row(
                                            children: [
                                              Text(
                                                '(${item['location']})',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              Text(
                                                ' ${item['title'].substring(0, 11)}...',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '일시 : ${item['liveDate']} ${item['liveStTime']} ~ ${item['liveEndTime']}'),
                                              Text('장소 : ${item['address']}'),
                                              Text(
                                                  '대관료 : ${item['price']}원(팀당 ${(item['price'] / item['capacity']).round()}원)'),
                                              Container(
                                                alignment: Alignment.center,
                                                height: 20,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  border: Border.all(
                                                    color:
                                                        item['confirmed'] == 1
                                                            ? Colors.red
                                                            : Colors.green,
                                                    width: 0.5,
                                                  ),
                                                ),
                                                child: Text(
                                                  item['confirmed'] == 1
                                                      ? '마감'
                                                      : '모집중',
                                                  style: TextStyle(
                                                    color:
                                                        item['confirmed'] == 1
                                                            ? Colors.red
                                                            : Colors.green,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (_pageObject['last'] != null &&
                                      _page > 2 &&
                                      _pageObject['last'] > _page) {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 20.0),
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          border: Border.all(
                                            width: 1.0,
                                            color: Colors.black12,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(18.0)),
                                      height: 130.0,
                                      child: Container(),
                                    );
                                  } else {
                                    // 기본적인 위젯 반환
                                    return Container();
                                  }
                                },
                                itemCount: totalSearchProvider.teamList.length + _nextCount,
                              ),
                              Divider(
                                  color:
                                      ConstColors.iconColor.withOpacity(0.2)),
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            itemBuilder: (context, index) {
                              // index: 0~19
                              if (index < totalSearchProvider.liveBoardList.length) {
                                final item = totalSearchProvider.liveBoardList[index];
                                return Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // 터치 이벤트 핸들링
                                          Navigator.pushNamed(
                                            context,
                                            "/liveboard/read",
                                            arguments: item,
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            item.thumbnail == 0
                                                ? Image.asset(
                                                    'assets/images/defaultRentalImg.jpeg',
                                                    width: 120,
                                                    height: 180,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    'http://10.0.2.2:8080/api/file/img/${item.thumbnail}?${DateTime.now().millisecondsSinceEpoch.toString()}',
                                                    width: 120,
                                                    height: 180,
                                                    fit: BoxFit.cover,
                                                  ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      item.soldOut == 0
                                                          ? Container(
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              child: Text(
                                                                '판매중',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                            )
                                                          : Container(
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              child: Text(
                                                                '매진',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                        truncateText(item.title,
                                                            17), // 최대 길이를 설정 (예: 20)
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        truncateText(
                                                            item.crew, 17),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        truncateText(
                                                            item.address, 17),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      SizedBox(
                                                        height: 30.0,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            truncateText(
                                                                item.liveDate,
                                                                17),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          Text(
                                                            truncateText(
                                                                item.liveTime,
                                                                17),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          Text(
                                                            truncateText(
                                                                item.location,
                                                                17),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey, // 원하는 색상으로 변경
                                        thickness: 0.5, // 원하는 두께로 변경
                                        height: 40.0, // 위아래 여백 조절
                                      ),
                                    ],
                                  ),
                                );
                              }
                              // index: 20
                              else if ((_page - 1) > 0 &&
                                  (_page - 1) < _pageObj['last']!) {
                                return Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 180.0,
                                      ),
                                      Divider(
                                        color: Colors.grey, // 원하는 색상으로 변경
                                        thickness: 0.5, // 원하는 두께로 변경
                                        height: 40.0, // 위아래 여백 조절
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            itemCount: totalSearchProvider.liveBoardList.length + _nextCount,
                          ),
                          Divider(
                              color: ConstColors.iconColor.withOpacity(0.2)),
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            itemBuilder: (context, index) {
                              // index: 0~19
                              if (index < frList.length) {
                                final item = frList[index];
                                return Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // 터치 이벤트 핸들링
                                          Navigator.pushNamed(
                                            context,
                                            "/rental/read",
                                            arguments: item,
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            item.thumbnail == 0
                                                ? Image.asset(
                                                    'assets/images/defaultRentalImg.jpeg',
                                                    width: 120,
                                                    height: 180,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    'http://10.0.2.2:8080/api/file/img/${item.thumbnail}?${DateTime.now().microsecondsSinceEpoch.toString()}',
                                                    width: 120,
                                                    height: 180,
                                                    fit: BoxFit.cover,
                                                  ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      item.confirmed == 0
                                                          ? Container(
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              child: Text(
                                                                '모집중',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                            )
                                                          : Container(
                                                              width: 60,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              child: Text(
                                                                '모집종료',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                        truncateText(item.title,
                                                            17), // 최대 길이를 설정 (예: 20)
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        truncateText(
                                                            item.writer, 17),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        truncateText(
                                                            item.address, 17),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      SizedBox(
                                                        height: 30.0,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            truncateText(
                                                                item.liveDate,
                                                                17),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          Text(
                                                            truncateText(
                                                                item.location,
                                                                17),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey, // 원하는 색상으로 변경
                                        thickness: 0.5, // 원하는 두께로 변경
                                        height: 40.0, // 위아래 여백 조절
                                      ),
                                    ],
                                  ),
                                );
                              }
                              // index: 20
                              else if ((_page - 1) > 0 &&
                                  (_page - 1) < _pageObj['last']!) {
                                return Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 180.0,
                                      ),
                                      Divider(
                                        color: Colors.grey, // 원하는 색상으로 변경
                                        thickness: 0.5, // 원하는 두께로 변경
                                        height: 40.0, // 위아래 여백 조절
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            itemCount: frList.length + _nextCount,
                          ),
                          Divider(
                              color: ConstColors.iconColor.withOpacity(0.2)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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

// 아래에서 위로 올라오는 검색창
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
    final totalSearchProvider = Provider.of<TotalSearchProvider>(context);

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
                    prefix: const SizedBox(width: 0),
                    sufix: Padding(
                      padding: EdgeInsets.only(
                          left: 0, right: 20, top: 14, bottom: 20),
                      child: GestureDetector(
                        onTap: () async {
                          String keyword = _keywordHintController.text;
                          print('Search keyword: $keyword');
                          await totalSearchProvider.getTotalSearch(keyword);
                          Navigator.pushAndRemoveUntil(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => HomeView(),
                            ),
                            (route) => false, // 이전 페이지가 없도록 설정
                          );
                          // print('최종 ${totalSearchProvider.liveBoardList[0].boardNo}');
                        }, // 아이콘을 눌렀을 때 호출될 메서드
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ),
                    ),
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
              ],
            ),
          )
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
