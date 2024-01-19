import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:livedom_app/model/ticket.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? able = '';
  Ticket? ticket;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '티켓 QR 스캔',
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
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
            ),
            width: 380,
            height: 370,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Expanded(
                flex: 4,
                child: _buildQrView(context),
              ),
            ),
          ),
          
          Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (result != null)
                    showButton()
                else
                  Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[800],
                      ),
                      SizedBox(height: 10,),
                      const Text(
                        '티켓 QR코드를 스캔해주세요.',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ],
      ),
      )
    );
  }

  Future<String?> useTicket() async {
    print('티켓사용 티켓 번호 : ${ticket!.ticketNo}');
    final url =
        Uri.parse('http://10.0.2.2:8080/api/qr/use?ticketNo=${ticket!.ticketNo}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var result = utf8.decode(response.bodyBytes);
      setState(() {
        print('result');
        if (result == 'SUCCESS') {
          able = '티켓을 사용하였습니다';
        } else {
          able = '티켓 사용에 실패하였습니다.';
        }
      });

      return result;
    }
  }
    Widget showButton() {
    if(ticket?.refund == 0){
      return Column(
        children: [
          SizedBox(height: 20,),
          Icon(
            Icons.info_outline,
            color: Colors.blue,
          ),
          SizedBox(height: 10,),
          const Text(
            '이용 가능한 티켓입니다',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '공연명',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '예매자명',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${ticket?.title}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    '${ticket?.name}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20,),
          Container(
            width: 280,
            height: 40,
            child: ElevatedButton(
              onPressed: () async {
                print('ElevatedButton이 클릭되었습니다.');
                String? res = await useTicket();
                if (res == 'SUCCESS') {
                  _showModal('success');
                } else {
                  _showModal('fail');
                }

                // result를 null로 업데이트
                setState(() {
                  result = null;
                });
              },
              child: Text(
                '티켓 사용',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // 배경색 설정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          )
        ],
      ); 
    }else if(ticket?.refund == 1){
      return Column(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.red,
          ),
          SizedBox(height: 10,),
          const Text(
            '환불 처리된 티켓입니다',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '공연명',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '예매자명',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${ticket?.title}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    '${ticket?.name}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              )
            ],
          )
        ],
      ); 
    }else{
      return Column(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.red,
          ),
          SizedBox(height: 10,),
          const Text(
            '이미 사용한 티켓입니다',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '공연명',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '예매자명',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${ticket?.title}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    '${ticket?.name}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              )
            ],
          )
        ],
      );
    }
  }

  Future fetch(String data) async {
    print('fetch...');
    final url = Uri.parse('http://10.0.2.2:8080/api$data');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        var utf8Decoded = utf8.decode(response.bodyBytes);
        var result = json.decode(utf8Decoded);
        final item = result['ticket'];
        final res = result['able'];
        ticket = Ticket(
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
        print('result');
        if (res == 'available') {
          able = '이용가능한 티켓 입니다';
        } else if( res == 'used') {
          able = '이미 사용한 티켓입니다';
        } else{
          able = '환불 처리된 티켓입니다';
        }
      });
      print(able);
      print("${ticket}");
    }
  }


  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 400.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.black,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        print(scanData.code);
      });
      fetch(result!.code ?? '');
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void _showModal(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 60.0),
          content: 
          ( message == 'success')?
         Column(
          mainAxisSize: MainAxisSize.min, // 세로 크기 최소화
          children: [
            // 큰 아이콘
            Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.blue, // 파란색
              size: 50.0, // 아이콘 크기 조절
            ),
            SizedBox(height: 10,),
            // 텍스트
            Text(
              '티켓 사용 성공',
              style: TextStyle(fontSize: 20.0), // 텍스트 크기 조절
            ),
          ],
        ):Column(
          children: [
            // 큰 아이콘
            Icon(
              Icons.close,
              color: Colors.red, // 파란색
              size: 50.0, // 아이콘 크기 조절
            ),
            SizedBox(height: 10,),
            // 텍스트
            Text(
              '티켓 사용 실패',
              style: TextStyle(fontSize: 20.0), // 텍스트 크기 조절
            ),
          ],
        )
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
