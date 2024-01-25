import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:livedom_app/model/comment.dart';
import 'package:intl/intl.dart';

class CommentScreen extends StatefulWidget {
  final dynamic item;
  final String parentTable;

  CommentScreen({Key? key, required this.item, required this.parentTable})
      : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  // 유저 정보
  Map<String, String> user = {
    'writer': '테스트11',
    'username': '테스트11',
    'profileNo': '15',
  };

  late dynamic item;
  late String parentTable;
  int editingComment = 0;
  final ScrollController _controller = ScrollController();
  List<dynamic> items = [];
  int _page = 1;
  Map<String, dynamic> _pageObj = {'last': 10};

  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

  void commentInsert() {
    String inputValue = _commentController.text;

    print("입력값: $inputValue");
    insert(item.boardNo, parentTable, user['writer']!, inputValue,
        user['username']!, user['profileNo']!);

    _commentController.text = '';
  }

  @override
  void initState() {
    super.initState();
    item = widget.item;
    parentTable = widget.parentTable;
    fetch();

    _controller.addListener(() {
      if (_controller.position.maxScrollExtent < _controller.offset + 10) {
        fetch();
      }
    });
  }

  Future<void> insert(int parentNo, String parentTable, String writer,
      String content, String username, String profileNo) async {
    print('insert...');
    final url = Uri.parse('http://13.125.19.111/api/comment');
    final response = await http.post(url, body: {
      "parentNo": '$parentNo',
      "parentTable": parentTable,
      "writer": writer,
      "content": content,
      "username": username,
      "profileNo": profileNo
    });

    if (response.statusCode == 200) {
      setState(() {
        var utf8Decoded = utf8.decode(response.bodyBytes);
        var item = json.decode(utf8Decoded);

        Comment comment = Comment(
          commentNo: item['commentNo'],
          parentTable: item['parentTable'],
          parentNo: item['parentNo'],
          writer: item['writer'],
          username: item['username'],
          content: item['content'],
          regDate: item['regDate'],
          updDate: item['updDate'],
          profileNo: item['profileNo'],
        );
        items.insert(0, comment);
      });
    } else {
      // 요청이 실패함
      print('Insert failed');
    }
  }

