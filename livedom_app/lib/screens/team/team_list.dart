import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeamListScreen extends StatefulWidget {
  const TeamListScreen({super.key});

  @override
  State<TeamListScreen> createState() => _TeamListScreenState();
}

class _TeamListScreenState extends State<TeamListScreen> {
  //팀 리스트 state
  List _teamList = [];

  //다음 데이터 갯수
  int _nextCount = 0;

  var _pageObject = {};

  //페이지 정보 state
  int _page = 1;
  int _rows = 4;
  //스크롤 컨트롤러
  final ScrollController _infContoller = ScrollController();
  //키워드 컨트롤러
  final TextEditingController _keywordController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    getTeamList();
    _infContoller.addListener(() async {
      if (_infContoller.position.maxScrollExtent <=
          _infContoller.offset + 400) {
        getTeamList();
      }
    });
  }

  int selectedIndex = 2;
  Widget buildTextButton(int buttonIndex, String buttonText) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedIndex = buttonIndex;
          _page = 1;
          _teamList.clear();
        });
        getTeamList();
        print(_teamList);
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
        ),
      ),
    );
  }

  Future getTeamList() async {
    print(selectedIndex);
    var teamListURL =
        'http://10.0.2.2:8080/api/team?page=${_page}&rows=${_rows}&order=${selectedIndex}&keyword=${_keywordController.text}';
    var parsedURI = Uri.parse(teamListURL);
    //응답
    var teamListResponse = await http.get(parsedURI);

    if (teamListResponse.statusCode == 200) {
      setState(() {
        //UTF - 8 디코딩
        var teamListDecoded = utf8.decode(teamListResponse.bodyBytes);

        //JSON 디코딩
        var teamListJSON = jsonDecode(teamListDecoded);

        final List tempTeamList = teamListJSON['data'];
        _pageObject = teamListJSON['page'];
        _nextCount = teamListJSON['page']['nextCount'];
        if (_pageObject['page'] > _pageObject['last']) {
          return;
        }

        _page++;
        _teamList.addAll(tempTeamList);
      });
      print('다음 데이터 갯수 : ${_pageObject['nextCount']}');
    }
  }

  //클릭 시 Navigator.push롣 데이터 넘겨주기 - 라우터버전
  //Navigator.pushNamed(context, "/team", arguments: 'user');

  // 데이터 가져오기
  // String? data = ModalRoute.of(context)?.settings.arguments as String?;

  //클릭 시 Navigator.push롣 데이터 넘겨주기 - 정적버전
  // Navigator.push(context,MaterialPageRoute(builder: (context) => ReadScreen(board: _boardList[index])));
  //데이터 가져오기
  // final team;
  // const ReadScreen({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          controller: _infContoller,
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/teamListBanner.png'),
                    fit: BoxFit.cover,
                    alignment: FractionalOffset(0.5, 0.8),
                  ),
                ),
                child: SafeArea(
                  top: true,
                  child: AppBar(
                    title: const Text(
                      '팀모집 목록',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
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
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '공연장소와 찾는 밴드를 검색해보세요',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(18.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Align(
                              alignment: Alignment.center, // 아이콘을 아래로 정렬
                              child: Icon(Icons.search),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: TextField(
                              controller: _keywordController,
                              decoration: InputDecoration(
                                hintText: '소란',
                                contentPadding: EdgeInsets.only(
                                  bottom: 0.0,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (value) {
                                setState(() {
                                  _page = 1;
                                  _teamList = [];
                                  getTeamList();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                height: 40,
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    if (index < _teamList.length) {
                      final item = _teamList[index];
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
                              borderRadius: BorderRadius.circular(18.0)),
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
                                  '${item['title'].substring(0, 14)}...',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: item['confirmed'] == 1
                                          ? Colors.red
                                          : Colors.green,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    item['confirmed'] == 1 ? '마감' : '모집중',
                                    style: TextStyle(
                                      color: item['confirmed'] == 1
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
                            borderRadius: BorderRadius.circular(18.0)),
                        height: 130.0,
                        child: Container(),
                      );
                    } else {
                      // 기본적인 위젯 반환
                      return Container();
                    }
                  },
                  itemCount: _teamList.length + _nextCount,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/team/insert');
        },
        tooltip: 'Increment',
        child: Icon(
          Icons.edit,
          color: Colors.white, // 아이콘 색상을 흰색으로 설정
        ),
        backgroundColor: Colors.black, // 배경색을 검은색으로 설정
        shape: CircleBorder(), // 원형으로 설정
      ),
    );
  }
}
