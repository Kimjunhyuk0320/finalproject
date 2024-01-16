import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livedom_app/provider/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('라우팅 페이지'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text("로그인"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  elevation: 5
                ),
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, "/login");
                },
              ),
              ElevatedButton(
                child: Text("공연"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  elevation: 5
                ),
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, "/liveboard");
                },
              ),
              ElevatedButton(
                child: Text("대관"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  elevation: 5
                ),
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, "/rental");
                },
              ),
              ElevatedButton(
                child: Text("팀 모집"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  elevation: 5
                ),
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, "/team");
                },
              ),
              ElevatedButton(
                child: Text("마이페이지"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  elevation: 5
                ),
                onPressed: () async {
                  Navigator.pushReplacementNamed(context, "/mypage");
                },
              ),
            ],
          )
        ),
      ),
    );
  }
}