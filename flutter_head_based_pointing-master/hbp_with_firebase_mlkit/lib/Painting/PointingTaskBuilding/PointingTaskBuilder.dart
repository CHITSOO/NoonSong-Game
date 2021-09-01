import 'package:HeadPointing/pointer.dart';
import 'package:flutter/material.dart';
import 'Target.dart';

enum PointingTaskType {
  Jeff,
  MDC,
}

class PointingTaskBuilder {
  Size canvasSize;
  final Pointer pointer;
  List<Target> targets = List<Target>();

  PointingTaskBuilder(this.canvasSize, this.pointer);

  void drawTargets(Canvas canvas) {
      targets.forEach((t) => (t.draw(canvas, pointer)));
  }

  void paint(Canvas canvas, Size size) {
   drawTargets(canvas);
  }

  bool shouldRepaint(PointingTaskBuilder oldDelegate) {
   return canvasSize != oldDelegate.canvasSize || pointer != oldDelegate.pointer;
  }

  TargetPainter getPainter() {
   return TargetPainter(this);
  }

  List<Target> getTargets() {
    return targets;
  }
}

class TargetPainter extends CustomPainter {
  PointingTaskBuilder _targetBuilder;

  TargetPainter(this._targetBuilder);

  @override
  void paint(Canvas canvas, Size size) {
   _targetBuilder.paint(canvas, size);
  }

  @override
  bool shouldRepaint(TargetPainter oldDelegate) {
   return _targetBuilder.shouldRepaint(oldDelegate.getTargetBuilder());
  }

  PointingTaskBuilder getTargetBuilder() {
   return _targetBuilder;
  }
}