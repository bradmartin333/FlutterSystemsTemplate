import 'dart:ffi';
import 'dart:io' show Directory, Platform;

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

final class Coordinate extends Struct {
  @Double()
  external double latitude;

  @Double()
  external double longitude;
}

final class Place extends Struct {
  external Pointer<Utf8> name;
  external Coordinate coordinate;
}

// C function: char *hello_world();
// There's no need for two typedefs here, as both the
// C and Dart functions have the same signature
typedef HelloWorld = Pointer<Utf8> Function();

// C function: char *reverse(char *str, int length)
typedef ReverseNative = Pointer<Utf8> Function(Pointer<Utf8> str, Int32 length);
typedef Reverse = Pointer<Utf8> Function(Pointer<Utf8> str, int length);

// C function: void free_string(char *str)
typedef FreeStringNative = Void Function(Pointer<Utf8> str);
typedef FreeString = void Function(Pointer<Utf8> str);

// C function: struct Coordinate create_coordinate(double latitude, double longitude)
typedef CreateCoordinateNative = Coordinate Function(
    Double latitude, Double longitude);
typedef CreateCoordinate = Coordinate Function(
    double latitude, double longitude);

// C function: struct Place create_place(char *name, double latitude, double longitude)
typedef CreatePlaceNative = Place Function(
    Pointer<Utf8> name, Double latitude, Double longitude);
typedef CreatePlace = Place Function(
    Pointer<Utf8> name, double latitude, double longitude);

// C function: double distance(struct Coordinate, struct Coordinate)
typedef DistanceNative = Double Function(Coordinate p1, Coordinate p2);
typedef Distance = double Function(Coordinate p1, Coordinate p2);

// Dart runtime variables and functions
DynamicLibrary? dylib;
bool get initialized => dylib != null;

void checkLoad() {
  if (!initialized) {
    loadLib();
  }
}

void loadLib() {
  var libraryPath =
      path.join(Directory.current.path, 'structs_library', 'libstructs.so');
  if (Platform.isMacOS) {
    libraryPath = path.join(
        Directory.current.path, 'structs_library', 'libstructs.dylib');
  }
  if (Platform.isWindows) {
    libraryPath = path.join(Directory.current.path, 'structs_library', 'build',
        'Debug', 'structs.dll');
  }
  dylib = DynamicLibrary.open(libraryPath);
}

String helloWorld() {
  checkLoad();
  final helloWorld =
      dylib!.lookupFunction<HelloWorld, HelloWorld>('hello_world');
  return helloWorld().toDartString();
}

String reverseString(String s) {
  checkLoad();
  final reverse = dylib!.lookupFunction<ReverseNative, Reverse>('reverse');
  final utf8 = s.toNativeUtf8();
  final reversedUtf8 = reverse(utf8, utf8.length);
  final reversedMessage = reversedUtf8.toDartString();
  calloc.free(utf8);
  final freeString =
      dylib!.lookupFunction<FreeStringNative, FreeString>('free_string');
  freeString(reversedUtf8);
  return reversedMessage;
}

Coordinate createCoordinate(double latitude, double longitude) {
  checkLoad();
  final createCoordinate = dylib!
      .lookupFunction<CreateCoordinateNative, CreateCoordinate>(
          'create_coordinate');
  return createCoordinate(latitude, longitude);
}

Place createPlace(String name, double latitude, double longitude) {
  checkLoad();
  final nameUtf8 = name.toNativeUtf8();
  final createPlace =
      dylib!.lookupFunction<CreatePlaceNative, CreatePlace>('create_place');
  final place = createPlace(nameUtf8, latitude, longitude);
  calloc.free(nameUtf8);
  return place;
}

double getDistance(Coordinate a, Coordinate b) {
  checkLoad();
  final distance = dylib!.lookupFunction<DistanceNative, Distance>('distance');
  return distance(a, b);
}
