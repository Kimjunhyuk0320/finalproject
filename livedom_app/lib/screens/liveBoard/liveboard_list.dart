import 'package:flutter/material.dart';

class LiveBoardListScreen extends StatefulWidget {
  const LiveBoardListScreen({super.key});

  @override
  State<LiveBoardListScreen> createState() => _LiveBoardListScreenState();
}

class _LiveBoardListScreenState extends State<LiveBoardListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공연 티켓 판매'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: Text("home"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
              ),
              elevation: 5
            ),
            onPressed: () async {
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
        ],
      ),
    );
  }
}