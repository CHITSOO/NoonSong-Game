import 'package:flutter/material.dart';
import 'PointingTaskBuilder.dart';
import 'Target.dart';
import 'dart:ui' as ui;

class JeffTaskBuilder extends PointingTaskBuilder {
  var _jeffTaskWidth = 80.0;
  var _jeffTaskEdge = 100.0;
  final ui.Image image;

  // void _createJeffTask(double width,{double e = 100}) { // e: edge
  //   Size size = canvasSize; // Size(420, 690); // manually detected size
  //   targets.add(Target.fromCircle(Offset(e, e), width));
  //   targets.add(Target.fromCircle(Offset(size.width-e, e), width));
  //   targets.add(Target.fromCircle(Offset(size.width/2, size.height/2), width));
  //   targets.add(Target.fromCircle(Offset(e, size.height-e), width));
  //   targets.add(Target.fromCircle(Offset(size.width-e, size.height-e), width));
  // }
  void _createJeffTask(double width,{double e = 100}) { // e: edge
    Size size = canvasSize; // Size(420, 690); // manually detected size
    targets.add(Target.fromNoonSong(image,Offset(e, e)));
    targets.add(Target.fromNoonSong(image,Offset(size.width-e, e)));
    targets.add(Target.fromNoonSong(image,Offset(size.width/2, size.height/2)));
    targets.add(Target.fromNoonSong(image,Offset(e, size.height-e)));
    targets.add(Target.fromNoonSong(image,Offset(size.width-e, size.height-e)));
  }

  JeffTaskBuilder(imageSize, pointer, this.image) :  super(imageSize, pointer) {
      _createJeffTask(_jeffTaskWidth, e: _jeffTaskEdge);
  }

  void _drawJeffTargets(Canvas canvas) {
    for(var i = 0; i < targets.length; i++) {
      targets[i].draw(canvas, pointer);
      if (targets[i].pressed)
        targets.removeAt(i);
    }
  }

  void _drawJeffTask(Canvas canvas) {
    if (targets.length <= 0) {
      _jeffTaskEdge *= 0.75;
      _jeffTaskWidth *= 0.75;
      _createJeffTask(_jeffTaskWidth, e: _jeffTaskEdge);
    }
    _drawJeffTargets(canvas);
  }

  @override
  void drawTargets(Canvas canvas) {
      _drawJeffTask(canvas);
  }
}