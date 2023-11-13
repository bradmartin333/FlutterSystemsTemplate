import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sys_template/app_bloc.dart';

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
          painter: Sky(state.cursor),
        );
      },
    ),
    onTapDown: (details) => gestureEvent(context, details),
    onPanStart: (details) => gestureEvent(context, details),
  );
}

class Sky extends CustomPainter {
  Point cursor;

  Sky(this.cursor);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const RadialGradient gradient = RadialGradient(
      center: Alignment(0.7, -0.6),
      radius: 0.2,
      colors: <Color>[Color(0xFFFFFF00), Color(0xFF0099FF)],
      stops: <double>[0.4, 1.0],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
    canvas.drawCircle(Offset(cursor.x as double, cursor.y as double), 5,
        Paint()..color = Colors.black);
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(Sky oldDelegate) => cursor.x >= 0 && cursor.y >= 0;
  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}
