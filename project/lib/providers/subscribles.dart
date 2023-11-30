import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/comment.dart';
import '../models/subscrible.dart';

class subscribles with ChangeNotifier {
  List<Subscrible> _items = [];
  final String? authToken;
  final String? userId;

  subscribles(this.authToken, this.userId, this._items);

  List<Subscrible> get items {
    _items.sort((a, b) {
      return a.datetime!.compareTo(b.datetime!);
    });
    return [..._items];
  }

  Future<void> fetchAndSetSubScribles(String userId) async {
    // final filterString = 'orderBy="postId"&equalTo="$postId"';
    var url = Uri.parse(
        'https://chatting-test-863cb-default-rtdb.asia-southeast1.firebasedatabase.app/subscribles.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      final List<Subscrible> loadedsubscribles = [];
      extractedData.forEach((subscribleId, subscribleData) {
        final webtoonTitle = subscribleData.keys.first;
        loadedsubscribles.add(Subscrible(
          userId: subscribleId,
          title: subscribleData['title'],
          thumbnail: subscribleData[webtoonTitle]['thumbnail'],
          datetime: subscribleData[webtoonTitle]['datetime'],
          url: subscribleData[webtoonTitle]['url'],
          platform: subscribleData[webtoonTitle]['platform'],
          author: subscribleData[webtoonTitle]['author'],
        ));
      });
      _items = loadedsubscribles;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addSubcrible(Subscrible subscrible) async {
    final url = Uri.parse(
        'https://chatting-test-863cb-default-rtdb.asia-southeast1.firebasedatabase.app/subscribles.json?auth=$authToken');
    final timeStamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          subscrible.title: {
            'thumbnail': subscrible.thumbnail,
            'url': subscrible.url,
            'platform': subscrible.platform,
            'author': subscrible.author,
            'datetime': timeStamp.toIso8601String(),
          },
        }),
      );

      final newsubscrible = Subscrible(
        title: subscrible.title,
        thumbnail: subscrible.thumbnail,
        url: subscrible.url,
        platform: subscrible.platform,
        author: subscrible.author,
        datetime: timeStamp,
        userId: json.decode(response.body)['name'],
      );

      _items.add(newsubscrible);

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> deleteSubscrible(String userId, String title) async {
    final url = Uri.parse(
        'https://chatting-test-863cb-default-rtdb.asia-southeast1.firebasedatabase.app/subscribles/$userId/$title.json?auth=$authToken');

    final existingSubscribleIndex =
        _items.indexWhere((subscrible) => subscrible.title == title);
    Subscrible existingSubscrible = _items[existingSubscribleIndex];
    _items.removeAt(existingSubscribleIndex);

    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _items.insert(existingSubscribleIndex, existingSubscrible);
        notifyListeners();
        throw HttpException('Could not delete comment.');
      }
      existingSubscrible = null!;
    } catch (error) {
      _items.insert(existingSubscribleIndex, existingSubscrible);
      notifyListeners();
      throw (error);
    }
  }
}
