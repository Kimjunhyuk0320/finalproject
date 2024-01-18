import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livedom_app/provider/temp_user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TeamInsertScreen extends StatefulWidget {
  const TeamInsertScreen({super.key});

  @override
  State<TeamInsertScreen> createState() => _TeamInsertScreenState();
}

class _TeamInsertScreenState extends State<TeamInsertScreen> {
  final TextEditingController _titleController =
      TextEditingController(text: '');
  String _capacity = '1';
  final TextEditingController _dateController = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));
  final TextEditingController _stTimeController =
      TextEditingController(text: '00:00');
  final TextEditingController _endTimeController =
      TextEditingController(text: '00:00');
  String _location = '경기';
  final TextEditingController _addressController =
      TextEditingController(text: '');
  String _account = '신한은행';
  final TextEditingController _accountController =
      TextEditingController(text: '');
  final TextEditingController _priceController =
      TextEditingController(text: '');
  final TextEditingController _contentController =
      TextEditingController(text: '');

  Future<String> submit(user) async {
    print('submit함수 진입');
    final url = 'http://10.0.2.2:8080/api/team';
    final parsedUrl = Uri.parse(url);
    final body = json.encode({
      'username': user.userInfo['username'],
      'title': _titleController.text,
      'writer': user.userInfo['nickname'],
      'content': _contentController.text,
      'location': _location,
      'address': _addressController.text,
      'liveDate': _dateController.text,
      'liveStTime': _stTimeController.text,
      'liveEndTime': _endTimeController.text,
      'price': _priceController.text,
      'capacity': _capacity,
      'account1': _account,
      'account2': _accountController.text,
    });
    final headers = {
      'Content-Type': 'application/json',
    };
    print('submit함수 요청 직전');
    var result = await http.post(
      parsedUrl,
      headers: headers,
      body: body,
    );

    print('submit함수 요청 직후');
    if (result.statusCode == 200) {
      return 'done';
    } else {
      return 'dont';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Text(
                '팀 모집글 작성',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 100.0,
            ),
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            width: double.infinity,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '제목',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(18.0)),
                            margin: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            child: TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                hintText: '',
                                contentPadding: EdgeInsets.only(
                                  bottom: 0.0,
                                  left: 10.0,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '모집팀 수',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(18.0)),
                                margin: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                child: DropdownButton<String>(
                                  underline: Container(),
                                  value: _capacity,
                                  items: <String>[
                                    '1',
                                    '2',
                                    '3',
                                    '4',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.27,
                                        child: Text(
                                          '${value}명',
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      value: value,
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _capacity = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '공연일자',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(18.0)),
                                margin: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    DateTime? result = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2024),
                                      lastDate: DateTime(2044),
                                      initialDate: DateTime.parse(
                                          _dateController.text
                                              .replaceAll('/', '-')),
                                    );
                                    setState(() {
                                      _dateController.text =
                                          DateFormat('yyyy/MM/dd').format(
                                              result ??
                                                  DateTime.parse(_dateController
                                                      .text
                                                      .replaceAll('/', '-')));
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AbsorbPointer(
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            readOnly: true,
                                            controller: _dateController,
                                            decoration: InputDecoration(
                                              hintText: '',
                                              contentPadding: EdgeInsets.only(
                                                bottom: 0.0,
                                                left: 10.0,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          right: 10.0,
                                        ),
                                        child: Icon(Icons.date_range),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '공연 시작 시각',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(18.0)),
                                margin: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    TimeOfDay? result = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                          hour: int.parse(_stTimeController.text
                                              .split(':')[0]),
                                          minute: int.parse(_stTimeController
                                              .text
                                              .split(':')[1]),
                                        ));
                                    if (result == null) {
                                      result = TimeOfDay.now();
                                      return;
                                    }
                                    setState(() {
                                      _stTimeController.text =
                                          '${result!.hour.toString().length == 1 ? '0' + result!.hour.toString() : result!.hour.toString()}:${result!.minute.toString().length == 1 ? '0' + result!.minute.toString() : result!.minute.toString()}';
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AbsorbPointer(
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            readOnly: true,
                                            controller: _stTimeController,
                                            decoration: InputDecoration(
                                              hintText: '',
                                              contentPadding: EdgeInsets.only(
                                                bottom: 0.0,
                                                left: 10.0,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          right: 10.0,
                                        ),
                                        child: Icon(Icons.timer_outlined),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '공연 종료 시각',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(18.0)),
                                margin: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    TimeOfDay? result = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                          hour: int.parse(_endTimeController.text
                                              .split(':')[0]),
                                          minute: int.parse(_endTimeController
                                              .text
                                              .split(':')[1]),
                                        ));
                                    if (result == null) {
                                      result = TimeOfDay.now();
                                      return;
                                    }
                                    setState(() {
                                      _endTimeController.text =
                                          '${result!.hour.toString().length == 1 ? '0' + result!.hour.toString() : result!.hour.toString()}:${result!.minute.toString().length == 1 ? '0' + result!.minute.toString() : result!.minute.toString()}';
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AbsorbPointer(
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            readOnly: true,
                                            controller: _endTimeController,
                                            decoration: InputDecoration(
                                              hintText: '',
                                              contentPadding: EdgeInsets.only(
                                                bottom: 0.0,
                                                left: 10.0,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          right: 10.0,
                                        ),
                                        child: Icon(Icons.timer),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '지역',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(18.0)),
                            margin: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            child: DropdownButton<String>(
                              underline: Container(),
                              value: _location,
                              items: <String>[
                                '경기',
                                '서울',
                                '부산',
                                '경남',
                                '인천',
                                '경북',
                                '대구',
                                '충남',
                                '전남',
                                '전북',
                                '충북',
                                '강원',
                                '대전',
                                '광주',
                                '울산',
                                '제주',
                                '세종',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.27,
                                    child: Text(
                                      '${value}',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _location = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '장소',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(18.0)),
                            margin: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            child: TextField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                hintText: '',
                                contentPadding: EdgeInsets.only(
                                  bottom: 0.0,
                                  left: 10.0,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '계좌번호',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(18.0)),
                                margin: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10.0),
                                child: DropdownButton<String>(
                                  underline: Container(),
                                  value: _account,
                                  items: <String>[
                                    '신한은행',
                                    '우리은행',
                                    '하나은행',
                                    'SC은행',
                                    '도이치은행',
                                    '뱅크오브아메리카',
                                    '수협은행',
                                    '제주은행',
                                    '카카오뱅크',
                                    '케이뱅크',
                                    '한국씨티은행',
                                    'BNP파리바은행',
                                    'HSBC은행',
                                    'JP모건체이스은행',
                                    '산림조합중앙회',
                                    '저축은행',
                                    '신협중앙회',
                                    '우체국',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.27,
                                        child: Text(
                                          '${value}',
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      value: value,
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _account = newValue!;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.51,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(18.0)),
                                margin: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 0.0),
                                child: TextField(
                                  controller: _accountController,
                                  decoration: InputDecoration(
                                    hintText: '',
                                    contentPadding: EdgeInsets.only(
                                      bottom: 0.0,
                                      left: 10.0,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '가격',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(18.0)),
                            margin: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            child: TextField(
                              controller: _priceController,
                              decoration: InputDecoration(
                                hintText: '',
                                contentPadding: EdgeInsets.only(
                                  bottom: 0.0,
                                  left: 10.0,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '내용',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(18.0)),
                            margin: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            child: TextField(
                              controller: _contentController,
                              decoration: InputDecoration(
                                hintText: '',
                                contentPadding: EdgeInsets.only(
                                  bottom: 0.0,
                                  left: 10.0,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100.0,
                    ),
                  ],
                ),
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
                              '팀 모집글을 등록하시겠습니까?',
                              style: TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Consumer<TempUserProvider>(
                                builder: (context, value, child) {
                                  return GestureDetector(
                                    onTap: () async {
                                      //예 선택 시 실행 함수
                                      var user =
                                          context.read<TempUserProvider>();
                                      var result = await submit(user);
                                      if (result == 'done') {
                                        print('등록완료');
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/team',
                                        );
                                      } else {
                                        print('등록실패');
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                      ),
                                      child: Text(
                                        '예',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  //아니오 선택 시 실행 함수
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
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
                  '작성완료',
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
