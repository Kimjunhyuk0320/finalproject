import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:livedom_app/model/team.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/auth_provider.dart';
import 'package:livedom_app/provider/nav_provider.dart';
import 'package:livedom_app/provider/temp_user_provider.dart';
import 'package:livedom_app/screens/comment/comment_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TeamReadScreen extends StatefulWidget {
  const TeamReadScreen({super.key});

  @override
  State<TeamReadScreen> createState() => _TeamReadScreenState();
}

class _TeamReadScreenState extends State<TeamReadScreen> {
  Future<String> delete(teamNo) async {
    final url = 'http://13.209.77.161/api/team/${teamNo}';
    final parsedUrl = Uri.parse(url);
    var response = await http.delete(parsedUrl);
    if (response.statusCode == 200) {
      return 'done';
    } else {
      return 'dont';
    }
  }

  int selectedIndex = 0;
  int _navIndex = 2;
  //로그인 상태
  bool _loginState = false;

  //회원 정보
  Users userInfo = Users();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      int tempIndex = Provider.of<NavProvider>(context, listen: false).navIndex;
      bool tempLoginState =
          Provider.of<AuthProvider>(context, listen: false).isLogin;
      setState(() {
        _navIndex = tempIndex;
        _loginState = tempLoginState;
      });
      if (_loginState) {
        Users tempUserInfo =
            Provider.of<AuthProvider>(context, listen: false).currentUser!;
        setState(() {
          userInfo = tempUserInfo;
        });
      }
    });
    viewUp();
  }

  Future<void> viewUp() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      final Map team = ModalRoute.of(context)?.settings.arguments as Map;
      print('팀 데이터는 다음과 같습니다 : ${team}');
      var headers = {
        'Content-Type': 'application/json',
      };
      var body = json.encode(
        {
          'parentTable': 'team_recruitments',
          'parentNo': team['teamNo'],
        },
      );
      print(team['teamNo']);
      await http.put(
        Uri.parse('http://13.209.77.161/api/user/viewUp'),
        headers: headers,
        body: body,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map team = ModalRoute.of(context)?.settings.arguments as Map;
    final Team commentData = Team(
      boardNo: team['teamNo'],
      title: team['title'],
      writer: team['writer'],
      username: team['username'],
      content: team['content'],
      location: team['location'],
      address: team['address'],
      liveDate: team['liveDate'],
      liveStTime: team['liveStTime'],
      liveEndTime: team['liveEndTime'],
      price: team['price'],
      capacity: team['capacity'],
      account: team['account'],
      account1: team['account1'],
      account2: team['account2'],
      views: team['views'],
      confirmed: team['confirmed'],
      updDate: team['updDate'],
    );
    final String _confirmed = team['confirmed'] == 1 ? '마감' : '모집중';
    final _confirmedColor = team['confirmed'] == 1 ? Colors.red : Colors.green;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/teamListBanner.png'),
                        fit: BoxFit.cover,
                        alignment: FractionalOffset(0.5, 0.8),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: 10.0,
                                    right: 65.0,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                  alignment: FractionalOffset(0, 0.15),
                                ),
                              ),
                              Text(
                                '팀 모집글 조회',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 60.0,
                              ),
                              Container(
                                width: 40,
                                child: userInfo.username != null &&
                                        userInfo.username == team['username']
                                    ? PopupMenuButton<String>(
                                        icon: Icon(
                                          Icons.menu,
                                          color: Colors.white,
                                          size: 30.0,
                                        ), // 메뉴 아이콘을 설정합니다.
                                        onSelected: (value) async {
                                          // 메뉴 아이템을 클릭했을 때의 동작을 정의합니다.
                                          if (value == '수정하기') {
                                            Navigator.pushNamed(
                                                context, '/team/update',
                                                arguments: team);
                                          } else if (value == '삭제하기') {
                                            var result =
                                                await delete(team['teamNo']);
                                            if (result == 'done') {
                                              Navigator.pushReplacementNamed(
                                                  context, '/team');
                                            } else {
                                              print('삭제 실패');
                                            }
                                          } else {
                                            return;
                                          }
                                        },
                                        itemBuilder: (BuildContext context) {
                                          // 팝업 메뉴의 아이템을 정의합니다.
                                          return ['수정하기', '삭제하기']
                                              .map((String choice) {
                                            return PopupMenuItem<String>(
                                              value: choice,
                                              child: Text(choice),
                                            );
                                          }).toList();
                                        },
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 20,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: _confirmedColor,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  _confirmed,
                                  style: TextStyle(
                                    color: _confirmedColor,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                              Text(
                                team['title'],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                team['writer'],
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                team['address'],
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.035,
                        ),
                      ],
                    ),
                  ),
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
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
                                  color: selectedIndex == 0
                                      ? Colors.black
                                      : Colors.grey,
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
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
                                  color: selectedIndex == 1
                                      ? Colors.black
                                      : Colors.grey,
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
                          child: Html(
                            data: team['content'],
                            extensions: [
                              TagExtension(
                                tagsToExtend: {"img"},
                                builder: (context) {
                                  final originalSrc = context.attributes['src'];

                                  // Check if the original source starts with "/file"
                                  if (originalSrc != null &&
                                      originalSrc.startsWith("/file")) {
                                    // If it starts with "/file", add the prefix
                                    final newSrc =
                                        'http://13.209.77.161$originalSrc';
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
                                  width: Width(
                                      MediaQuery.of(context).size.width * 0.9),
                                  display: Display.inlineBlock,
                                  margin: Margins.all(1.0),
                                  padding: HtmlPaddings.all(1.0)),
                            },
                          ),
                        ),
                        Visibility(
                          visible: selectedIndex == 1, // 인덱스에 따라 화면 보이기/숨기기
                          child: CommentScreen(
                              item: commentData,
                              parentTable: 'team_recruitments'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width * 0.15,
            child: team['confirmed'] == 1
                ? Container()
                : GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 20.0,
                            ),
                            height: MediaQuery.of(context).size.height * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 10.0),
                                  alignment: Alignment.centerLeft,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'images/teamAppBtnPopImg.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        team['writer'],
                                        style: TextStyle(
                                          fontSize: 48.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '팀에 참가합니다.',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  height: 60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                              left: 20.0,
                                            ),
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    60) /
                                                2,
                                            child: Text(
                                              '모집 팀 수',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                              left: 20.0,
                                            ),
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    60) /
                                                2,
                                            child: Text(
                                              '${team['recStatus']}/${team['capacity']}',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                              left: 20.0,
                                            ),
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    60) /
                                                2,
                                            child: Text(
                                              '1/N 가격',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                              left: 20.0,
                                            ),
                                            width: (MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    60) /
                                                2,
                                            child: Text(
                                              '${(team['price'] / team['capacity']).round()}원',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Navigator.pushNamed(
                                          context, '/team/read/app',
                                          arguments: {
                                            'teamNo': team['teamNo']
                                          });
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(14.0),
                                    ),
                                    child: Text(
                                      '요청하기',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '참가하기',
                        style: TextStyle(
                          color: Color.fromRGBO(244, 244, 244, 1),
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
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
