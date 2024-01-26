import 'dart:convert';
import 'dart:io';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:livedom_app/model/liveboard.dart';
import 'package:livedom_app/model/rental.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/auth_provider.dart';
import 'package:livedom_app/provider/nav_provider.dart';
import 'package:livedom_app/provider/temp_user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_parsing/path_parsing.dart';

class LiveBoardUpdateScreen extends StatefulWidget {
  const LiveBoardUpdateScreen({super.key});

  @override
  State<LiveBoardUpdateScreen> createState() => _LiveBoardUpdateScreenState();
}

class _LiveBoardUpdateScreenState extends State<LiveBoardUpdateScreen> {
  HtmlEditorController htmlEditorController = HtmlEditorController();
  final TextEditingController _titleController =
      TextEditingController(text: '');
  String _capacity = '1';
  final TextEditingController _dateController = TextEditingController(
      text: DateFormat('yyyy/MM/dd').format(DateTime.now()));

  final TextEditingController _stTimeController =
      TextEditingController(text: '');
  final TextEditingController _endTimeController =
      TextEditingController(text: '');

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
  final TextEditingController _crewController = TextEditingController(text: '');
  final TextEditingController _maxTicketsController =
      TextEditingController(text: '');

  File? _image;
  String? _imageUrl;
  int _navIndex = 2;
  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImageToServer(File image) async {
    try {
      var parsedUrl = Uri.parse('http://13.209.77.161/api/file/upload');
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

  Future<String> submit(boardNo) async {
    print('submit함수 진입');
    final url = 'http://13.209.77.161/api/liveBoard/update';
    final parsedUrl = Uri.parse(url);
    final multiReq = http.MultipartRequest('PUT', parsedUrl);

    //이미지 컨트롤러 추가
    if (_image != null) {
      multiReq.files.add(
        await http.MultipartFile.fromPath('file', _image!.path),
      );
    }
    multiReq.fields['title'] = _titleController.text;
    multiReq.fields['writer'] = userInfo.nickname!;
    multiReq.fields['username'] = userInfo.username!;
    multiReq.fields['content'] = await htmlEditorController.getText();
    multiReq.fields['crew'] = _crewController.text;
    multiReq.fields['location'] = _location;
    multiReq.fields['address'] = _addressController.text;
    multiReq.fields['liveDate'] = _dateController.text;
    multiReq.fields['liveTime'] =
        '${_stTimeController.text} ~ ${_endTimeController.text}';
    multiReq.fields['price'] = _priceController.text;
    multiReq.fields['maxTickets'] = _maxTicketsController.text;
    multiReq.fields['boardNo'] = boardNo.toString();
    print('submit함수 요청 직전');
    try {
      var result = await multiReq.send();
      print('submit함수 요청 직후');
      if (result.statusCode == 200) {
        return 'done';
      } else {
        return 'dont';
      }
    } catch (e) {
      print(e);
      return 'dont';
    }
  }

  //로그인 상태
  bool _loginState = false;

  //회원 정보
  Users userInfo = Users();

  @override
  void initState() {
    super.initState();
    //초기 세팅을 해줍시다.
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      int tempIndex = Provider.of<NavProvider>(context, listen: false).navIndex;
      bool tempLoginState =
          Provider.of<AuthProvider>(context, listen: false).isLogin;
      final Rental rental =
          ModalRoute.of(context)?.settings.arguments as Rental;
      setState(() {
        _loginState = tempLoginState;
        if (_loginState) {
          Users tempUserInfo =
              Provider.of<AuthProvider>(context, listen: false).currentUser!;
          userInfo = tempUserInfo;
        } else {
          Provider.of<NavProvider>(context, listen: false).navIndex = 2;
          Navigator.pushReplacementNamed(context, '/main');
        }
      });
      final LiveBoard liveboard =
          ModalRoute.of(context)?.settings.arguments as LiveBoard;
      // rental 데이터를 처리합니다.
      setState(() {
        _navIndex = tempIndex;
        _titleController.text = liveboard.title!;
        _crewController.text = liveboard.crew!;
        _dateController.text = liveboard.liveDate!;
        _stTimeController.text = liveboard.liveTime!.split(' ~ ')[0];
        _endTimeController.text = liveboard.liveTime!.split(' ~ ')[1];
        _location = liveboard.location!;
        _addressController.text = liveboard.address!;
        _priceController.text = '${liveboard.price}';
        _contentController.text = liveboard.content!;
        _maxTicketsController.text = liveboard.maxTickets!.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final LiveBoard liveboard =
        ModalRoute.of(context)?.settings.arguments as LiveBoard;
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
                    '공연 게시글 수정',
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
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '공연진',
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
                              controller: _crewController,
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
                        //여기 모팀수
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
                                      _location = newValue!;
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
                                        initialTime: TimeOfDay.now());
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
                              '티켓 가격',
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
                              '수용 인원',
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
                              controller: _maxTicketsController,
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '썸네일',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _image == null
                            ? Image.network(
                                'http://13.209.77.161/api/file/${liveboard.thumbnail}?${DateTime.now().microsecondsSinceEpoch.toString()}',
                                width: 200.0,
                                height: 280.0,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                _image!,
                                width: 200.0,
                                height: 280.0,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                        ElevatedButton(
                          onPressed: _getImage,
                          child: Text('갤러리에서 이미지 선택'),
                        ),
                        if (_imageUrl != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('이미지 URL: $_imageUrl'),
                          ),
                      ],
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
                          HtmlEditor(
                            controller: htmlEditorController, // HTML 에디터 컨트롤러
                            htmlEditorOptions: HtmlEditorOptions(
                              hint: 'Your text here...', // 에디터에 표시될 힌트
                              initialText: _contentController.text,
                            ),
                            otherOptions: OtherOptions(
                              height: 400, // 에디터의 높이 설정
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
                      height: 50.0,
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
                                      '공연 게시글 수정을 완료하시겠습니까?',
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
                                          var result =
                                              await submit(liveboard.boardNo);
                                          if (result == 'done') {
                                            print('등록완료');
                                            liveboard.title =
                                                _titleController.text;
                                            liveboard.crew =
                                                _crewController.text;
                                            liveboard.location = _location;
                                            liveboard.liveDate =
                                                _dateController.text;
                                            liveboard.liveTime =
                                                '${_stTimeController.text} ~ ${_endTimeController.text}';
                                            liveboard.address =
                                                _addressController.text;
                                            liveboard.price = int.parse(
                                                _priceController.text);
                                            liveboard.maxTickets = int.parse(
                                                _maxTicketsController.text);
                                            var response = await http.get(Uri.parse(
                                                'http://13.209.77.161/api/liveBoard/${liveboard.boardNo}'));
                                            var parsedResponse = json.decode(
                                                utf8.decode(
                                                    response.bodyBytes));
                                            liveboard.thumbnail =
                                                parsedResponse['thumbnail']
                                                    ['fileNo'];
                                            liveboard.content =
                                                _titleController.text;
                                            liveboard.isCaching = true;
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/liveboard/read',
                                              arguments: liveboard,
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
                          bottom: 50.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '수정완료',
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
    );
  }
}
