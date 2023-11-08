import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show Directory, Platform;
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:flutter_sys_template/generated_bindings.dart';
import 'package:path/path.dart' as p;

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

void initPortListener() {
  // Enable async callbacks in dart
  _bindings.Dart_InitializeApiDL(NativeApi.initializeApiDLData);

  port.listen((data) {
    print(data);
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
  _bindings.foo(i, port.sendPort.nativePort);
  print("foo done");
}
