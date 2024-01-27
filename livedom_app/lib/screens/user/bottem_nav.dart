import 'package:flutter/material.dart';
import 'package:livedom_app/provider/nav_provider.dart';
import 'package:livedom_app/screens/liveBoard/liveboard_list.dart';
import 'package:livedom_app/screens/myPage/mypage.dart';
import 'package:livedom_app/screens/rental/rental_list.dart';
import 'package:livedom_app/screens/team/team_list.dart';
import 'package:livedom_app/screens/user/home_view.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2;
  final List<Widget> _pages = [
    RentalListScreen(),
    TeamListScreen(),
    HomeView(),
    LiveBoardListScreen(),
    MyPageScreen()
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      int navIndex = Provider.of<NavProvider>(context, listen: false).navIndex;
      setState(() {
        _currentIndex = navIndex;
      });
      print('메인스크린 커런트 : ${_currentIndex}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade600,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(106, 0, 0, 0).withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              Provider.of<NavProvider>(context, listen: false).navIndex =
                  _currentIndex;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.layers,
                size: _currentIndex == 0 ? 32.0 : 24.0, 
                color: _currentIndex == 0 ? Color(0xff111827) : Colors.grey,
              ),
              label: '클럽대관',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people_alt_rounded,
                size: _currentIndex == 1 ? 32.0 : 24.0, 
                color: _currentIndex == 1 ? Color(0xff111827) : Colors.grey,
              ),
              label: '팀 모집',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: _currentIndex == 2 ? 32.0 : 24.0,                 
                color: _currentIndex == 2 ? Color(0xff111827) : Colors.grey,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.devices_rounded,
                size: _currentIndex == 3 ? 32.0 : 24.0, 
                color: _currentIndex == 3 ? Color(0xff111827) : Colors.grey,
              ),
              label: '공연',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: _currentIndex == 4 ? 32.0 : 24.0,                 
                color: _currentIndex == 4 ? Color(0xff111827) : Colors.grey,
              ),
              label: '내정보',
            ),
          ],
          selectedItemColor: Color(0xff111827),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(fontSize: 9, color: Color(0xff111827)),
          unselectedLabelStyle: TextStyle(fontSize: 9, color: Colors.grey),
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
