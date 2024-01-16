import 'package:flutter/material.dart';
import 'package:livedom_app/model/liveboard.dart';
import 'dart:ui';

class LiveBoardReadScreen extends StatefulWidget {

  @override
  State<LiveBoardReadScreen> createState() => _LiveBoardReadScreenState();
}

class _LiveBoardReadScreenState extends State<LiveBoardReadScreen> {
  @override
  Widget build(BuildContext context) {
     // arguments를 통해 데이터를 받아옴
    final LiveBoard item = ModalRoute.of(context)!.settings.arguments as LiveBoard;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Image.network(
                      'http://10.0.2.2:8080/api/file/img/${item.thumbnail}',
                      width: 130,
                      height: 190,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.6), // 어두운 효과 적용
                      colorBlendMode: BlendMode.darken, // 어두운 효과의 블렌드 모드 설정
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 30,
                  child: Row(
                            children: [
                              Image.network(
                                'http://10.0.2.2:8080/api/file/img/${item.thumbnail}',
                                width: 130,
                                height: 190,
                                fit: BoxFit.cover,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        item.soldOut == 0
                                            ? Container(
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                child: Text(
                                                  '판매중',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Color.fromARGB(255, 221, 221, 221)),
                                                ),
                                              )
                                            : Container(
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  border: Border.all(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                child: Text(
                                                  '매진',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                        Text(
                                          item.title ?? '',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 255, 255, 255),
                                            fontSize: 20.0,
                                          ),
                                          overflow: TextOverflow.ellipsis,  // 글자가 넘칠 경우 밑줄로 처리
                                          maxLines: 2,  // 표시할 최대 줄 수
                                        ),
                                        Text(
                                          item.crew ?? '',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 255, 255, 255),
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        Text(
                                          item.address ?? '',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: const Color.fromARGB(255, 255, 255, 255),
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '잔여 티켓 ${item.ticketLeft}장' ?? '',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              item.liveDate ?? '',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              item.liveTime ?? '',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                ),
                SafeArea(
                  top: true,
                  child: AppBar(
                    title: const Text(
                      '공연 정보',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop(); // 뒤로가기 기능
                        },
                        color: Colors.white, // 뒤로가기 버튼 색상
                      ),
                      actions: [
                        // 햄버거 버튼 추가
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            // 햄버거 버튼 눌렀을 때 수행할 동작 추가
                          },
                          color: Colors.white, // 햄버거 버튼 색상
                        ),
                      ],
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(
          Icons.edit,
          color: Colors.white, // 아이콘 색상을 흰색으로 설정
        ),
        backgroundColor: Colors.black, // 배경색을 검은색으로 설정
        shape: CircleBorder(), // 원형으로 설정
      )
    );
  }
}