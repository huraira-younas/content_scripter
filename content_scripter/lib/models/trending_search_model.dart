import 'package:flutter/foundation.dart' show immutable;

@immutable
class SearchEnum {
  final String title;
  final String value;

  const SearchEnum({required this.title, required this.value});
}

@immutable
class TrendingSearch {
  final List<String> keywords;
  final String shareUrl;
  final Image image;
  final List<Article> articles;

  const TrendingSearch({
    required this.keywords,
    required this.shareUrl,
    required this.articles,
    required this.image,
  });

  static const searchEnum = [
    SearchEnum(title: "All", value: "all"),
    SearchEnum(title: "Sci/Tech", value: "t"),
    SearchEnum(title: "Top Stories", value: "h"),
    SearchEnum(title: "Entertainment", value: "e"),
    SearchEnum(title: "Health", value: "m"),
    SearchEnum(title: "Business", value: "b"),
    SearchEnum(title: "Sports", value: "s"),
  ];

  // fromJson method
  factory TrendingSearch.fromJson(Map<String, dynamic> json) {
    var articlesFromJson = json['articles'] as List;
    List<Article> articleList =
        articlesFromJson.map((article) => Article.fromJson(article)).toList();

    return TrendingSearch(
      keywords: List<String>.from(json['entityNames']),
      image: Image.fromJson(json['image']),
      shareUrl: json['shareUrl'],
      articles: articleList,
    );
  }
}

class Image {
  final String newsUrl;
  final String source;
  final String imgUrl;

  Image({
    required this.newsUrl,
    required this.source,
    required this.imgUrl,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      newsUrl: json['newsUrl'],
      source: json['source'],
      imgUrl: json['imgUrl'],
    );
  }
}

class Article {
  final String articleTitle;
  final String url;
  final String source;
  final String time;
  final String snippet;

  Article({
    required this.articleTitle,
    required this.url,
    required this.source,
    required this.time,
    required this.snippet,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      articleTitle: json['articleTitle'],
      snippet: json['snippet'],
      source: json['source'],
      time: json['time'],
      url: json['url'],
    );
  }
}

@immutable
class InterestData {
  final DateTime time;
  final int value;

  const InterestData({
    required this.time,
    required this.value,
  });

  factory InterestData.fromJson(Map<String, dynamic> json) {
    int parsedValue = 0;
    if (json['value'][0] is String) {
      parsedValue = json['value'][0] == '<1' ? 0 : int.parse(json['value'][0]);
    } else {
      parsedValue = json['value'][0];
    }

    return InterestData(
      time: DateTime.fromMillisecondsSinceEpoch(int.parse(json['time']) * 1000),
      value: parsedValue,
    );
  }

  @override
  String toString() {
    return "Time: $time, value: $value";
  }
}
