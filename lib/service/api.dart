import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:semvac_covid_viet/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/article_model.dart';

class Service {
  String domain = 'http://www.semvac.info/adminpanel';
  // String domain = 'http://10.10.10.108:8080/manager';

  Future<List<Article>> getArticleList() async {
    try {
      List<Article> result = [];
      var response = await http.get(
        "$domain/index.php/mobile?type=get_articles",
      );
      final body = convert.jsonDecode(response.body);
      print(body);
      final data = body["data"];
      if (response.statusCode == 200) {
        for (var i = 0; i < data["data"].length; i++) {
          result.add(Article.fromJSON(data["data"][i]));
          print(result[i].articleTitle);
        }
      }
      return result;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> addFvorites(String id) async {
    try {
      var response = await http.post(
        "$domain/index.php/mobile?type=add_favor&id=$id",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      // final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> removeFvorites(String id) async {
    try {
      var response = await http.post(
        "$domain/index.php/mobile?type=remove_favor&id=$id",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      // final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<List<Article>> getFavoriteArticleList(String ids) async {
    try {
      List<Article> result = [];
      var response = await http.post(
        "$domain/index.php/mobile?type=get_favors&ids=$ids",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      final body = convert.jsonDecode(response.body);
      final data = body["data"];
      print(body["data"]);
      if (response.statusCode == 200) {
        for (var i = 0; i < data["data"].length; i++) {
          result.add(Article.fromJSON(data["data"][i]));
          print(result[i].articleTitle);
        }
      }
      return result;
    } catch (err) {
      rethrow;
    }
  }

  Future<Article> getArticleById(String id) async {
    try {
      Article result;
      var response = await http.post(
        "$domain/index.php/mobile?type=get_article&id=$id",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      final body = convert.jsonDecode(response.body);
      final data = body["data"];
      print(body["data"]);
      if (response.statusCode == 200) {
        if (data["data"] == null) {
          result = Article.fromJSON(data);
        } else {
          print("-*-*****************");
          result = null;
        }
      }
      return result;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> addShares(String id) async {
    try {
      var response = await http.post(
        "$domain/index.php/mobile?type=add_share&id=$id",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      // final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> addArticleOpens(String id) async {
    try {
      var response = await http.post(
        "$domain/index.php/mobile?type=add_open&id=$id",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> addAppOpens() async {
    try {
      var response = await http.post(
        "$domain/index.php/mobile?type=app_open",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> addNotificationOpens() async {
    try {
      var response = await http.post(
        "$domain/index.php/mobile?type=notification_open",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> getAppName() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await http.post(
        "$domain/index.php/mobile?type=get_name",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        appName = body["data"]["data"]["app_name"];
        print(appName);
        prefs.setString("app_name", appName);
      } else {
        appName = "SEMVAC";
        prefs.setString("app_name", appName);
      }
    } catch (err) {
      rethrow;
    }
  }
}
