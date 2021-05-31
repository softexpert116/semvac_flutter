import 'package:flutter/cupertino.dart';

class PushNotification with ChangeNotifier {
  String _articleId = '';
  String _text = '';
  String _type = '';
  DateTime _sentTime;

  void setNotificationData(
      String articleId, String text, String type, DateTime sentTime) {
    _articleId = articleId;
    _text = text;
    _type = type;
    _sentTime = sentTime;
    notifyListeners();
  }

  String get getArticleId => _articleId;

  String get getText => _text;

  String get getType => _type;

  DateTime get getSentTime => _sentTime;
}
