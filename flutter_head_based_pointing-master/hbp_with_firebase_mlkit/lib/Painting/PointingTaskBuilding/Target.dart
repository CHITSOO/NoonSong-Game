import 'dart:ui' as ui;

import 'package:flutter/material.dart';

enum TargetShape {
  RectTarget,
  CircleTarget,
  NoonSongTarget, // 추가 1
}

class Target {
  Paint _style;
  TargetShape _targetShape;
  var _shape;
  var center;
  var center2;
  var width;
  var _switched = false;
  var pressed = false;
  var highlighted = false;

  // Target.fromRect(Rect rect, {Paint givenStyle}) {
  //   _targetShape = TargetShape.RectTarget;
  //   _shape = rect;
  //   center = rect.center;
  //   width = rect.width < rect.height ? rect.width : rect.height;
  //   if (givenStyle == null) {
  //     _style = Paint()
  //       ..color = Colors.purple;
  //   } else {
  //     _style = givenStyle;
  //   }
  // }

  Target.fromCircle(Offset position, double radius, {Paint givenStyle}) {
    _targetShape = TargetShape.CircleTarget;
    _shape = [position, radius];
    center = position;
    width = radius;
    if (givenStyle == null) {
      _style = Paint()
        ..color = Colors.lightGreen;
    } else {
      _style = givenStyle;
    }
  }

  Target.fromNoonSong(ui.Image image, Offset position, {Paint givenStyle}) {
    _targetShape = TargetShape.NoonSongTarget;
    _shape = image;
    center = position;
    center2 = Offset(position.dx + image.width * 0.5 , position.dy + image.height * 0.5);
    width = image.width < image.height ? image.width : image.height;
    //width = image.width;
    if (givenStyle == null) {
      _style = Paint()
        ..imageFilter = ui.ImageFilter.blur(sigmaX: .5, sigmaY: .5);
    } else {
      _style = givenStyle;
    }
  }

  double getDistanceFromPointer(pointer) {
    return (pointer.getPosition() - center).distance;
  }

  double getInnerDistanceFromPointer(pointer) {
    return (pointer.getPosition() - center).distance + width;
  }

  double getOuterDistanceFromPointer(pointer) {
    return (pointer.getPosition() - center).distance - width;
  }

  bool contains(pointer) {
    if (_targetShape == TargetShape.RectTarget)
      return _shape.contains(pointer.getPosition());
    else if (_targetShape == TargetShape.CircleTarget) {
      return pointer.touches(_shape[0], _shape[1]);
    }
    else if (_targetShape == TargetShape.NoonSongTarget) {
      return pointer.touches(center2, width.toDouble());
    }
    else
      return false;
  }

  void _updateState(pointer) {
    if (contains(pointer)) {
      if (pointer.fireSelection()) {
        if (!_switched)
          pressed = !pressed;
        _switched = true;
        highlighted = false;
        pointer.release();
      }
      else
        highlighted = true;
    }
    else {
      highlighted = false;
      _switched = false;
    }
  }

  void draw(Canvas canvas, pointer, {pointerRadius}) {
    _updateState(pointer);
    if (this.pressed)//이 pressed의 의미는 뭘까..
      //_style.color = Colors.blue;//마음에 걸림. image속성 뭐가 있는지 보자..
      _style.imageFilter = ui.ImageFilter.blur(sigmaX: .0, sigmaY: .0);
    else
      //_style.color = Colors.lightGreen;
      _style.imageFilter = ui.ImageFilter.blur(sigmaX: .5, sigmaY: .5);
    if (!_switched && highlighted)
      //_style.color = Colors.grey;
      _style.imageFilter = ui.ImageFilter.blur(sigmaX: .9, sigmaY: .9);
    if (_targetShape == TargetShape.RectTarget)
      canvas.drawRect(_shape, _style);
    else if (_targetShape == TargetShape.CircleTarget)
      canvas.drawCircle(_shape[0], _shape[1], _style);
    else if (_targetShape == TargetShape.NoonSongTarget)
      canvas.drawImage(_shape, center, _style);
  }
}