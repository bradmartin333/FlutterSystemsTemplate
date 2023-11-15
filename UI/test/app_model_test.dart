import 'package:flutter_sys_template/app_model.dart';
import 'package:test/test.dart';

void main() {
  test('updating json changes AppModel in listener', () {
    final appModel = AppModel();
    expect(appModel.json, "");
    appModel.addListener(() {
      expect(appModel.json != "", true);
    });
    appModel.updateJson("hello");
  });
}
