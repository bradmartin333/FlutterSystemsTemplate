import 'dart:convert';
import 'dart:ffi';
import 'dart:io' show Directory, Platform;
import 'package:ffi/ffi.dart';
import 'package:flutter_sys_template/generated_bindings.dart';
import 'package:path/path.dart' as p; // Add this import

// C function: char *hello_world();
// There's no need for two typedefs here, as both the
// C and Dart functions have the same signature
typedef HelloWorld = Pointer<Utf8> Function();

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

bool validJSON() {
  final json = jsonDecode(helloJSON()) as Map<String, dynamic>;
  return json['valid'] != null && json['valid'];
}

String helloJSON() {
  return _bindings.hello_json().cast<Utf8>().toDartString();
}

typedef ExampleCallback = Int32 Function(Pointer<Void>, Int32);

const except = -1;

int callback(Pointer<Void> ptr, int i) {
  print('in callback i=$i');
  return i + 1;
}

int foo(int i) {
  return _bindings.foo(
    i,
    Pointer.fromFunction<ExampleCallback>(callback, except),
  );
}
