import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends ChangeNotifier {
  var json = "";

  void updateJson(String json) async {
    this.json = json;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mapJson', json);
  }
}
