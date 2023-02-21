import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500; // 초기값 fix
  int totalSeconds = twentyFiveMinutes; // 타이머 기능 추가
  bool isRunning = false; // 아이콘 view 여부 결정
  int totalPomodoros = 0; // 전체 시행 수
  late Timer timer;  

  void ontick(Timer timer){ // start 아이콘 클릭했을 때 타이머 재생되는 메소드
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros += 1;
        isRunning = false;
        totalSeconds = twentyFiveMinutes;
      });
      timer.cancel(); // 타이머 멈춤 
    }
    else {
    setState(() {
      totalSeconds = totalSeconds - 1;
    });
    }
    
  }

  void onStartPressed(){
    timer = Timer.periodic(
      const Duration(seconds: 1),
      ontick,
      );
      setState(() {
        isRunning = true; // 작동 중입니다.
      });
  }

  void onPausePressed() {
    timer.cancel(); // 타이머 멈춤
    setState(() {
      isRunning = false; // 작동하지 않습니다.
    });
  }

  String format(int seconds) { // 분단위로 보여주기 위한 메소드
    var duration = Duration(seconds: seconds); // 초단위로 보여주고 
    return duration.toString().split(".").first.substring(2, 7); // substring : 슬라이싱
  }


  void onResetPressed(){
    setState(() {
      timer.cancel(); // 타이머가 더이상 흘러 가지 않게 지정
      totalSeconds = twentyFiveMinutes; // 변수값 초기화
      isRunning = false; // pause 버튼 -> start 버튼으로 변경 
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter, // 핸드폰에 화면이 가려질 경우 사용하는 기능
            child: Text(format(totalSeconds),
            style: TextStyle(
              color: Theme.of(context).cardColor,
              fontSize: 89,
              fontWeight: FontWeight.w600,
            ),
            ),
          ),
          ),
          Flexible(
            flex: 1,
            child: Center(
            child: IconButton(
              iconSize: 120,
              color: Theme.of(context).cardColor,
              onPressed: isRunning ? onPausePressed : onStartPressed,  
              // 버튼 눌렀을 때 false(기본값)일 경우 타이머 시작, 아닌 경우 타이머 멈춤
              icon: Icon( 
                isRunning ? Icons.pause_circle_outline : Icons.play_circle_outlined,
                ), 
                // 타이머가 실행되고 있을 때 pause 버튼이 보이게끔
            ),
          ),
          ),
          Flexible( // 초기화 아이콘 생성 
            flex: 1,
            child: Center(
            child: IconButton(
              iconSize: 120,
              color: Theme.of(context).cardColor,
              onPressed: isRunning ? onResetPressed :() {},
              // 버튼 눌렀을 때 false(기본값)일 경우 타이머 시작, 아닌 경우 타이머 멈춤
              icon: const Icon(Icons.stop_circle_rounded,
                ), 
                // 타이머가 실행되고 있을 때 pause 버튼이 보이게끔
            ),
          ),
          ),
          Flexible(
            flex: 1, // 하나의 박스가 차지하는 비율을 정해줄 수 있다.
            child: Row( // 1. Row로 Container 감쌈
              children: [
                Expanded( // 2. Container 'Expanded' 감쌈
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(50), // 테두리 둥글게 만들기 
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // 3. 텍스트 중앙 정렬
                      children: [
                        Text('Pomodoros',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).textTheme.headline1!.color, // context 활용하여 색상 가져오기.
                          fontWeight: FontWeight.w600,
                        ),
                        ),
                        Text('$totalPomodoros', // pomodoros 삽입
                        style: TextStyle(
                          fontSize: 58,
                          color: Theme.of(context).textTheme.headline1!.color,
                          fontWeight: FontWeight.w600,
                        ),
                        ),
                      ],
                    ),
                           
                          ),
                ),
              ],
            ),
          )
           // Flexible은 하드 코딩되는 값을 만들어준다. ui를 비율에 기반해서 만들어줌.
        ],
      ),
    );
  }
}