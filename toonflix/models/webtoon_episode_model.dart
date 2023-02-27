class WebtoonEpisodeModel {
  final String id, title, rating, date;

  WebtoonEpisodeModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        rating = json['rating'],
        id = json['id'],
        date = json['date'];
}
