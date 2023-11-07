import 'dart:ffi';
import 'dart:io' show Directory, Platform;
import 'package:ffi/ffi.dart';
import 'package:flutter_sys_template/generated_bindings.dart';
import 'package:path/path.dart' as p; // Add this import

const String _libName = 'json_library';

// C function: char *hello_world();
// There's no need for two typedefs here, as both the
// C and Dart functions have the same signature
typedef HelloWorld = Pointer<Utf8> Function();

final DynamicLibrary dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    // Add from here...
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return DynamicLibrary.open('build/macos/Build/Products/Debug'
          '/$_libName/$_libName.framework/$_libName');
    }
    // ...to here.
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    // Add from here...
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return DynamicLibrary.open(
          'build/linux/x64/debug/bundle/lib/lib$_libName.so');
    }
    // ...to here.
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open(p.join(Directory.current.parent.path,
        'json_library', 'bin', 'Debug', 'json_library.dll'));
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final NativeJSON _bindings = NativeJSON(dylib);

String helloJSON() {
  return _bindings.hello_json().cast<Utf8>().toDartString();
}