  // 댓글 수정
  Future<void> updateComment(
      int commentNo, String content, String writer) async {
    print('댓글 수정${commentNo} ${content} ${writer}');
    final url = Uri.parse('http://13.125.19.111/api/comment');
    final response = await http.put(url, body: {
      "commentNo": '$commentNo',
      "writer": writer,
      "content": content,
    });

    if (response.statusCode == 200) {
      print('Update sucsess');
      setState(() {
        for (int i = 0; i < items.length; i++) {
          if (items[i].commentNo == commentNo) {
            // 찾았다면 해당 항목 업데이트
            setState(() {
              items[i] = Comment(
                commentNo: commentNo,
                parentTable: items[i].parentTable,
                parentNo: items[i].parentNo,
                writer: writer,
                username: items[i].username,
                content: content,
                regDate: items[i].regDate,
                updDate: items[i].updDate,
                profileNo: items[i].profileNo,
              );
            });
            break; // 업데이트가 완료되었으므로 루프 중단
          }
        }
      });
    } else {
      // 요청이 실패함
      print('Update failed');
    }
  }

// 댓글 삭제
  Future<void> deleteComment(int commentNo) async {
    print('댓글 삭제 $commentNo');
    final url = Uri.parse('http://13.125.19.111/api/comment/$commentNo');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Delete success');
      setState(() {
        // commentNo와 일치하는 항목을 찾아 제거
        items.removeWhere((comment) => comment.commentNo == commentNo);
      });
    } else {
      // 요청이 실패함
      print('Delete failed');
    }
  }

  Future fetch() async {
    print('fetch...');
    final url = Uri.parse(
        'http://13.125.19.111/api/comment?parentTable=${parentTable}&parentNo=${item.boardNo}&page=${_page}');
    print('comment fetch rul : ${url}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        var utf8Decoded = utf8.decode(response.bodyBytes);
        var result = json.decode(utf8Decoded);
        final page = result['page'];
        final List<dynamic> list = result['data'];
        print('page : $page');
        _pageObj = page;

        items.addAll(list.map<Comment>((item) {
          return Comment(
            commentNo: item['commentNo'],
            parentTable: item['parentTable'],
            parentNo: item['parentNo'],
            writer: item['writer'],
            username: item['username'],
            content: item['content'],
            regDate: item['regDate'],
            updDate: item['updDate'],
            profileNo: item['profileNo'],
          );
        }));
        _page++;
      });
    }
    print(items);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '관람후기',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '${_pageObj['total'] ?? 0}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: '관람 후기를 작성해보세요!',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(10.0)), // 모서리 둥글게
                      borderSide:
                          BorderSide(color: Colors.grey), // 연하게 설정한 테두리 색상
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.grey), // 포커스가 있을 때의 테두리 색상
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.grey), // 활성화되어 있을 때의 테두리 색상
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.red), // 에러 상태일 때의 테두리 색상
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          color: Colors.red), // 포커스가 있고 에러 상태일 때의 테두리 색상
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '값관람 후기를 입력하세요.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    commentInsert();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // 테두리 색상
                  foregroundColor: Colors.grey, // 글자 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // 버튼 모서리 둥글게 설정
                    side: BorderSide(color: Colors.grey), // 테두리 색상
                  ),
                ),
                child: Text('등록'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          itemBuilder: (context, index) {
            if (items.length == 0) {
              return Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: Column(
                  children: [SizedBox(height: 20), Text('조회된 관람 후기가 없습니다.')],
                ),
              );
            }
            if (index < items.length) {
              final item = items[index];
              return Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.content,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          item.writer,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                            DateFormat('yyyy/MM/dd HH:mm:ss')
                                .format(DateTime.parse(item.updDate)),
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(
                          width: 40,
                        ),
                      ],
                    ),
                    (user['writer'] == item.writer &&
                            editingComment != item.commentNo)
                        ? Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // 수정 버튼 클릭 시 Bottom Sheet 표시 및 수정 기능 구현
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true, // 스크롤 가능하도록 설정
                                    builder: (context) {
                                      String updatedContent = item.content;
                                      return SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(25),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('댓글 수정',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(height: 20),
                                                TextFormField(
                                                  initialValue: item.content,
                                                  onChanged: (value) {
                                                    updatedContent = value;
                                                  },
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      style:
                                                          TextButton.styleFrom(
                                                        fixedSize: Size(80, 40),
                                                        backgroundColor:
                                                            Colors.grey,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                      child: Text('취소'),
                                                    ),
                                                    SizedBox(width: 8),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        // 댓글 수정 처리
                                                        updateComment(
                                                            item.commentNo,
                                                            updatedContent,
                                                            item.writer);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        fixedSize: Size(80, 40),
                                                        backgroundColor:
                                                            Colors.grey,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                      child: Text('수정'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: Text('수정'),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  // 삭제 버튼 클릭 시 처리
                                  deleteComment(item.commentNo);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white, // 테두리 색상
                                  foregroundColor: Colors.grey, // 글자 색상
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // 버튼 모서리 둥글게 설정
                                    side: BorderSide(
                                        color: Colors.grey), // 테두리 색상
                                  ),
                                ),
                                child: Text('삭제'),
                              ),
                            ],
                          )
                        : Text(''),
                    (!(_pageObj['total'] == (index + 1)))
                        ? Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            height: 40.0,
                          )
                        : Text('')
                  ],
                ),
              );
            } else if ((_page - 1) > 0 && (_page - 1) < _pageObj['last']!) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          itemCount: items.length + 1,
        ),
      ],
    );
  }
}
