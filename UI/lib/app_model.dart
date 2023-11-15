import 'package:flutter/material.dart';

class AppModel extends ChangeNotifier {
  var json = "";

  void updateJson(String json) {
    this.json = json;
    notifyListeners();
  }
}
