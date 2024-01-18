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
      if (_infContoller.position.maxScrollExtent <= _infContoller.offset) {
        getTeamList();
      }
    });
  }

  Future getTeamList() async {
    var teamListURL =
        'http://10.0.2.2:8080/api/team?page=${_page}&rows=${_rows}&keyword=${_keywordController.text}';
    var parsedURI = Uri.parse(teamListURL);
    //응답
    var teamListResponse = await http.get(parsedURI);

    if (teamListResponse.statusCode == 200) {
      //UTF - 8 디코딩
      var teamListDecoded = utf8.decode(teamListResponse.bodyBytes);

      //JSON 디코딩
      var teamListJSON = jsonDecode(teamListDecoded);

      final List tempTeamList = teamListJSON['data'];
      _pageObject = teamListJSON['page'];
      if (_pageObject['page'] > _pageObject['last']) {
        return;
      }

      setState(() {
        _page++;
        _teamList.addAll(tempTeamList);
      });
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
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/teamListBanner.png'),
                    fit: BoxFit.cover,
                    alignment: FractionalOffset(0.5, 0.8),
                  ),
                ),
                child: Align(
                  alignment: FractionalOffset(0.5, 0.1),
                  child: Text(
                    '팀 모집',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                    ),
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
                                  '  ${item['title']}',
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
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (_pageObject['last'] != null &&
                        _page > 2 &&
                        _pageObject['last'] > _page) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      // 기본적인 위젯 반환
                      return Container();
                    }
                  },
                  itemCount: _teamList.length + 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
