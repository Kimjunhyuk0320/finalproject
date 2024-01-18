import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livedom_app/provider/temp_user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TeamReadScreen extends StatefulWidget {
  const TeamReadScreen({super.key});

  @override
  State<TeamReadScreen> createState() => _TeamReadScreenState();
}

class _TeamReadScreenState extends State<TeamReadScreen> {

  Future<String> delete(teamNo) async {
    final url = 'http://10.0.2.2:8080/api/team/${teamNo}';
    final parsedUrl = Uri.parse(url);
    var response = await http.delete(parsedUrl);
    if(response.statusCode ==200){
    return 'done';
    }else{
      return 'dont';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map team = ModalRoute.of(context)?.settings.arguments as Map;

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
                              Text(''),
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
                              Consumer<TempUserProvider>(
                                builder: (context, value, child) {
                                  return Container(
                                    width: 40,
                                    child: value.userInfo['username'] ==
                                            team['username']
                                        ? PopupMenuButton<String>(
                                            icon: Icon(
                                              Icons.menu,
                                              color: Colors.white,
                                              size: 30.0,
                                            ), // 메뉴 아이콘을 설정합니다.
                                            onSelected: (value) async {
                                              // 메뉴 아이템을 클릭했을 때의 동작을 정의합니다.
                                              if (value == '수정하기') {
                                                Navigator.pushNamed(context, '/team/update',arguments: team);
                                              } else if (value == '삭제하기') {
                                                var result = await delete(team['teamNo']);
                                                if (result == 'done'){
                                                  Navigator.pushReplacementNamed(context, '/team');
                                                }else{
                                                  print('삭제 실패');
                                                }
                                              }else{
                                                return;
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) {
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
                                  );
                                },
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
                  Container(
                    padding: EdgeInsets.all(20.0),
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width * 8,
                    child: Text(team['content']),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width * 0.15,
            child: GestureDetector(
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
                                image:
                                    AssetImage('images/teamAppBtnPopImg.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      width:
                                          (MediaQuery.of(context).size.width -
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
                                      width:
                                          (MediaQuery.of(context).size.width -
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
                                      width:
                                          (MediaQuery.of(context).size.width -
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
                                      width:
                                          (MediaQuery.of(context).size.width -
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
                                Navigator.pushNamed(context, '/team/read/app',
                                    arguments: {'teamNo': team['teamNo']});
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.6,
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
    );
  }
}
