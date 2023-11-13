import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sys_template/app_bloc.dart';
import 'package:flutter_sys_template/native_json.dart';

double rectSize = 25;
Point mapSize = const Point(-1, -1);
List<Point<double>> points = [];

void gestureEvent(BuildContext context, dynamic gesture) {
  Point p = Point(gesture.localPosition.dx, gesture.localPosition.dy);
  context.read<AppBloc>().add(ChangeCursorEvent(p));

  sendMap(
      mapSize,
      String.fromCharCodes(Iterable.generate(
          (mapSize.x * mapSize.y).toInt(),
          (i) => points.contains(Point((i % mapSize.x + 1) * rectSize,
                  (i / mapSize.x + 1).floor() * rectSize))
              ? 120
              : 32)));
}

Widget betaWidget(BuildContext context) {
  return GestureDetector(
    child: BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        //print(state.cursor);
      },
      builder: (context, state) {
        return CustomPaint(
          painter: MapCanvas(state.cursor, state.json),
        );
      },
    ),
    onTapDown: (details) => gestureEvent(context, details),
    onPanUpdate: (details) => gestureEvent(context, details),
  );
}

class MapCanvas extends CustomPainter {
  Point cursor;
  String json;
  MapCanvas(this.cursor, this.json);

  @override
  void paint(Canvas canvas, Size size) {
    if (mapSize == const Point(-1, -1)) {
      mapSize = Point(
          (size.width / rectSize).floor(), (size.height / rectSize).floor());
    }

    final Rect rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()..color = Colors.white,
    );

    // Draw the user point
    double px = (cursor.x / rectSize).floor() * rectSize;
    double py = (cursor.y / rectSize).floor() * rectSize;
    Point<double> newPoint = Point(px, py);
    if (!points.contains(newPoint)) {
      points.add(newPoint);
    }
    for (var element in points) {
      canvas.drawRect(Rect.fromLTWH(element.x, element.y, rectSize, rectSize),
          Paint()..color = Colors.black);
    }

    // Parse the map json
    PathMap test = stringToPathMap(json);
    if (test.valid && test.solved) {
      for (var element in test.path) {
        canvas.drawRect(
            Rect.fromLTWH(
                element.x * rectSize, element.y * rectSize, rectSize, rectSize),
            Paint()..color = Colors.blue);
      }
    }
  }

  @override
  bool shouldRepaint(MapCanvas oldDelegate) => cursor.x >= 0 && cursor.y >= 0;
  @override
  bool shouldRebuildSemantics(MapCanvas oldDelegate) => false;
}
