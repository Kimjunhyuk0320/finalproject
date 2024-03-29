import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livedom_app/model/rental.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/auth_provider.dart';
import 'package:livedom_app/provider/nav_provider.dart';
import 'package:livedom_app/provider/temp_user_provider.dart';
import 'package:livedom_app/screens/comment/comment_screen.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:livedom_app/model/liveboard.dart';
import 'package:livedom_app/screens/comment/comment_screen.dart';
import 'dart:ui';
import 'package:livedom_app/screens/rental/rental_update.dart';
import 'package:provider/provider.dart';
import "package:http/http.dart" as http;

class RentalReadScreen extends StatefulWidget {
  @override
  State<RentalReadScreen> createState() => _RentalReadScreenState();
}

class _RentalReadScreenState extends State<RentalReadScreen> {
  //캐싱 조건
  String isCaching = '';
  int selectedIndex = 0;
  int _count = 1;
  // 말 줄이기 함수
  int _navIndex = 2;

  //회원 정보
  Users userInfo = Users();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Rental rental = ModalRoute.of(context)?.settings.arguments as Rental;
      int tempIndex = Provider.of<NavProvider>(context, listen: false).navIndex;
      setState(() {
        _navIndex = tempIndex;
      });
      Users tempUserInfo =
          Provider.of<AuthProvider>(context, listen: false).currentUser!;
      setState(() {
        userInfo = tempUserInfo;
      });
      if (rental != null && rental.isCaching!) {
        setState(() {
          isCaching = '?${DateTime.now().millisecondsSinceEpoch.toString()}';
        });
      }
    });
    viewUp();
  }

  Future<void> viewUp() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final Rental rental =
          ModalRoute.of(context)?.settings.arguments as Rental;
      print('대관 데이터는 다음과 같습니다 : ${rental}');
      var headers = {
        'Content-Type': 'application/json',
      };
      var body = json.encode(
        {
          'parentTable': 'facility_rental',
          'parentNo': rental.boardNo,
        },
      );
      await http.put(
        Uri.parse('http://13.209.77.161/api/user/viewUp'),
        headers: headers,
        body: body,
      );
    });
  }

  String truncateText(String text, int length) {
    if (text.length <= length) {
      return text;
    } else {
      return '${text.substring(0, length)}...';
    }
  }

  // 가격 변환
  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  // 줄바꿈
  String formatMultilineText(String text) {
    final int maxLineLength = 15; // 원하는 최대 길이 설정
    final List<String> words = text.split(' ');

    String result = '';
    String line = '';
    for (String word in words) {
      if ((line + ' ' + word).length <= maxLineLength) {
        line += (line.isNotEmpty ? ' ' : '') + word;
      } else {
        result += (result.isNotEmpty ? '\n' : '') + line;
        line = word;
      }
    }

    if (line.isNotEmpty) {
      result += (result.isNotEmpty ? '\n' : '') + line;
    }

    return result;
  }

  Future<String> delete(int frNo) async {
    var parsedUrl = Uri.parse('http://13.209.77.161/api/fr/${frNo}');
    try {
      var result = await http.delete(parsedUrl);
      if (result.statusCode == 200) {
        return 'done';
      }
      return 'dont';
    } catch (e) {
      print(e);
      return 'dont';
    }
  }

  Future deleteConfirm(int frNo) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.18,
          padding: EdgeInsets.all(
            20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  '대관 게시글을 삭제하시겠습니까?',
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Consumer<TempUserProvider>(
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: () async {
                          //예 선택 시 실행 함수
                          var result = await delete(frNo);
                          if (result == 'done') {
                            print('삭제완료');
                            Navigator.pushReplacementNamed(
                              context,
                              '/rental',
                            );
                          } else {
                            print('삭제실패');
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: Text(
                            '예',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      //아니오 선택 시 실행 함수
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: Text(
                        '아니오',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Rental item = ModalRoute.of(context)!.settings.arguments as Rental;

    // 다음 버튼을 위해 > 화면 높이의 3/100 비율로 설정
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = screenHeight * 0.03;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Image.network(
                      'http://13.209.77.161/api/file/img/${item.thumbnail}${isCaching}',
                      width: 130,
                      height: 190,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.6),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 30,
                  child: Row(
                    children: [
                      Image.network(
                        'http://13.209.77.161/api/file/img/${item.thumbnail}${isCaching}',
                        width: 130,
                        height: 190,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                item.confirmed == 0
                                    ? Container(
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        child: Text(
                                          '모집중',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 221, 221, 221),
                                              fontSize: 10),
                                        ),
                                      )
                                    : Container(
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                            color: Colors.red,
                                          ),
                                        ),
                                        child: Text(
                                          '매진',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                Text(
                                  truncateText(item.title ?? '', 10),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  truncateText(item.writer ?? '', 9),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  truncateText(item.address ?? '', 10),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontSize: 13.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.liveDate ?? '',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '${formatCurrency(item.price ?? 0)}원',
                                      style: TextStyle(color: Colors.white),
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
                SafeArea(
                  top: true,
                  child: AppBar(
                    title: const Text(
                      '클럽 정보',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: Colors.white,
                    ),
                    actions: [
                      userInfo.username != null &&
                              userInfo.username == item.username
                          ? PopupMenuButton(
                              icon: Icon(Icons.menu, color: Colors.white),
                              onSelected: (value) {
                                if (value == 'item1') {
                                  // 'item1'이 선택되었을 때 수행할 작업
                                  Navigator.pushNamed(context, '/rental/update',
                                      arguments: item);
                                } else if (value == 'item2') {
                                  // 'item2'가 선택되었을 때 수행할 작업
                                  deleteConfirm(item.boardNo!);
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    value: 'item1',
                                    child: Text('게시글 수정'),
                                  ),
                                  PopupMenuItem(
                                    value: 'item2',
                                    child: Text('게시글 삭제'),
                                  ),
                                ];
                              },
                            )
                          : Container(),
                    ],
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // 탭바
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey, // 테두리 색상 설정
                      width: 1.0, // 테두리 두께 설정
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selectedIndex == 0
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Text(
                          '공연정보',
                          style: TextStyle(
                            color:
                                selectedIndex == 0 ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: selectedIndex == 1
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Text(
                          '공연후기',
                          style: TextStyle(
                            color:
                                selectedIndex == 1 ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 탭바뷰
            Container(
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Visibility(
                    visible: selectedIndex == 0, // 인덱스에 따라 화면 보이기/숨기기
                    child: Html(
                      data: item.content,
                      extensions: [
                        TagExtension(
                          tagsToExtend: {"img"},
                          builder: (context) {
                            final originalSrc = context.attributes['src'];

                            // Check if the original source starts with "/file"
                            if (originalSrc != null &&
                                originalSrc.startsWith("/file")) {
                              // If it starts with "/file", add the prefix
                              final newSrc = 'http://13.209.77.161$originalSrc';
                              return Image.network(newSrc);
                            } else if (originalSrc != null &&
                                originalSrc.startsWith("//")) {
                              final newSrc = 'http:$originalSrc';
                              return Image.network(newSrc);
                            } else {
                              // If it doesn't start with "/file", use the original source
                              return Image.network(originalSrc!);
                            }
                          },
                        ),
                      ],
                      style: {
                        "body": Style(
                            lineHeight: LineHeight(0),
                            whiteSpace: WhiteSpace.normal,
                            margin: Margins.all(1.0),
                            padding: HtmlPaddings.all(1.0)),
                        "p": Style(
                            lineHeight: LineHeight(1.3),
                            margin: Margins.all(1.0),
                            padding: HtmlPaddings.all(1.0)),
                        "h1": Style(
                          lineHeight: LineHeight(1.3),
                        ),
                        "h2": Style(
                          lineHeight: LineHeight(1.3),
                        ),
                        "h3": Style(
                          lineHeight: LineHeight(1.3),
                        ),
                        "div": Style(
                            lineHeight: LineHeight(1.3),
                            margin: Margins.all(1.0),
                            padding: HtmlPaddings.all(1.0)),
                        "img": Style(
                            width:
                                Width(MediaQuery.of(context).size.width * 0.9),
                            display: Display.inlineBlock,
                            margin: Margins.all(1.0),
                            padding: HtmlPaddings.all(1.0)),
                      },
                    ),
                  ),
                  Visibility(
                    visible: selectedIndex == 1, // 인덱스에 따라 화면 보이기/숨기기
                    child: CommentScreen(
                        item: item, parentTable: 'facility_rental'),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: item.confirmed == 1
          ? Container()
          : Container(
              height: 55.0,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(30, 0, 30, 80),
              child: FloatingActionButton(
                onPressed: () async {
                  _count = 1;
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(40.0)),
                    ),
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 5.0,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 12.0),
                                  Container(
                                    height: 120.0,
                                    width: 330,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Color.fromRGBO(96, 202, 64, 1),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 230.0,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  truncateText(
                                                      item.title ?? '제목없음', 9),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Text(
                                                  '뮬 대관 신청합니다',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          'images/ticket.png',
                                          width: 80.0,
                                          height: 80.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              right: 0.0), // 우측에만 패딩을 추가합니다.
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '지역',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Text(
                                                '대관 가격',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(right: 20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                item.location ?? '',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Text(
                                                '${formatCurrency(item.price ?? 0)}원' ??
                                                    '',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: buttonHeight),
                                  Container(
                                    height: 55.0,
                                    width: 300.0,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        var parsedUrl = Uri.parse(
                                            'http://13.209.77.161/api/booking');
                                        var headers = {
                                          'Content-Type': 'application/json'
                                        };
                                        var body = json.encode({
                                          'frNo': item.boardNo,
                                          'username': userInfo.username,
                                          'phone': userInfo.phone,
                                        });
                                        var response = await http.post(
                                          parsedUrl,
                                          headers: headers,
                                          body: body,
                                        );
                                        if (response.statusCode == 200) {
                                          Navigator.pushNamed(
                                              context, '/mypage/rental/myApp');
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10.0),
                                        textStyle: TextStyle(fontSize: 16.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                      ),
                                      child: Text('대관 신청하기'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                tooltip: 'Floating Button',
                child: Text(
                  '신청하기',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                backgroundColor: Colors.black,
                elevation: 0.0,
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
