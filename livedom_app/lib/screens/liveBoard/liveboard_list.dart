import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:livedom_app/model/liveboard.dart';

class LiveBoardListScreen extends StatefulWidget {
  const LiveBoardListScreen({Key? key}) : super(key: key);

  @override
  _LiveBoardListScreenState createState() => _LiveBoardListScreenState();
}

class _LiveBoardListScreenState extends State<LiveBoardListScreen> {
  int selectedIndex = 2;

  final ScrollController _controller = ScrollController();

  List<dynamic> items = [];

  int _page = 1;

  Map<String, dynamic> _pageObj = {'last': 10};

  //스켈레톤 UI용 다음 데이터 갯수
  int _nextCount = 0;

  //캐싱 여부
  String isCaching = '';

  //데이터 중복 호출 방지 스위치
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    // 처음 데이터
    fetch();

    _controller.addListener(() {
      // 스크롤 맨 밑
      // _controller.position.maxScrollExtent : 스크롤 위치의 최댓값
      // _controller.position.offset          : 현재 스크롤 위치

      if (_controller.position.maxScrollExtent < _controller.offset + 2100) {
        // 데이터 요청 (다음 페이지)
        fetch();
      }
    });
  }

  // 말 줄이기 함수
  String truncateText(String text, int length) {
    if (text.length <= length) {
      return text;
    } else {
      return '${text.substring(0, length)}...';
    }
  }

  Future fetch() async {
    if (isFetching) return;
    setState(() {
      isFetching = true;
    });
    print('fetch...');
    // 여기에 네트워크 요청 등을 처리하면 됩니다.
    // 이 예제에서는 간단히 items에 추가하는 형태로 작성했습니다.
    final url = Uri.parse(
        'http://10.0.2.2:8080/api/liveBoard/liveBoardPageList?page=${_page}&order=${selectedIndex}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        // items.addAll(['New']);

        // JSON 문자열 ➡ List<>
        var utf8Decoded = utf8.decode(response.bodyBytes);
        var result = json.decode(utf8Decoded);
        final page = result['page'];
        final List<dynamic> list = result['data'];
        print('page : $page');
        _pageObj = page;
        _nextCount = page['nextCount'];

        items.addAll(list.map<LiveBoard>((item) {
          return LiveBoard(
            boardNo: item['boardNo'],
            title: item['title'],
            writer: item['writer'],
            username: item['username'],
            content: item['content'],
            crew: item['crew'],
            price: item['price'],
            liveDate: item['liveDate'],
            liveTime: item['liveTime'],
            location: item['location'],
            address: item['address'],
            maxTickets: item['maxTickets'],
            updDate: item['updDate'],
            soldOut: item['soldOut'], // 수정 부분
            thumbnail:
                item['thumbnail'] == null ? 0 : item['thumbnail']['fileNo'],
            ticketLeft: item['ticketLeft'],
            isCaching: false,
          );
        }));
        // 다음 페이지
        _page++;
      });
    }
    setState(() {
      isFetching = false;
    });
  }

  Widget buildTextButton(int buttonIndex, String buttonText) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedIndex = buttonIndex;
          _page = 1;
          items.clear();
          fetch();
        });
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: selectedIndex == buttonIndex
                  ? Colors.blue
                  : Colors.transparent,
            ),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed) ||
                states.contains(MaterialState.hovered)) {
              return Colors.transparent;
            }
            return Colors.transparent;
          },
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.black,
          fontSize: 11,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          controller: _controller,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: Image.asset(
                      'images/main2.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SafeArea(
                    top: true,
                    child: AppBar(
                      // title: const Text(
                      //   '티켓팅',
                      //   style: TextStyle(
                      //       color: Colors.black, fontWeight: FontWeight.w900),
                      //   textAlign: TextAlign.center,
                      // ),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new),
                        onPressed: () {
                          Navigator.of(context).pop(); // 뒤로가기 기능
                        },
                        color: Colors.white, // 뒤로가기 버튼 색상
                      ),
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
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/adver.png'), // 이미지 경로를 수정해주세요
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTextButton(0, '인기순'),
                    buildTextButton(1, '공연임박순'),
                    buildTextButton(2, '최신순'),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.56,
                height: 35,
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                itemBuilder: (context, index) {
                  // index: 0~19
                  if (index < items.length) {
                    final item = items[index];
                    return Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
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
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          item.soldOut == 0
                                              ? Container(
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '판매중',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                )
                                              : Container(
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    border: Border.all(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '매진',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            truncateText(item.title,
                                                17), // 최대 길이를 설정 (예: 20)
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            truncateText(item.crew, 17),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            truncateText(item.address, 17),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                truncateText(item.liveDate, 17),
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                truncateText(item.liveTime, 17),
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                truncateText(item.location, 17),
                                                style: TextStyle(
                                                    color: Colors.grey),
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
                  else if ((_page - 1) > 0 && (_page - 1) < _pageObj['last']!) {
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
                itemCount: items.length + _nextCount,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/liveboard/insert');
          },
          tooltip: 'Increment',
          child: Icon(
            Icons.edit,
            color: Colors.white, // 아이콘 색상을 흰색으로 설정
          ),
          backgroundColor: Colors.black, // 배경색을 검은색으로 설정
          shape: CircleBorder(), // 원형으로 설정
        ));
  }
}
