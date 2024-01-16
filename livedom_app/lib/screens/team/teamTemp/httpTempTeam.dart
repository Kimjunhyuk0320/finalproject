import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpTempTeam extends StatefulWidget {
  const HttpTempTeam({super.key});

  @override
  State<HttpTempTeam> createState() => _HttpTempTeamState();
}

class _HttpTempTeamState extends State<HttpTempTeam> {
  //팀 리스트 state
  List _teamList = [];

  var _pageObject = {};

  //페이지 정보 state
  int _page = 1;
  int _rows = 4;
  //스크롤 컨트롤러
  final ScrollController _infContoller = ScrollController();

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
        'http://10.0.2.2:8080/api/team?page=${_page}&rows=${_rows}';
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
      appBar: AppBar(
        title: Text('Infinity Scroll'),
      ),
      body: ListView.builder(
        controller: _infContoller,
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index) {
          if (index < _teamList.length) {
            final item = _teamList[index];
            return Container(
              height: 200.0,
              child: ListTile(
                title: Text(item['title']),
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
          }
        },
        itemCount: _teamList.length + 1,
      ),
    );
  }
}
