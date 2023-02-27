import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/widgets/webtoon_widget.dart';
// import 'dart:async';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // body 색상 변경
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white, // appBar 색상
        foregroundColor: Colors.green, // appBar 글자 색상
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),

      body: FutureBuilder(
        // data fetching을 위한 함수
        future: webtoons, // future 함수(값이 들어올 떄까지 기다려줄 함수)
        builder: (context, snapshot) {
          // snapshot이라는 이름 바꿔도 됨.
          // snapshot : Future의 상태
          if (snapshot.hasData) {
            // 값이 들어오면 화면에 뿌려줄 내용을 return함.
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: makeList(snapshot),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(), // 로딩 페이지 띄움
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      scrollDirection: Axis.horizontal, // 수평 방향으로 스크롤
      itemCount: snapshot.data!.length, //list의 개수를 설정해주는 기능
      itemBuilder: (context, index) {
        // 사용자가 보고있는 아이템만 빌드함.
        // print(index);
        var webtoon = snapshot.data![index];
        return Webtoon(
            title: webtoon.title, thumb: webtoon.thumb, id: webtoon.id);
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
