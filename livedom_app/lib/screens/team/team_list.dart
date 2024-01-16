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

  List newData = [];
  //페이지 정보 state
  int _page = 1;
  int _rows = 4;
  //스크롤 컨트롤러
  final ScrollController _infContoller = ScrollController();

  @override
  void initState() {
    super.initState();
    _infContoller.addListener(() async {
      if (_infContoller.position.maxScrollExtent < _infContoller.offset + 100) {
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

    //UTF - 8 디코딩
    var teamListDecoded = utf8.decode(teamListResponse.bodyBytes);

    //JSON 디코딩
    var teamListJSON = jsonDecode(teamListDecoded);

    final List tempTeamList = teamListJSON;

    setState(() {
      _teamList.addAll(tempTeamList);
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('공연 팀 모집'),
    //   ),
    //   body: Column(
    //     children: [
    //       ElevatedButton(
    //         child: Text("home"),
    //         style: ElevatedButton.styleFrom(
    //           backgroundColor: Colors.black,
    //           foregroundColor: Colors.white,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0)
    //           ),
    //           elevation: 5
    //         ),
    //         onPressed: () async {
    //           Navigator.pushReplacementNamed(context, '/');
    //         },
    //       ),
    //     ],
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('Infinity Scroll'),
      ),
      body: ListView.builder(
        controller: _infContoller,
        padding: EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final item = _teamList[index];
          return ListTile(
            title: Text(item.title),
          );
        },
        itemCount: _teamList.length,
      ),
    );
  }
}
