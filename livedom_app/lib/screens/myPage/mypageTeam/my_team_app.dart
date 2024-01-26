import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:livedom_app/provider/nav_provider.dart';
import 'package:livedom_app/provider/temp_user_provider.dart';
import 'package:provider/provider.dart';

class MyTeamAppScreen extends StatefulWidget {
  const MyTeamAppScreen({super.key});

  @override
  State<MyTeamAppScreen> createState() => _MyTeamAppScreenState();
}

class _MyTeamAppScreenState extends State<MyTeamAppScreen> {
//팀 리스트 state
  List _teamList = [];

  var _pageObject = {};

  //페이지 정보 state
  int _page = 1;
  int _rows = 4;
  //스크롤 컨트롤러
  final ScrollController _infContoller = ScrollController();

  //애니메이션 너비 속성
  final List<double> _animaWidth = [];

  Future getTeamAppList(user) async {
    var teamListURL =
        'http://13.209.77.161/api/user/team/listByMember?page=${_page}&rows=${_rows}&username=${user.userInfo['username']}';
    var parsedURI = Uri.parse(teamListURL);
    //응답
    var teamListResponse = await http.get(parsedURI);
    print(teamListResponse.statusCode);

    if (teamListResponse.statusCode == 200) {
      //UTF - 8 디코딩
      var teamListDecoded = utf8.decode(teamListResponse.bodyBytes);

      //JSON 디코딩
      var teamListJSON = jsonDecode(teamListDecoded);
      print(teamListJSON);
      final List tempTeamList = teamListJSON['data'];
      _pageObject = teamListJSON['page'];
      if (_pageObject['page'] > _pageObject['last']) {
        return;
      }

      setState(() {
        _page++;
        _teamList.addAll(tempTeamList);
      });
      for (var i = 0; i < tempTeamList.length; i++) {
        _animaWidth.add(0.0);
      }
    }
  }

