import 'package:flutter/material.dart';

class TempStateScreen extends StatefulWidget {
  const TempStateScreen({super.key});

  @override
  State<TempStateScreen> createState() => _TempStateScreenState();
}

class _TempStateScreenState extends State<TempStateScreen> {
  double _offsetX = 0.0; // 컨테이너의 X 좌표 오프셋

  void _handleDrag(DragUpdateDetails details) {
    setState(() {
      // 오른쪽으로만 이동하도록 X 좌표를 업데이트
      _offsetX += details.delta.dx;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_offsetX >= 100.0) {
      // 오른쪽으로 100px 이상 이동한 경우
      setState(() {
        _offsetX = 0.0; // 원래 위치로 돌아오기 위해 X 좌표를 초기화
      });

      // 원래 위치로 돌아온 후 실행할 함수 호출
      executeFunction();
    }
  }

  void executeFunction() {
    // 함수 실행 로직 작성
    print('함수를 실행합니다.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Screen'),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: _handleDrag,
        onHorizontalDragEnd: _handleDragEnd,
        child: Container(
          margin: EdgeInsets.only(left: _offsetX), // X 좌표 오프셋을 적용하여 오른쪽으로 이동
          color: Colors.blue,
          child: Center(
            child: Text(
              '드래그하여 오른쪽으로 100px 이동',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ),
      ),
    );
  }
}
