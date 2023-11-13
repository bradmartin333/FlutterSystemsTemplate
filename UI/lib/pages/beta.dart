import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sys_template/app_bloc.dart';
import 'package:flutter_sys_template/native_json.dart';

DrawingTool tool = DrawingTool.none;
double rectSize = 25;
Point mapSize = const Point(-1, -1);
List<Point<double>> points = [];

enum DrawingTool { none, position, target, draw, erase }

void gestureEvent(BuildContext context, dynamic gesture) {
  Point p = Point(gesture.localPosition.dx, gesture.localPosition.dy);
  context.read<AppBloc>().add(ChangeCursorEvent(p));
  updateMap();
}

void updateMap() {
  sendMap(
      mapSize,
      String.fromCharCodes(Iterable.generate(
          (mapSize.x * mapSize.y).toInt(),
          (i) => points.contains(Point((i % mapSize.x + 1) * rectSize,
                  (i / mapSize.x + 1).floor() * rectSize))
              ? 120
              : 32)));
}

Widget makeToolButton(
    DrawingTool thisTool, IconData iconData, Function setState) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: FilledButton.tonal(
      onPressed: () => setState(() => tool = thisTool),
      child: Icon(
        iconData,
        color: tool == thisTool ? Colors.green : null,
      ),
    ),
  );
}

Widget betaWidget() {
  var userDelete = false;

  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: GestureDetector(
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
          ),
        ),
        bottomSheet: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.bounceIn,
          transitionBuilder: (Widget child, Animation<double> animation) {
            final offsetAnimation = Tween(
              begin: const Offset(1.0, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(animation);
            return ClipRect(
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
          child: userDelete
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  key: const ValueKey<int>(0),
                  children: [
                    const Text('Delete All?'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton.tonal(
                        onPressed: () {
                          points.clear();
                          updateMap();
                          setState(() => userDelete = false);
                        },
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton.tonal(
                        onPressed: () => setState(() => userDelete = false),
                        child: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  key: const ValueKey<int>(1),
                  children: [
                    makeToolButton(
                        DrawingTool.position, Icons.my_location, setState),
                    makeToolButton(DrawingTool.target, Icons.flag, setState),
                    makeToolButton(
                        DrawingTool.draw, Icons.select_all, setState),
                    makeToolButton(DrawingTool.erase, Icons.deselect, setState),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                        visible: !userDelete,
                        child: FilledButton.tonal(
                          onPressed: () {
                            setState(() {
                              tool = DrawingTool.none;
                              userDelete = true;
                            });
                          },
                          child: const Icon(Icons.delete_forever),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      );
    },
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
  // Will also update on new json
  bool shouldRepaint(MapCanvas oldDelegate) => cursor.x >= 0 && cursor.y >= 0;
  @override
  bool shouldRebuildSemantics(MapCanvas oldDelegate) => false;
}
