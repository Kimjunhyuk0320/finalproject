import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:livedom_app/model/ticket.dart';

class BuyTicketListScreen extends StatefulWidget {
  const BuyTicketListScreen({Key? key}) : super(key: key);

  @override
  State<BuyTicketListScreen> createState() => _BuyTicketListScreenState();
}

class _BuyTicketListScreenState extends State<BuyTicketListScreen> {
  int selectedIndex = 0;
  // 유저 정보
    Map<String, String> user = {
    'writer' : '테스트11',
    'username' : '테스트11',
    'profileNo' : '15',
    'phone' : '01040115135',
  };
  // 티켓 리스트
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future fetch() async {
    print('fetch...');
    final url = Uri.parse('http://10.0.2.2:8080/api/user/listByPhone?phone=${user['phone']}');
    final response = await http.get(url);
     if( response.statusCode == 200 ) {
      setState(() {
        // JSON 문자열 ➡ List<>
        var utf8Decoded = utf8.decode( response.bodyBytes );
        var result = json.decode(utf8Decoded);
        final List<dynamic> list = result;

        items.addAll(list.map<Ticket>((item) {
          return Ticket(
            ticketNo: item['ticketNo'],
            reservationNo: item['reservationNo'],
            title: item['title'],
            boardNo: item['boardNo'],
            thumbnail: item['thumbnail'],
            name: item['name'],
            phone: item['phone'],
            liveDate: item['liveDate'],
            liveTime: item['liveTime'],
            price: item['price'],       
            location: item['location'],
            address: item['address'],
            updDate: item['updDate'],
            refund: item['refund'],
            qrNo: item['qrNo'],
          );
        }));
      });
      print(items);
    }
  }

