import 'package:flutter/material.dart';
import 'package:livedom_app/model/rental.dart';
import 'package:livedom_app/screens/comment/comment_screen.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:livedom_app/model/liveboard.dart';
import 'package:livedom_app/screens/comment/comment_screen.dart';
import 'dart:ui';

class RentalReadScreen extends StatefulWidget {
  @override
  State<RentalReadScreen> createState() => _RentalReadScreenState();
}

class _RentalReadScreenState extends State<RentalReadScreen> {
  int selectedIndex = 0;
  int _count = 1;
  // 말 줄이기 함수
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

  @override
  Widget build(BuildContext context) {
    final Rental item =
        ModalRoute.of(context)!.settings.arguments as Rental;

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
                      'http://10.0.2.2:8080/api/file/img/${item.thumbnail}',
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
                        'http://10.0.2.2:8080/api/file/img/${item.thumbnail}',
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
                                        width: 50,
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
                                                  255, 221, 221, 221)),
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
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                Text(
                                  formatMultilineText(item.title ?? ''),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontSize: 20.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  item.writer ?? '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  item.address ?? '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
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
                      style: TextStyle(color: Colors.white),
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
                      PopupMenuButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onSelected: (value) {
                          if (value == 'item1') {
                            // 'item1'이 선택되었을 때 수행할 작업
                          } else if (value == 'item2') {
                            // 'item2'가 선택되었을 때 수행할 작업
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
                      ),
                    ],
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedIndex == 0 ? Colors.black : Colors.transparent,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      '공연정보',
                      style: TextStyle(
                        color: selectedIndex == 0 ? Colors.black : Colors.grey,
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedIndex == 1 ? Colors.black : Colors.transparent,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      '공연후기',
                      style: TextStyle(
                        color: selectedIndex == 1 ? Colors.black : Colors.grey,
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
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Visibility(
                  visible: selectedIndex == 0, // 인덱스에 따라 화면 보이기/숨기기
                  child: Text(
                    item.content ?? '',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Visibility(
                  visible: selectedIndex == 1, // 인덱스에 따라 화면 보이기/숨기기
                  child: CommentScreen(item: item, parentTable: 'facility_rental'),
                ),
              ],
            ),
          ),

          
          SizedBox(height: 60,),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 55.0,
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
        child: FloatingActionButton(
          onPressed: () async {
            _count = 1;
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
              ),
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.45,
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
                            SizedBox(height: 10.0),
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
                                            truncateText(item.title ?? '제목없음', 10),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            '뮬 대관 신청합니다',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    'images/ticket.png',
                                    width: 100.0,
                                    height: 100.0,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '지역',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 15.0,),
                                    Text(
                                      '대관 가격',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.location??'',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 15.0,),
                                    Text(
                                      '${formatCurrency(item.price ?? 0)}원'??'',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Container(
                              height: 55.0,
                              width: 300.0,
                              child: ElevatedButton(
                                onPressed: () {
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 10.0),
                                  textStyle: TextStyle(
                                      fontSize: 16.0),
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
            '결제하기',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          backgroundColor: Colors.black,
          elevation: 0.0,
        ),
      ),
    );
  }
}
