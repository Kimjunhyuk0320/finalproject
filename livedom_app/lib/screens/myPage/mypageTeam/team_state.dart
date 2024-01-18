import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeamStateScreen extends StatefulWidget {
  const TeamStateScreen({super.key});

  @override
  State<TeamStateScreen> createState() => _TeamStateScreenState();
}

class _TeamStateScreenState extends State<TeamStateScreen> {
//팀 리스트 state
  List _teamList = [];

  var _pageObject = {};

  //페이지 정보 state
  int _page = 1;
  int _rows = 4;
  //스크롤 컨트롤러
  final ScrollController _infContoller = ScrollController();

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

  @override
  void initState() {
    super.initState();
    // getTeamList();
    _infContoller.addListener(() async {
      if (_infContoller.position.maxScrollExtent <= _infContoller.offset) {
        getTeamList();
      }
    });
  }

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
                    '팀 모집 현황',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 80.0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(
                                  100.0,
                                )),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                          Text('참가확정'),
                        ],
                      ),
                    ),
                    Container(
                      width: 80.0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(
                                  100.0,
                                )),
                            child: Icon(
                              Icons.money_off_csred,
                              color: Colors.white,
                            ),
                          ),
                          Text('미입금'),
                        ],
                      ),
                    ),
                    Container(
                      width: 1.0,
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          vertical: BorderSide(
                            width: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 60.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(
                                  100.0,
                                )),
                            child: Icon(
                              Icons.help,
                              color: Colors.white,
                            ),
                          ),
                          Text('미확인'),
                        ],
                      ),
                    ),
                    Container(
                      width: 60.0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(
                                  100.0,
                                )),
                            child: Icon(
                              Icons.upcoming,
                              color: Colors.white,
                              size: 18.0,
                            ),
                          ),
                          Text('승인'),
                        ],
                      ),
                    ),
                    Container(
                      width: 60.0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(
                              100.0,
                            )),
                            child: Icon(
                              Icons.do_not_disturb_outlined,
                              color: Colors.white,
                            ),
                          ),
                          Text('거절'),
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
                            title: Container(),
                            subtitle: Container(),
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
