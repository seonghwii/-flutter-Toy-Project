import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today'); // 값 보내줌
    final response = await http.get(url); // http에서 데이터 요청
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response
          .body); // response.body의 body는 String이므로 이를 json 포맷으로 변경해주어야 한다. // webtoons는 json 형식이다.
      // jsonDecode는 dynamic 타입이므로 return 타입을 지정해주어야 한다. // 리스트 안에 dynamic들을 담아준다. (디버그 콘솔 확인 -> 리스트 안에 값이 담겨져 있음.)
      // print(response.body); //
      for (var webtoon in webtoons) {
        // print(webtoon);
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
        // final toon = WebtoonModel.fromJson(webtoon);
        // print(toon.title);
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    // 웹툰 id 하나 받아오는 메소드
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error;
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      // 에피소드 받아오는 메소드
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];

    final url = Uri.parse('$baseUrl/$id/episodes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error;
  }
}
