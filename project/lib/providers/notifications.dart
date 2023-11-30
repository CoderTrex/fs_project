import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../models/notification.dart';

class Notifications with ChangeNotifier {
  List<Notification> _items = [];
  final String? authToken;
  final String? userId;

  Notifications(this.authToken, this.userId, this._items);

  List<Notification> get items {
    _items.sort((a, b) {
      return b.datetime!.compareTo(a.datetime!);
    });
    return [..._items];
  }

  // 기존코드 url
  Future<void> fetchAndSetNotifications(String userId) async {
    final filterString = 'orderBy="receiverId"&equalTo="$userId"';

    //chatting-test-863cb-default-rtdb.asia-southeast1.firebasedatabase.app/notifications/ts
    final url = Uri.parse(
        'https://chatting-test-863cb-default-rtdb.asia-southeast1.firebasedatabase.app/notifications.json?auth=$authToken');
    // 'https://chatting-test-863cb-default-rtdb.asia-southeast1.firebasedatabase.app/notifications.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('HTTP GET 요청 성공: ${response.body}');
      } else {
        print('HTTP GET 요청 실패. 응답 코드: ${response.statusCode}');
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Notification> loadedNotifications = [];
      extractedData.forEach((notificationId, notificationData) {
        loadedNotifications.add(Notification(
          id: notificationId,
          title: notificationData['title'].toString(),
          contents: notificationData['contents'].toString(),
          datetime: DateTime.parse(notificationData['datetime'])
              .toUtc()
              .add(Duration(hours: 9)),
          postId: notificationData['postId'].toString(),
          receiverId: notificationData['receiverId'].toString(),
        ));
        print(loadedNotifications);
      });
      _items = loadedNotifications;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addNotification(Notification notification) async {
    final url = Uri.parse(
        'https://chatting-test-863cb-default-rtdb.asia-southeast1.firebasedatabase.app/notifications.json?auth=$authToken');
    final timeStamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': notification.title,
          'contents': notification.contents,
          'datetime': timeStamp.toIso8601String(),
          'postId': notification.postId,
          'receiverId': notification.receiverId,
        }),
      );

      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> deleteNotification(String id) async {
    final url = Uri.parse(
        'https://chatting-test-863cb-default-rtdb.asia-southeast1.firebasedatabase.app/notifications/$id.json?auth=$authToken');

    final existingNotiIndex =
        _items.indexWhere((notification) => notification.id == id);
    Notification? existingNotification = _items[existingNotiIndex];
    _items.removeAt(existingNotiIndex);
    //notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingNotiIndex, existingNotification);
      notifyListeners();
      throw HttpException('Could not delete notification.');
    }
    _items.removeWhere((notification) => notification.id == id);
    notifyListeners();
    existingNotification = null;
  }
}
