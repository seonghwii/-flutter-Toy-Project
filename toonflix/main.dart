import 'package:flutter/material.dart';
import 'package:toonflix/screens/home_screen.dart';

void main() {
  // ApiServie().getTodaysToons(); 디버그 콘솔에서 확인하려고 호출한 거였음.
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key}); // key를 stateless widget이라는 슈퍼클래스에 전달

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
