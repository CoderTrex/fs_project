import 'package:firebase_database/firebase_database.dart';

class Subscrible {
  final String? userId;
  final String? title;
  final String? thumbnail;
  final String? url;
  final String? platform;
  final String? author;
  final DateTime? datetime;

  const Subscrible(
      {this.userId,
      this.title,
      this.thumbnail,
      this.url,
      this.platform,
      this.author,
      this.datetime});

  toJson() {
    return {
      "title": title,
      "thumbnail": thumbnail,
      "platform": platform,
      "author": author,
    };
  }
}

class subscribleContent {
  final String author;
  final String url;
  final String img;
  final String service;
  final String title;

  subscribleContent({
    required this.author,
    required this.url,
    required this.img,
    required this.service,
    required this.title,
  });
}
