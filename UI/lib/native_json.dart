import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show Directory, Platform;
import 'dart:isolate';
import 'dart:math';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sys_template/app_bloc.dart';
import 'package:flutter_sys_template/generated_bindings.dart';
import 'package:path/path.dart' as p;

class PathMap {
  final bool solved;
  final Point position;
  final Point target;
  final Point mapSize;
  final String mapString;
  final List<Point> path;

  PathMap(this.solved, this.position, this.target, this.mapSize, this.mapString,
      this.path);

  Map<String, dynamic> toJson() {
    var output = {
      'solved': solved,
      'position': {'x': position.x, 'y': position.y},
      'target': {'x': target.x, 'y': target.y},
      'map': {'x': mapSize.x, 'y': mapSize.y, 'str': mapString},
    };

    List<dynamic> points = [];
    for (var i = 0; i < path.length; i++) {
      points.add({'x': path[i].x, 'y': path[i].y});
    }
    output['path'] = points;

    return output;
  }
}

PathMap stringToPathMap(String s) {
  Map<String, dynamic> json = jsonDecode(s);
  bool solved = json['solved'];
  Point pos = Point(json['position']['x'] as int, json['position']['y'] as int);
  Point target = Point(json['target']['x'] as int, json['target']['y'] as int);
  Point mapSize = Point(json['map']['x'] as int, json['map']['y'] as int);
  String mapString = json['map']['str'];
  var points = json['path'];
  List<Point> path = [];
  for (var point in points) {
    path.add(Point(point['x'] as int, point['y'] as int));
  }
  return PathMap(solved, pos, target, mapSize, mapString, path);
}

final DynamicLibrary dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    throw UnsupportedError('Usupported platform: ${Platform.operatingSystem}');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('libjson.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open(p.join(Directory.current.parent.path,
        'json_library', 'bin', 'Debug', 'json_library.dll'));
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final NativeJSON _bindings = NativeJSON(dylib);

final port = ReceivePort();

void initPortListener(BuildContext context) {
  // Enable async callbacks in dart
  _bindings.Dart_InitializeApiDL(NativeApi.initializeApiDLData);

  port.listen((data) {
    context.read<AppBloc>().add(ChangeStateEvent(data));
  });
}

bool validJSON() {
  final json = jsonDecode(helloJSON()) as Map<String, dynamic>;
  return json['valid'] != null && json['valid'];
}

String helloJSON() {
  return _bindings.hello_json().cast<Utf8>().toDartString();
}

void foo(int i) {
  PathMap pathmap = PathMap(
    false,
    const Point(0, 0),
    const Point(20, 8),
    const Point(30, 10),
    "     x      x                x"
    "     x      xxxxxx    x      x"
    "xxxx xxxxxxxx      xxxxxxx    "
    "   x                     xxx x"
    "        xxxxxx  xxxxx         "
    "xxxx x  x    x            x   "
    "   x x  xxxxxx    xxxxxx  xxxx"
    "   x x            x    x      "
    "   x xxxxxxxxx  xxx    xxxx   "
    "xxxx                   x     x",
    [],
  );
  String pathJsonString = jsonEncode(pathmap.toJson());
  var ptr = pathJsonString.toNativeUtf8().cast<Char>();
  _bindings.makeMap(ptr, pathJsonString.length, port.sendPort.nativePort);
}
