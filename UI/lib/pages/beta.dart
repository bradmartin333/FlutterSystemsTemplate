import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sys_template/app_bloc.dart';

Point mapSize = Point(-1, -1);
List<Point<double>> points = [];

void gestureEvent(BuildContext context, dynamic gesture) {
  Point p = Point(gesture.localPosition.dx, gesture.localPosition.dy);
  context.read<AppBloc>().add(ChangeCursorEvent(p));
}

Widget betaWidget(BuildContext context) {
  return GestureDetector(
    child: BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        //print(state.cursor);
      },
      builder: (context, state) {
        return CustomPaint(
          painter: MapCanvas(state.cursor),
        );
      },
    ),
    onTapDown: (details) => gestureEvent(context, details),
    onPanUpdate: (details) => gestureEvent(context, details),
  );
}

class MapCanvas extends CustomPainter {
  Point cursor;
  MapCanvas(this.cursor);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()..color = Colors.white,
    );

    // Pixelate the points
    double rectSize = 25;
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
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(MapCanvas oldDelegate) => cursor.x >= 0 && cursor.y >= 0;
  @override
  bool shouldRebuildSemantics(MapCanvas oldDelegate) => false;
}
