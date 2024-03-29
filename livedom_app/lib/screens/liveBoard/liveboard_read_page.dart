import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:livedom_app/model/liveboard.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/auth_provider.dart';
import 'package:livedom_app/provider/nav_provider.dart';
import 'package:livedom_app/provider/temp_user_provider.dart';
import 'package:livedom_app/screens/comment/comment_screen.dart';
import 'dart:ui';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LiveBoardReadScreen extends StatefulWidget {
  @override
  State<LiveBoardReadScreen> createState() => _LiveBoardReadScreenState();
}

class _LiveBoardReadScreenState extends State<LiveBoardReadScreen> {
  int _count = 1;
  int selectedIndex = 0;
  // 말 줄이기 함수
  String truncateText(String text, int length) {
    if (text.length <= length) {
      return text;
    } else {
      return '${text.substring(0, length)}...';
    }
  }

  // 티켓 매수 얼마인지 요청
  Future<String> getTicketNum(
      int boardNo, String name, String phone, int ticketCount) async {
    print('티켓 수량 $ticketCount');
    final url = Uri.parse('http://13.209.77.161/api/liveBoard/ticketNum');
    final response = await http.post(url, body: {
      "boardNo": '$boardNo',
      "name": name,
      "phone": phone,
      "count": '$ticketCount'
    });
    if (response.statusCode == 200) {
      var res = utf8.decode(response.bodyBytes);
      print('테스트입니다 : ${res}');
      return res;
    }
    return 'ERROR';
  }

  // 티켓 매수 얼마인지 요청
  Future<String> ticketPurchase(
      int boardNo, String name, String phone, int ticketCount) async {
    print('티켓 수량122 $ticketCount');

    final url = Uri.parse('http://13.209.77.161/api/liveBoard/purchase');
    final response = await http.post(url, body: {
      "boardNo": '$boardNo',
      "name": name,
      "phone": phone,
      "count": '$ticketCount'
    });
    if (response.statusCode == 200) {
      var res = utf8.decode(response.bodyBytes);
      print('테스트입니다2222 : ${res}');
      return res;
    }
    return 'ERROR';
  }

