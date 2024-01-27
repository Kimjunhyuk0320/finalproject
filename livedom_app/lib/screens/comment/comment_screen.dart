import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:livedom_app/model/comment.dart';
import 'package:intl/intl.dart';
import 'package:livedom_app/model/users.dart';
import 'package:livedom_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final dynamic item;
  final String parentTable;

  CommentScreen({Key? key, required this.item, required this.parentTable})
      : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
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

    //**로그인 데이터의 프로필 사진을 가져오는 기능이 필요합니다!!**
    insert(item.boardNo, parentTable, userInfo.nickname!, inputValue,
        userInfo.username!, '0');

    _commentController.text = '';
  }

//로그인 상태
  bool _loginState = false;

  //회원 정보
  Users userInfo = Users();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      bool tempLoginState =
          Provider.of<AuthProvider>(context, listen: false).isLogin;
      setState(() {
        _loginState = tempLoginState;
      });
      Users tempUserInfo =
          Provider.of<AuthProvider>(context, listen: false).currentUser!;
      setState(() {
        userInfo = tempUserInfo;
      });
      item = widget.item;
      parentTable = widget.parentTable;
      fetch();

      _controller.addListener(() {
        if (_controller.position.maxScrollExtent < _controller.offset + 10) {
          fetch();
        }
      });
    });
  }

  Future<void> insert(int parentNo, String parentTable, String writer,
      String content, String username, String profileNo) async {
    print('insert...');
    final url = Uri.parse('http://13.209.77.161/api/comment');
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
    final url = Uri.parse('http://13.209.77.161/api/comment');
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
    final url = Uri.parse('http://13.209.77.161/api/comment/$commentNo');
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
        'http://13.209.77.161/api/comment?parentTable=${parentTable}&parentNo=${item.boardNo}&page=${_page}');
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 50, // 원하는 높이 설정
                        child: TextFormField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            labelText: '관람 후기 입력',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10.0),
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
                      Positioned(
                        top: 8,
                        bottom: 8,
                        right: 8,
                        child: Padding(
                          padding: EdgeInsets.all(0), // 패딩 추가
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                commentInsert();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent, // 버튼 배경 투명으로 설정
                              shadowColor: Colors.transparent, // 그림자 효과 제거
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Icon(Icons.send,
                                color: Colors.blue[700]), // 아이콘 색상 지정
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
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
                  fontSize: 15,
                  color: Colors.red,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            itemBuilder: (context, index) {
              if (items.length == 0) {
                return Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Column(
                    children: [SizedBox(height: 20), Text('조회된 관람 후기가 없습니다.')],
                  ),
                );
              }
              if (index < items.length) {
                final item = items[index];
                return Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.content,
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis, // 넘치면 ...으로 표시
                              maxLines: 2, // 최대 2줄로 제한
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(Icons.menu),
                          //   onPressed: () {
                          //     // 햄버거 아이콘이 눌렸을 때 실행할 동작
                          //   },
                          // ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.writer,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            timeAgo(DateTime.parse(item.updDate)),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      (userInfo.nickname == item.writer &&
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
                                                            color:
                                                                Colors.black),
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
                                                        style: TextButton
                                                            .styleFrom(
                                                          fixedSize:
                                                              Size(80, 40),
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
                                                          fixedSize:
                                                              Size(80, 40),
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
      ),
    );
  }
}

// 댓글에서 얼마나 지났는지 알려주는 함수
String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 8) {
    return DateFormat('yyyy/MM/dd HH:mm:ss').format(dateTime);
  } else if (difference.inDays >= 1) {
    return '${difference.inDays}일 전';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours}시간 전';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes}분 전';
  } else {
    return '방금 전';
  }
}
