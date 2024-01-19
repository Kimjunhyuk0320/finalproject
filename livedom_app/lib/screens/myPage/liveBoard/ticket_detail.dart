import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:livedom_app/model/ticket.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class TicketDetail extends StatefulWidget {
  const TicketDetail({Key? key}) : super(key: key);

  @override
  State<TicketDetail> createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  final Dio _dio = Dio(); // Dio 인스턴스 생성
  // 서버에서 이미지를 불러오는 함수
  Future<Uint8List> loadImage(String imageUrl) async {
    try {
      // Dio를 사용하여 이미지를 가져옴
      final Response<List<int>> response = await _dio.get<List<int>>(imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // 가져온 이미지 데이터를 Uint8List로 변환하여 반환
      return Uint8List.fromList(response.data!);
    } catch (e) {
      // 에러가 발생하면 Exception을 throw
      throw Exception('Error loading image: $e');
    }
  }
  // 가격 변환
  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  // 줄바꿈
  String formatMultilineText(String text) {
    final int maxLineLength = 15; // 원하는 최대 길이 설정
    final List<String> words = text.split(' ');

    String result = '';
    String line = '';
    for (String word in words) {
      if ((line + ' ' + word).length <= maxLineLength) {
        line += (line.isNotEmpty ? ' ' : '') + word;
      } else {
        result += (result.isNotEmpty ? '\n' : '') + line;
        line = word;
      }
    }

    if (line.isNotEmpty) {
      result += (result.isNotEmpty ? '\n' : '') + line;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final Ticket item = ModalRoute.of(context)!.settings.arguments as Ticket;

    return  Scaffold(
      appBar: AppBar(
        title: const Text(
          '티켓 정보',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              formatMultilineText(item.title ?? ''),
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
            FutureBuilder(
              future: loadImage('http://10.0.2.2:8080/api/qr/img?qrNo=${item.qrNo}'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 로딩 중이라면 반짝이는 스켈레톤 UI 표시
                  return Shimmer.fromColors(
                    baseColor: Color.fromARGB(255, 238, 238, 238),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 250,
                      height: 250,
                      color: Colors.white,
                    ),
                  );
                } else if (snapshot.hasError) {
                  // 에러가 있다면 에러 메시지 표시
                  return Shimmer.fromColors(
                    baseColor: Color.fromARGB(255, 238, 238, 238),
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 250,
                      height: 250,
                      color: Colors.white,
                    ),
                  );
                } else {
                  // 이미지 로딩이 완료되면 표시
                  return Image.memory(snapshot.data as Uint8List, width: 250, height: 250, fit: BoxFit.contain);
                }
              },
            ),
            SizedBox(height: 10,),
            Text(
              '${item.reservationNo}',
                style: TextStyle(
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold
                ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50,),
            Text(
              '${item.name}(${item.phone})',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              '공연일자 ${item.liveDate} ${item.liveTime}',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            Text(
              '장소   ${formatMultilineText('${item.location} ${item.address}')}',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            Text(
              '${formatCurrency(item.price ?? 0)}원',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),

    );
  }
}
