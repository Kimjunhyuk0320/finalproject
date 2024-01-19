import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  String able = '';

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
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
            Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        '${able}',
                        style: TextStyle(fontSize: 30),
                      )
                  else
                    const Text('티켓 QR을 스캔해주세요',
                      style: TextStyle(fontSize: 30),
                    ),
                  
                ],
              ),
            ),
        ],
      ),
    );
  }
  Future fetch( String data) async {
    print('fetch...');
    final url = Uri.parse('http://10.0.2.2:8080/api$data');
    final response = await http.get(url);
     if( response.statusCode == 200 ) {
      setState(() {
        // JSON 문자열 ➡ List<>
        var result = utf8.decode( response.bodyBytes );
        print('result');
          if(result == 'available'){
            able = '이용가능한 티켓 입니다';
          }else{
            able = '이미 사용한 티켓입니다';
          }
        }
      );
        print(able);
    }
  }
  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}