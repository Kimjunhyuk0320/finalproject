import 'package:flutter/material.dart';
import 'package:livedom_app/model/liveboard.dart';
import 'package:livedom_app/screens/comment/comment_screen.dart';
import 'dart:ui';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class LiveBoardReadScreen extends StatefulWidget {
  @override
  State<LiveBoardReadScreen> createState() => _LiveBoardReadScreenState();
}

class _LiveBoardReadScreenState extends State<LiveBoardReadScreen> {
  
  int _count = 1;
  
  @override
  Widget build(BuildContext context) {
    final LiveBoard item =
        ModalRoute.of(context)!.settings.arguments as LiveBoard;

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
                                item.soldOut == 0
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
                                          '판매중',
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
                                  item.title ?? '',
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
                                  item.crew ?? '',
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
                                      '잔여 티켓 ${item.ticketLeft}장' ?? '',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      item.liveDate ?? '',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      item.liveTime ?? '',
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
                      '공연 정보',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: Colors.white,
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {},
                        color: Colors.white,
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
            DefaultTabController(
              length: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('공연정보'),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('관람후기'),
                          ),
                        ),
                      ],
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.black,
                      indicatorColor: Colors.black,
                      indicatorSize: TabBarIndicatorSize.label,
                      isScrollable: true,
                    ),
                    SizedBox(
                      height: 10000,
                      child: TabBarView(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              item.content ?? '',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: CommentScreen(item: item, parentTable: 'live_board')
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                                            item.title ?? '제목 없음',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            '티켓을 구매합니다',
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
                                      '잔여티켓',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 15.0,),
                                    Text(
                                      '선택한 티켓',
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
                                      '${item.ticketLeft}장',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(height: 10.0,),
                                    Row(
                                      children: [
                                        Text(
                                          '${_count}장',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        SizedBox(width: 30.0,),
                                        Container(
                                          height: 35.0,
                                          width: 35.0,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                if (_count < 9) {
                                                  _count++;
                                                }
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 190, 190, 190),
                                              foregroundColor: Colors.black,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                  vertical: 10.0),
                                              textStyle: TextStyle(
                                                  fontSize: 16.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                            ),
                                            child: Text('+'),
                                          ),
                                        ),
                                        SizedBox(width: 5.0,),
                                        Container(
                                          height: 35.0,
                                          width: 35.0,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                if (_count > 1) {
                                                  _count--;
                                                }
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 190, 190, 190),
                                              foregroundColor: Colors.black,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                  vertical: 10.0),
                                              textStyle: TextStyle(
                                                  fontSize: 16.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                            ),
                                            child: Text('-'),
                                          ),
                                        ),
                                      ],
                                    )
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
                                child: Text('결제하기'),
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