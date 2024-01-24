import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:livedom_app/provider/temp_user_provider.dart';
import 'package:provider/provider.dart';

class TeamReadAppScreen extends StatefulWidget {
  const TeamReadAppScreen({super.key});

  @override
  State<TeamReadAppScreen> createState() => _TeamReadAppScreenState();
}

class _TeamReadAppScreenState extends State<TeamReadAppScreen> {
  HtmlEditorController htmlEditorController = HtmlEditorController();
  final TextEditingController _titleController =
      TextEditingController(text: '');
  final TextEditingController _bandnameController =
      TextEditingController(text: '');
  final TextEditingController _contentController =
      TextEditingController(text: '');

  Future<String> submit(teamNo, user) async {
    final String url = 'http://10.0.2.2:8080/api/team/app';
    final parsedUrl = Uri.parse(url);
    final header = {'Content-Type': 'application/json'};
    final data = {
      'teamNo': teamNo,
      'title': _titleController.text,
      'phone': user.userInfo['phone'],
      'username': user.userInfo['username'],
      'bandName': _bandnameController.text,
      'content': await htmlEditorController.getText(),
    };
    final jsonData = json.encode(data);
    print(jsonData);

    final result = await http.post(
      parsedUrl,
      headers: header,
      body: jsonData,
    );
    if (result.statusCode == 200) {
      return 'done';
    } else {
      return 'dont';
    }
  }

  Future<String> uploadImageToServer(File image) async {
    try {
      var parsedUrl = Uri.parse('http://10.0.2.2:8080/api/file/upload');
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

  @override
  Widget build(BuildContext context) {
    final Map _teamAppData = ModalRoute.of(context)?.settings.arguments as Map;

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
                '팀 참가 신청서 작성',
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
                              '밴드이름',
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
                              controller: _bandnameController,
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
                          HtmlEditor(
                            controller: htmlEditorController, // HTML 에디터 컨트롤러
                            htmlEditorOptions: HtmlEditorOptions(
                              hint: 'Your text here...', // 에디터에 표시될 힌트
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
                              '작성한 신청서를 제출하시겠습니까?',
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
                                      var result = await submit(
                                          _teamAppData['teamNo'], user);
                                      if (result == 'done') {
                                        print('등록완료');
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
                  '신청완료',
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
