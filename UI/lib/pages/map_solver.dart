import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sys_template/app_bloc.dart';
import 'package:flutter_sys_template/native_json.dart';

bool repaint = false;
DrawingTool tool = DrawingTool.none;
double rectSize = 25;
Point mapSize = const Point(-1, -1);
Point position = const Point(0, 0);
Point target = const Point(10, 10);
List<Point<double>> points = []; // Raw local positions of user gestures

enum DrawingTool { none, position, target, draw, erase }

void gestureEvent(BuildContext context, dynamic gesture) {
  Point<double> p = Point(
      (gesture.localPosition.dx / rectSize).floor() * rectSize,
      (gesture.localPosition.dy / rectSize).floor() * rectSize);
  if (p.x >= 0 && p.y >= 0) {
    switch (tool) {
      case DrawingTool.position:
        if (points.contains(p)) {
          points.remove(p);
        }
        Point newPosition =
            Point((p.x / rectSize).floor(), (p.y / rectSize).floor());
        if (position != newPosition) {
          position = newPosition;
          updateMap();
        }
        break;
      case DrawingTool.target:
        if (points.contains(p)) {
          points.remove(p);
        }
        Point newTarget =
            Point((p.x / rectSize).floor(), (p.y / rectSize).floor());
        if (target != newTarget) {
          target = newTarget;
          updateMap();
        }
        break;
      case DrawingTool.draw:
        if (!points.contains(p) && p != position && p != target) {
          points.add(p);
          updateMap();
        }
        break;
      case DrawingTool.erase:
        if (points.contains(p)) {
          points.remove(p);
          updateMap();
        }
        break;
      case DrawingTool.none:
      default:
        break;
    }
  }
}

void updateMap() {
  sendMap(
      position,
      target,
      mapSize,
      String.fromCharCodes(Iterable.generate(
          (mapSize.x * mapSize.y).toInt(),
          (i) => points.contains(Point((i % mapSize.x) * rectSize,
                  (i / mapSize.x).floor() * rectSize))
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

Widget mapSolver() {
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
                repaint = true;
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
                    const Text('Delete all walls?'),
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
      updateMap();
    }

    // final Rect rect = Offset.zero & size;
    // canvas.drawRect(
    //   rect,
    //   Paint()..color = Colors.white,
    // );

    // Draw the map we are storing here
    for (var point in points) {
      canvas.drawRect(Rect.fromLTWH(point.x, point.y, rectSize, rectSize),
          Paint()..color = Colors.white);
    }

    // Parse the map json
    PathMap map = stringToPathMap(json);
    if (map.valid) {
      if (map.solved) {
        for (var point in map.path) {
          canvas.drawRect(
              Rect.fromLTWH(
                  point.x * rectSize, point.y * rectSize, rectSize, rectSize),
              Paint()..color = Colors.blue);
        }
      }
      canvas.drawRect(
          Rect.fromLTWH(map.position.x * rectSize, map.position.y * rectSize,
              rectSize, rectSize),
          Paint()..color = Colors.green);
      canvas.drawRect(
          Rect.fromLTWH(map.target.x * rectSize, map.target.y * rectSize,
              rectSize, rectSize),
          Paint()..color = Colors.red);
    }

    repaint = false;
  }

  @override
  bool shouldRepaint(MapCanvas oldDelegate) => repaint;
  @override
  bool shouldRebuildSemantics(MapCanvas oldDelegate) => false;
}
