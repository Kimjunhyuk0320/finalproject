import 'package:flutter/material.dart';
import 'package:livedom_app/screens/liveBoard/liveboard_list.dart';
import 'package:livedom_app/screens/myPage/mypage.dart';
import 'package:livedom_app/screens/rental/rental_list.dart';
import 'package:livedom_app/screens/team/team_list.dart';
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


  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp()
    )
    
  );
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

        // mypage
        '/mypage': (context) => MyPageScreen(),

        // rental
        '/rental': (context) => RentalListScreen(),

        // team
        '/team': (context) => TeamListScreen(),
        
      },
    );
  }
}
