import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/api.dart';

class AppNameProvider with ChangeNotifier {
  String _appName = "SEMVAC";

  String get getName => _appName;

  AppNameProvider() {
    init();
  }

  Future init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Service _service = new Service();
    await _service.getAppName();
    String savedAppName = prefs.getString('app_name');
    if (savedAppName == null) savedAppName = "SEMVAC";
    _appName = savedAppName;
    notifyListeners();
  }
}