  Widget Confirmed() {
    return Container(
      width: 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(
                  10.0,
                )),
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget UnDeposited() {
    return Container(
      width: 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(
                  10.0,
                )),
            child: Icon(
              Icons.money_off_csred,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget UnChecked() {
    return Container(
      width: 60.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(
                  10.0,
                )),
            child: Icon(
              Icons.help,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget Approval() {
    return Container(
      width: 60.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(
                  10.0,
                )),
            child: Icon(
              Icons.upcoming,
              color: Colors.white,
              size: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget Denied() {
    return Container(
      width: 60.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(
                  10.0,
                )),
            child: Icon(
              Icons.do_not_disturb_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget UnDepositBackground() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            margin: EdgeInsets.only(
              bottom: 20.0,
              right: 1.0,
            ),
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(18.0)),
            height: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 13.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '승인',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 11.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '신청\n취소',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int _navIndex = 2;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final context = this.context;
      int tempIndex = Provider.of<NavProvider>(context, listen: false).navIndex;
      setState(() {
        _navIndex = tempIndex;
      });
      final user = Provider.of<TempUserProvider>(context, listen: false);
      getTeamAppList(user);
      _infContoller.addListener(() async {
        if (_infContoller.position.maxScrollExtent <= _infContoller.offset) {
          getTeamAppList(user);
        }
      });
      for (var i = 0; i < 6; i++) {
        _animaWidth.add(0.0);
      }
    });
  }

  Future ExApproval(context, index) async {
    var user = Provider.of<TempUserProvider>(context, listen: false);
    var result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        // 모달 바텀 시트에 표시될 위젯을 생성
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.center,
                child: Text(
                  '참가 신청을 승인하시겠습니까?',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        print('참가신청 승인을 확인했습니다.');
                        //요청
                        final String url =
                            'http://13.209.77.161/api/team/app/accept';
                        final parsedUri = Uri.parse(url);
                        final headers = {
                          'Content-Type': 'application/json',
                        };
                        final body = {
                          'appNo': _teamList[index]['appNo'],
                        };
                        final parsedBody = json.encode(body);
                        var result = await http.put(
                          parsedUri,
                          headers: headers,
                          body: parsedBody,
                        );

                        if (result.statusCode == 200) {
                          print('참가신청 승인 처리가 완료되었습니다.');
                          setState(() {
                            _teamList[index]['approvalStatus'] = 1;
                          });
                        } else {
                          print('참가신청 승인 처리에 실패하였습니다.');
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        '예',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        print('참가신청 승인을 취소했습니다.');
                        Navigator.pop(context);
                      },
                      child: Text(
                        '아니오',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
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
    if (result != null) {
      setState(() {
        _animaWidth[index] = 0.0;
      });
      return result;
    } else {
      setState(() {
        _animaWidth[index] = 0.0;
      });
      return result;
    }
  }

  Future ExCancel(context, index) async {
    final user = Provider.of<TempUserProvider>(
      context,
      listen: false,
    );
    var result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        // 모달 바텀 시트에 표시될 위젯을 생성
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.center,
                child: Text(
                  '참가 신청을 취소하시겠습니까?',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        print('참가신청을 취소 확인했습니다.');
                        //요청
                        final String url =
                            'http://13.209.77.161/api/team/app/${_teamList[index]['appNo']}';
                        final parsedUri = Uri.parse(url);
                        var result = await http.delete(
                          parsedUri,
                        );

                        if (result.statusCode == 200) {
                          print('참가신청 취소 처리가 완료되었습니다.');
                          setState(() {
                            _teamList.removeAt(index);
                          });
                        } else {
                          print('참가신청 취소 처리에 실패하였습니다.');
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        '예',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        print('참가신청 거절을 취소했습니다.');
                        Navigator.pop(context);
                      },
                      child: Text(
                        '아니오',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
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
    if (result != null) {
      setState(() {
        _animaWidth[index] = 0.0;
      });
      return result;
    } else {
      setState(() {
        _animaWidth[index] = 0.0;
      });
      return result;
    }
  }

  Future ExConfirm(context, index) async {
    final user = Provider.of<TempUserProvider>(
      context,
      listen: false,
    );
    var result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        // 모달 바텀 시트에 표시될 위젯을 생성
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.center,
                child: Text(
                  '참가 신청을 확정하시겠습니까?',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: ElevatedButton(
                      onPressed: () async {
                        print('참가신청 확정을 확인했습니다.');
                        //요청
                        final String url =
                            'http://13.209.77.161/api/team/app/confirmed';
                        final parsedUri = Uri.parse(url);
                        final headers = {
                          'Content-Type': 'application/json',
                        };
                        final body = {
                          'appNo': _teamList[index]['appNo'],
                        };
                        final parsedBody = json.encode(body);
                        var result = await http.put(
                          parsedUri,
                          headers: headers,
                          body: parsedBody,
                        );

                        if (result.statusCode == 200) {
                          print('참가신청 확정 처리가 완료되었습니다.');
                          setState(() {
                            _teamList[index]['depositStatus'] = 1;
                          });
                        } else {
                          print('참가신청 확정 처리에 실패하였습니다.');
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        '예',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        print('참가신청 확정을 취소했습니다.');
                        Navigator.pop(context);
                      },
                      child: Text(
                        '아니오',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
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
    if (result != null) {
      setState(() {
        _animaWidth[index] = 0.0;
      });
      return result;
    } else {
      setState(() {
        _animaWidth[index] = 0.0;
      });
      return result;
    }
  }

  Widget SetDepositWidget(item) {
    switch (item['depositStatus']) {
      case 0:
        return UnDeposited();
      case 1:
        return Confirmed();
      default:
        return Container();
    }
  }

  Widget SetApprovalWidget(item) {
    switch (item['approvalStatus']) {
      case 0:
        return UnChecked();
      case 1:
        return Approval();
      case 2:
        return Denied();
      default:
        return Container();
    }
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
                      '팀 모집 현황',
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
                                  10.0,
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
                      margin: EdgeInsets.only(
                        right: 13.0,
                      ),
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
                                  10.0,
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
                      margin: EdgeInsets.only(
                        left: 13.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(
                                  10.0,
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
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(
                                  10.0,
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
                            padding: EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(
                                  10.0,
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
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    if (index < _teamList.length) {
                      final item = _teamList[index];
                      return GestureDetector(
                        onHorizontalDragUpdate: (details) async {
                          if (item['approvalStatus'] == 0 &&
                              details.delta.dx < 0) {
                            // 오른쪽 스와이프 제스처가 감지됨
                            print('왼쪽스와이프');
                            setState(() {
                              _animaWidth[index] =
                                  -50.0; // 애니메이션을 위해 width 값을 변경
                            });
                            ExCancel(context, index);
                          }
                        },
                        onTap: () async {
                          final result = await http.get(Uri.parse(
                              'http://13.209.77.161/api/team/${item['teamNo']}'));
                          Map decodedResult = await json.decode(utf8.decode(result.bodyBytes));

                          Navigator.pushNamed(
                            context,
                            '/team/read',
                            arguments: decodedResult,
                          );
                        },
                        child: Stack(
                          children: [
                            item['depositStatus'] == 0
                                ? UnDepositBackground()
                                : Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AnimatedContainer(
                                    transform: Matrix4.translationValues(
                                        _animaWidth[index], 0, 0),
                                    duration: Duration(
                                      milliseconds: 200,
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    margin: EdgeInsets.only(
                                      bottom: 20.0,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 1.0,
                                          color: Colors.black12,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(18.0)),
                                    height: 100.0,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 12.0,
                                        ),
                                        Container(
                                          width: 30.0,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              SetDepositWidget(item),
                                              SetApprovalWidget(item),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    '${item['title'].length > 9 ? item['title'].substring(0, 9) + '...' : item['title']}',
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            subtitle: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    '${item['phone']}',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    '${item['bandName']}',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    '${item['updDate'].split('T')[0]}',
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