  //이미 캐싱 분기
  String isCaching = '';
  int _navIndex = 2;
  //회원 정보
  Users userInfo = Users();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      int tempIndex = Provider.of<NavProvider>(context, listen: false).navIndex;
      LiveBoard liveBoard =
          ModalRoute.of(context)?.settings.arguments as LiveBoard;
      bool tempLoginState =
          Provider.of<AuthProvider>(context, listen: false).isLogin;
      setState(() {
        _navIndex = tempIndex;
      });
      Users tempUserInfo =
          Provider.of<AuthProvider>(context, listen: false).currentUser!;
      setState(() {
        userInfo = tempUserInfo;
      });
      if (liveBoard != null && liveBoard.isCaching!) {
        setState(() {
          _navIndex = tempIndex;
          isCaching = '?${DateTime.now().millisecondsSinceEpoch.toString()}';
        });
      }
    });
    viewUp();
  }

  Future<void> viewUp() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final LiveBoard liveBoard =
          ModalRoute.of(context)?.settings.arguments as LiveBoard;
      print('공연 데이터는 다음과 같습니다 : ${liveBoard}');
      var headers = {
        'Content-Type': 'application/json',
      };
      var body = json.encode(
        {
          'parentTable': 'live_board',
          'parentNo': liveBoard.boardNo,
        },
      );
      await http.put(
        Uri.parse('http://13.209.77.161/api/user/viewUp'),
        headers: headers,
        body: body,
      );
    });
  }

  Future<String> delete(int boardNo) async {
    var parsedUrl = Uri.parse('http://13.209.77.161/api/liveBoard/${boardNo}');
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

  Future deleteConfirm(int boardNo) async {
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
                  '공연 게시글을 삭제하시겠습니까?',
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      //예 선택 시 실행 함수
                      var result = await delete(boardNo);
                      if (result == 'done') {
                        print('삭제완료');
                        Navigator.pushReplacementNamed(
                          context,
                          '/liveboard',
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
    final LiveBoard item =
        ModalRoute.of(context)!.settings.arguments as LiveBoard;

    // 다음 버튼을 위해 > 화면 높이의 3/100 비율로 설정
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = screenHeight * 0.01;
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
                                item.soldOut == 0
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
                                          '판매중',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                255,
                                                221,
                                                221,
                                                221,
                                              ),
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
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  truncateText(item.crew ?? '', 9),
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
                                  height: 5.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '잔여 티켓 : ${item.ticketLeft}장' ?? '',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                    Text(
                                      item.liveDate ?? '',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                    Text(
                                      item.liveTime ?? '',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
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
                                  Navigator.pushNamed(
                                      context, '/liveboard/update',
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
                                  if (item.ticketLeft == item.maxTickets)
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
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    child: CommentScreen(item: item, parentTable: 'live_board'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
              ),
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.40,
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
                                                item.title ?? '제목 없음', 9),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            '티켓을 구매합니다',
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
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '잔여티켓',
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
                                        '선택한 티켓',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${item.ticketLeft}장',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.0,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              DropdownButton<int>(
                                                value: _count,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _count = newValue!;
                                                  });
                                                },
                                                items: List.generate(
                                                  9,
                                                  (index) =>
                                                      DropdownMenuItem<int>(
                                                    value: index + 1,
                                                    child: Text(
                                                      '${index + 1}',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors
                                                            .black, // 텍스트 색상 변경
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors
                                                      .black, // 드롭다운 버튼 텍스트 색상 변경
                                                ),
                                                icon: Icon(Icons
                                                    .arrow_drop_down), // 드롭다운 아이콘 변경
                                                iconSize:
                                                    24.0, // 드롭다운 아이콘 크기 변경
                                                underline:
                                                    Container(), // 드롭다운 버튼 아래 선 제거
                                                elevation:
                                                    0, // 드롭다운 버튼 위젯의 고도 설정
                                                isExpanded:
                                                    false, // 드롭다운 버튼이 가능한 최대 크기로 확장됨
                                                dropdownColor: Colors.grey[200],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 55.0,
                              width: 300.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  final authProvider =
                                      Provider.of<AuthProvider>(context,
                                          listen: false);
                                  final name = authProvider.currentUser?.name;
                                  final phone = authProvider.currentUser?.phone;
                                  getTicketNum(
                                          item.boardNo ?? 0,
                                          name ?? '구매자명',
                                          phone ?? '01011112222',
                                          _count)
                                      .then((String response) {
                                    if (response == 'SUCCESS') {
                                      ticketPurchase(
                                              item.boardNo ?? 0,
                                              name ?? '구매자명',
                                              phone ?? '01011112222',
                                              _count)
                                          .then((String response) {
                                        if (response == 'SUCCESS') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 0.0,
                                                        vertical: 60.0),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize
                                                      .min, // 세로 크기 최소화
                                                  children: [
                                                    // 큰 아이콘
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline_rounded,
                                                      color: Colors.blue, // 파란색
                                                      size: 100.0, // 아이콘 크기 조절
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    // 텍스트
                                                    Text(
                                                      '티켓 구매 성공',
                                                      style: TextStyle(
                                                          fontSize: 14.0, 
                                                          fontWeight: FontWeight.w700
                                                      ), // 텍스트 크기 조절
                                                              
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        } else if (response ==
                                            'TEMPTICKETFAIL') {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 0.0,
                                                          vertical: 60.0),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize
                                                        .min, // 세로 크기 최소화
                                                    children: [
                                                      // 큰 아이콘
                                                      Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                        size: 50.0, // 아이콘 크기 조절
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      // 텍스트
                                                      Text(
                                                        '임시 티켓 삭제 실패',
                                                        style: TextStyle(
                                                            fontSize:
                                                                20.0), // 텍스트 크기 조절
                                                      ),
                                                    ],
                                                  ));
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 0.0,
                                                          vertical: 60.0),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize
                                                        .min, // 세로 크기 최소화
                                                    children: [
                                                      // 큰 아이콘
                                                      Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                        size: 50.0, // 아이콘 크기 조절
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      // 텍스트
                                                      Text(
                                                        '임시 티켓 삭제 실패',
                                                        style: TextStyle(
                                                            fontSize:
                                                                20.0), // 텍스트 크기 조절
                                                      ),
                                                    ],
                                                  ));
                                            },
                                          );
                                        }
                                      });
                                    } else if (response == 'OVERCOUNT') {
                                      // 티켓 수 초과 모달 표시
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('오류'),
                                            content: Text(
                                                '잔여 티켓 수보다 구매 티켓 수가 많습니다.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('확인'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else if (response == 'ZERO') {
                                      // 티켓 수 초과 모달 표시
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('오류'),
                                            content: Text('매진되었습니다.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('확인'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      // 서버에러
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('오류'),
                                            content: Text('서버 오류 입니다.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('확인'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }).catchError((error) {
                                    // 오류 처리
                                    print('오류: $error');
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0),
                                  textStyle: TextStyle(fontSize: 16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
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
