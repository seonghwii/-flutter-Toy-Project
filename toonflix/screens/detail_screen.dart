import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  // 0. stateless widget -> stateful widget으로 변경(initState 메소드를 통해 getToonById, getLatestEpisodesById에 접근할 수 있기 때문이다.)
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon; // 1. late로 변수 생성
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance(); // 핸드폰의 접근 권한 허용
    final likedToons = prefs
        .getStringList('likedToons'); // likedToons라는 이름의 String List가 있는지 확인
    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
        // likedToons라는 String list가 있을 때
        // 사용자가 좋아요를 누른 적이 있을 때
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList(
          'likedToons', []); // 사용자가 처음 앱을 실행했을 때 likedToons가 없으면 만들어준다.
    }
  }

  @override
  void initState() {
    // 2. initState 함수 생성
    super.initState();
    webtoon = ApiService.getToonById(widget.id); // 호출하기
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id); // id를 리스트에서 제거해줌.
      } else {
        likedToons.add(widget.id); // id를 리스트에 담아줌.
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // body 색상 변경
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white, // appBar 색상
        foregroundColor: Colors.green, // appBar 글자 색상
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_outline_outlined,
            ),
          ),
        ],
        title: Text(
          widget.title, // 해당 웹툰 이름 보여줌
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // overflow 해결 방법
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      // 이미지도 같이 보여줌
                      width: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15, // 그림자 거리
                            offset: const Offset(10, 10), //그림자 위치
                            color: Colors.black.withOpacity(0.5), // 그림자 투명도
                          ),
                        ],
                      ),
                      child: Image.network(widget.thumb),
                    ),
                  ),
                ],
              ), // 웹툰 이미지 로드
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
                      children: [
                        Text(
                          snapshot.data!.about, // 줄거리 요약
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          // 사이 간격 지정
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}', // 장르
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text("...");
                },
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // 렌더링할 내용을 지정해줌.
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(
                            episode: episode,
                            webtoonId: widget.id,
                          ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
