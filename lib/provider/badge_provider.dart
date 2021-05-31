import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgeCounter with ChangeNotifier {
  int _badgecount = 0;

  int get count => _badgecount;

  BadgeCounter() {
    init();
  }

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int prevBadgeCounts = prefs.getInt('badgeCounts');
    if (prevBadgeCounts == null) prevBadgeCounts = 0;
    _badgecount = prevBadgeCounts;
    notifyListeners();
  }

  void setCounts(int n) {
    _badgecount = n;
    notifyListeners();
  }

  Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedInStatus = prefs.getBool("loggedInStatus");

    if (loggedInStatus == null) {
      return false;
    }
    return loggedInStatus;
  }

  void increment() {
    _badgecount++;
    notifyListeners();
  }

  void initalizeCount() {
    _badgecount = 0;
    notifyListeners();
  }
}
