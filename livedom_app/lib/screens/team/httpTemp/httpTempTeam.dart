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
  //페이지 정보 state
  int _page = 1;
  int _rows = 4;
  //스크롤 컨트롤러
  final ScrollController _infContoller = ScrollController();


  @override
  void initState() {
    super.initState();
    getTeamList();
    _infContoller.addListener(() { 
      if(_infContoller.position.maxScrollExtent<_infContoller.offset){

      }
    });
  }

  Future<void> getTeamList() async {
    final url = Uri.parse('http://10.0.2.2:8080/api/team?page=${_page}&rows=${_rows}');
    print(url);

    //응답
    var teamListResponse = await http.get(url);
    print(teamListResponse);

    //UTF - 8 디코딩
    var teamListDecoded = utf8.decode(teamListResponse.bodyBytes);

    //JSON 디코딩
    var teamListJSON = jsonDecode(teamListDecoded);

    print(teamListJSON);

    setState(() {
      _teamList = [];
      _teamList.addAll(teamListJSON);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('새로고침'),
        actions: [
          ElevatedButton(
            onPressed: () {
              getTeamList();
            },
            child: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        height: 50.0,
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
        child: ListView.builder(
            itemCount: _teamList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Card(
                  child: ListTile(
                    title: Text(_teamList[index].title ?? '제목없음'),
                    subtitle: Text(_teamList[index].writer ?? '-'),
                    trailing: Icon(Icons.more_vert),
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/");
                },
              );
            }),
      ),
    );
    
  }
}