  // 말 줄이기 함수
  String truncateText(String text, int length) {
    if (text.length <= length) {
      return text;
    } else {
      return '${text.substring(0, length)}...';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '티켓 구매 내역',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop(); // 뒤로가기 기능
          },
          color: Colors.black, // 뒤로가기 버튼 색상
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // 이미지
              Container(
                width: double.infinity,
                height: 100,
                child: Image.asset(
                  'images/sample.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20,),
              // 탭바 
              Padding(
              padding: EdgeInsets.symmetric(horizontal: 13),
              child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey, // 테두리 색상 설정
                    width: 1.0, // 테두리 두께 설정
                  ),
                ),
              ),
              child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedIndex == 0 ? Colors.black : Colors.transparent,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      '전체',
                      style: TextStyle(
                        color: selectedIndex == 0 ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedIndex == 1 ? Colors.black : Colors.transparent,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      '예매완료',
                      style: TextStyle(
                        color: selectedIndex == 1 ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedIndex == 2 ? Colors.black : Colors.transparent,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      '예매취소',
                      style: TextStyle(
                        color: selectedIndex == 2 ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ),
            ),
            // 탭바 뷰
            Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Visibility(
                  visible: selectedIndex == 0, // 인덱스에 따라 화면 보이기/숨기기
                  child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            
                              return Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // 터치 이벤트 핸들링
                                        Navigator.pushNamed(
                                          context, 
                                          "/mypage/ticketList/detail",
                                          arguments: item,
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Image.network(
                                            'http://10.0.2.2:8080/api/file/img/${item.thumbnail}',
                                            width: 100,
                                            height: 160,
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
                                                    
                                                    Text(
                                                      truncateText(item.title, 15), // 최대 길이를 설정 (예: 20)
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      truncateText(item.reservationNo, 17),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      '예매자명 : ${truncateText(item.name, 17)}',
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    SizedBox(
                                                      height: 30.0,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          truncateText(item.liveDate, 17),
                                                          style: TextStyle(color: Colors.grey),
                                                        ),
                                                        Text(
                                                          (() {
                                                            switch (item.refund) {
                                                              case 0:
                                                                return '예매완료';
                                                              case 1:
                                                                return '환불완료';
                                                              case 2:
                                                                return '이용완료';
                                                              default:
                                                                return '예매완료';
                                                            }
                                                          })(),
                                                          style: TextStyle(color: Colors.grey),
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

                                    Divider(
                                      color: Colors.grey, // 원하는 색상으로 변경
                                      thickness: 0.5, // 원하는 두께로 변경
                                      height: 40.0, // 위아래 여백 조절
                                    ),
                                  ],
                                ),
                              );
                          },
                          itemCount: items.length,
                        ),
                ),
                Visibility(
                  visible: selectedIndex == 1, // 인덱스에 따라 화면 보이기/숨기기
                  child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            if( item.refund != 1 ){
                              return Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // 터치 이벤트 핸들링
                                        Navigator.pushNamed(
                                          context, 
                                          "/mypage/ticketList/detail",
                                          arguments: item,
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Image.network(
                                            'http://10.0.2.2:8080/api/file/img/${item.thumbnail}',
                                            width: 100,
                                            height: 160,
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
                                                    
                                                    Text(
                                                      truncateText(item.title, 15), // 최대 길이를 설정 (예: 20)
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      truncateText(item.reservationNo, 17),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      '예매자명 : ${truncateText(item.name, 17)}',
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    SizedBox(
                                                      height: 30.0,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          truncateText(item.liveDate, 17),
                                                          style: TextStyle(color: Colors.grey),
                                                        ),
                                                        Text(
                                                          (() {
                                                            switch (item.refund) {
                                                              case 0:
                                                                return '예매완료';
                                                              case 1:
                                                                return '환불완료';
                                                              case 2:
                                                                return '이용완료';
                                                              default:
                                                                return '예매완료';
                                                            }
                                                          })(),
                                                          style: TextStyle(color: Colors.grey),
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

                                    Divider(
                                      color: Colors.grey, // 원하는 색상으로 변경
                                      thickness: 0.5, // 원하는 두께로 변경
                                      height: 40.0, // 위아래 여백 조절
                                    ),
                                  ],
                                ),
                              );
                            }
                            else {return SizedBox(width: 0, height: 0,);}
                            
                          },
                          itemCount: items.length,
                        ),
                ),
                Visibility(
                  visible: selectedIndex == 2, // 인덱스에 따라 화면 보이기/숨기기
                  child:  ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            if(item.refund == 1){
                              return Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // 터치 이벤트 핸들링
                                        Navigator.pushNamed(
                                          context, 
                                          "/mypage/ticketList/detail",
                                          arguments: item,
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Image.network(
                                            'http://10.0.2.2:8080/api/file/img/${item.thumbnail}',
                                            width: 100,
                                            height: 160,
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
                                                    
                                                    Text(
                                                      truncateText(item.title, 15), // 최대 길이를 설정 (예: 20)
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      truncateText(item.reservationNo, 17),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      '예매자명 : ${truncateText(item.name, 17)}',
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    SizedBox(
                                                      height: 30.0,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          truncateText(item.liveDate, 17),
                                                          style: TextStyle(color: Colors.grey),
                                                        ),
                                                        Text(
                                                          (() {
                                                            switch (item.refund) {
                                                              case 0:
                                                                return '예매완료';
                                                              case 1:
                                                                return '환불완료';
                                                              case 2:
                                                                return '이용완료';
                                                              default:
                                                                return '예매완료';
                                                            }
                                                          })(),
                                                          style: TextStyle(color: Colors.grey),
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

                                    Divider(
                                      color: Colors.grey, // 원하는 색상으로 변경
                                      thickness: 0.5, // 원하는 두께로 변경
                                      height: 40.0, // 위아래 여백 조절
                                    ),
                                  ],
                                ),
                              );
                            }else{
                              return SizedBox();
                            }
                          },
                          itemCount: items.where((item) => item.refund == 1).length,
                        ),
                ),
              ],
            ),
          ),
            ],
          ),
        ),
      )
    );
  }
}
