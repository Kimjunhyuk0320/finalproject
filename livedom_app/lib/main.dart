import 'package:flutter/material.dart';
import 'package:livedom_app/provider/temp_user_provider.dart';
import 'package:livedom_app/screens/liveBoard/liveboard_list.dart';
import 'package:livedom_app/screens/liveBoard/liveboard_read_page.dart';
import 'package:livedom_app/screens/myPage/mypage.dart';
import 'package:livedom_app/screens/myPage/mypageTeam/team_state.dart';
import 'package:livedom_app/screens/myPage/mypageTeam/temp_state.dart';
import 'package:livedom_app/screens/rental/rental_list.dart';
import 'package:livedom_app/screens/team/team_insert.dart';
import 'package:livedom_app/screens/team/team_list.dart';
import 'package:livedom_app/screens/team/team_read.dart';
import 'package:livedom_app/screens/team/team_read_app.dart';
import 'package:livedom_app/screens/team/team_update.dart';
import 'package:livedom_app/screens/user/home_screen.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:livedom_app/provider/user_provider.dart';
import 'package:livedom_app/screens/user/login_screen.dart';
import 'package:livedom_app/screens/user/logout_screen.dart';
import 'package:provider/provider.dart';

void main() {
  // 카카오 sdk 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'c8d48be3a74cdc63839d547995b8efd0',
    javaScriptAppKey: 'e0484d6dd54e2c2541108f8e826222db',
  );

//테스트용으로 멀티프로바이더 형태로 바꿨습니다. 해당 부분을 아래 주석 부분으로 치환하면 돌릴 수 있습니다.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TempUserProvider()),
        // 필요한 만큼의 프로바이더를 추가합니다.
      ],
      child: const MyApp(),
    ),
  );

  // runApp(
  //   ChangeNotifierProvider(
  //       create: (context) => UserProvider(), child: const MyApp(),),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Dom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        //  user
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/logout': (context) => LogoutScreen(),

        // liveboard
        '/liveboard': (context) => LiveBoardListScreen(),
        '/liveboard/read': (context) => LiveBoardReadScreen(),

        // mypage
        '/mypage': (context) => MyPageScreen(),
        '/mypage/team/state': (context) => TeamStateScreen(),

        // rental
        '/rental': (context) => RentalListScreen(),

        // team
        '/team': (context) => TeamListScreen(),
        '/team/read': (context) => TeamReadScreen(),
        '/team/read/app': (context) => TeamReadAppScreen(),
        '/team/insert': (context) => TeamInsertScreen(),
        '/team/update': (context) => TeamUpdateScreen(),
      },
    );
  }
}
