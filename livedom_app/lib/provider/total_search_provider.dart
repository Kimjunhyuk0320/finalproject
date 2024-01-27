import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:livedom_app/model/liveboard.dart';
import 'package:livedom_app/model/rental.dart';

class TotalSearchProvider with ChangeNotifier {
  List<dynamic> _liveBoardList = [];
  List<dynamic> _frList = [];
  List _teamList = [];

  // getter
  // get : getter 메소드를 정의하는 키워드
  List<dynamic> get liveBoardList => _liveBoardList;
  List<dynamic> get frList => _frList;
  List<dynamic> get teamList => _teamList;

  Future<void> getTotalSearch(String keyword) async {
    print("01. getTotalSearch에 들어왔습니다.");
    try {
      print("02. getTotalSearch 함수의 매개변수 : $keyword");
      var url =
          Uri.parse('http://13.209.77.161/api/home/totalSearch?page=1&searchType=0&keyword=$keyword');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var utf8Decoded = utf8.decode(response.bodyBytes);
        var result = json.decode(utf8Decoded);

        final List<dynamic> liveBoardListData = result['liveBoardList'];
        _liveBoardList = liveBoardListData.map((item) {
          return LiveBoard(
            boardNo: item['boardNo'],
            title: item['title'],
            writer: item['writer'],
            username: item['username'],
            content: item['content'],
            crew: item['crew'],
            price: item['price'],
            liveDate: item['liveDate'],
            liveTime: item['liveTime'],
            location: item['location'],
            address: item['address'],
            maxTickets: item['maxTickets'],
            updDate: item['updDate'],
            soldOut: item['soldOut'], // 수정 부분
            thumbnail:
                item['thumbnail'] == null ? 0 : item['thumbnail']['fileNo'],
            ticketLeft: item['ticketLeft'],
            isCaching: false,
          );
        }).toList();

        final List<dynamic> frListData = result['frList'];
        _frList = frListData.map((item) {
          return Rental (
            boardNo: item['frNo'],
            title: item['title'],
            writer: item['writer'],
            username: item['username'],
            content: item['content'],
            price: item['price'],
            location: item['location'],
            address: item['address'],
            liveDate: item['liveDate'],
            updDate: item['updDate'],
            phone: item['phone'],
            account: item['account'],
            views: item['views'],
            confirmed: item['confirmed'],
            thumbnail:
                item['thumbnail'] == null ? 0 : item['thumbnail']['fileNo'],
            isCaching: false,
          );
        }).toList();

        final List teamListData =result['teamList'];
        _teamList.clear();
        _teamList.addAll(teamListData);



        print('liveBoardList: $_liveBoardList');
        print('frList: $_frList');
        print('teamList: $_teamList');
      }
    } catch (error) {
      print("Error fetching data: $error");
      // 에러 처리 로직 추가
    }
    // 공유된 상태를 가진 위젯 다시 빌드
    notifyListeners();
  }
}
