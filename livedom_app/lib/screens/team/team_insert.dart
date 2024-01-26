import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/auth_provider.dart';
import 'package:livedom_app/provider/nav_provider.dart';
import 'package:livedom_app/provider/temp_user_provider.dart';
import 'package:livedom_app/widget/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:path_provider/path_provider.dart';

class TeamInsertScreen extends StatefulWidget {
  const TeamInsertScreen({super.key});

  @override
  State<TeamInsertScreen> createState() => _TeamInsertScreenState();
}

class _TeamInsertScreenState extends State<TeamInsertScreen> {
  //서머노트용 컨트롤러
  HtmlEditorController htmlEditorController = HtmlEditorController();

  //컨트롤러
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

  Future<String> submit() async {
    print('submit함수 진입');
    final url = 'http://13.125.19.111/api/team';
    final parsedUrl = Uri.parse(url);
    final body = json.encode({
      'username': userInfo.username,
      'title': _titleController.text,
      'writer': userInfo.nickname,
      'content': await htmlEditorController.getText(),
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

  Future<String> uploadImageToServer(File image) async {
    try {
      var parsedUrl = Uri.parse('http://13.125.19.111/api/file/upload');
      var req = http.MultipartRequest('POST', parsedUrl);
      req.files.add(await http.MultipartFile.fromPath('file', image.path));
      var res = await req.send();

      if (res.statusCode == 200) {
        var resData = res.stream.bytesToString();
        return resData;
      } else {
        return '0';
      }
    } catch (e) {
      print(e);
      return '0';
    }
  }

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
      } else {
        Provider.of<NavProvider>(context, listen: false).navIndex = 2;
        Navigator.pushReplacementNamed(context, '/main');
      }
    });
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                      size: 30.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '팀 모집글 작성',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(),
              ],
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
                                          hour: int.parse(_endTimeController
                                              .text
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
                          //html_editor_enhanced
                          HtmlEditor(
                            controller: htmlEditorController, // HTML 에디터 컨트롤러
                            htmlEditorOptions: HtmlEditorOptions(
                              hint: 'Your text here...', // 에디터에 표시될 힌트
                            ),
                            otherOptions: OtherOptions(
                              height: 1400, // 에디터의 높이 설정
                            ),
                            htmlToolbarOptions: HtmlToolbarOptions(
                              customToolbarButtons: [
                                ElevatedButton(
                                  onPressed: () async {
                                    print('이미지 업로드 콜백 실행');
                                    final picker = ImagePicker();
                                    final pickedFile = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      // Upload the selected image to your server
                                      // Use the appropriate method to upload the image to your server
                                      // and get the image URL
                                      String imageUrl =
                                          await uploadImageToServer(
                                              File(pickedFile.path));
                                      // 파일을 저장합니다.
                                      // 서버에서 받은 이미지 URL을 에디터에 삽입합니다.
                                      htmlEditorController.insertHtml(
                                          '<img src="http://localhost:8080/api/file/img/${imageUrl}" width="35" height="35"/>');
                                      print(imageUrl);
                                      htmlEditorController
                                          .getText()
                                          .then((value) => print(value));
                                    }
                                  },
                                  child: Icon(Icons.image),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                  ),
                                )
                              ],
                              toolbarType: ToolbarType.nativeGrid,
                              // 툴바 옵션 설정
                              defaultToolbarButtons: [
                                StyleButtons(),
                                FontButtons(),
                                ColorButtons(),
                                ParagraphButtons(),
                                InsertButtons(
                                  picture: false,
                                ),
                                OtherButtons(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          //예 선택 시 실행 함수
                                          var user =
                                              context.read<TempUserProvider>();
                                          var result = await submit();
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          //아니오 선택 시 실행 함수
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(14.0),
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
                        margin: EdgeInsets.only(
                          bottom: 20.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 70.0,
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
                  ],
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
