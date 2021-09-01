import 'package:HeadPointing/Painting/PointingTaskBuilding/PointingTaskBuilder.dart';
import 'package:HeadPointing/Painting/PointingTaskBuilding/JeffTaskBuilder.dart';
import 'package:HeadPointing/Painting/PointingTaskBuilding/MDCTaskBuilder.dart';
import 'package:HeadPointing/pointer.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

List<double> offsetToList(Offset o) => [o.dx, o.dy];

List<int> offsetToIntList(Offset o) => [o.dx.toInt(), o.dy.toInt()];

List<double> sizeToList(Size s) => [s.width, s.height];

List<List<List<double>>> listOfOffsetsToListOfList(List<List<Offset>> list) =>
    list.map((l) => (l.map((e) => offsetToList(e)).toList())).toList();

String enumToString(e) => '' + e.toString() + '';

List<String> enumListToStringList(List list) =>
    list.map((e) => enumToString(e)).toList();

class MDCTestBlock {
//  PointingTaskType _pointingTaskType = PointingTaskType.MDC;
  List<Offset> _targetPoints = List<Offset>();
  List<Map> _missedSelections = List<Map>();
  List<Map> _selections = List<Map>();
  List<Map> _trailLogs = List<Map>();
  List<Map> _transitions = List<Map>();
  List<Map> _transitionsWithPath = List<Map>();
  List<Map> _trails = List<Map>();
  List<Map> _trailsWithPath = List<Map>();
  double _lastMovementDuration = 0;
  double _totalPauseDuration = 0;
  double _pauseDuration = 0;
  int _blockPauseMoment = 0;
  double _blockDuration = 0;
  int _startMoment = 0;
  int _lastSelectionMoment = 1;
  int _missedSelectionID = 1;
  int _selectionID = 1;
  int _targetID = 0;
  int _transitionID = 1;
  int _trailID = 1;
  int _blockID = 1;
  int _now = 1;
  bool _paused = false;
  bool _everPaused = false;
  bool _completed = false;
  Size _canvasSize;
  Pointer _pointer;
  dynamic _taskBuilder;
  ui.Image image;

  Map<String, dynamic> pointerLog(Offset pos, int moment) => {
    'Moment': moment,
    'Position': offsetToList(pos),
  };

  Map<String, dynamic> trailLog(id, double duration, Offset target,
    List<Map> trail, {bool addPath: false}) {
    Map<String, dynamic> t = {
      'TrailID': id,
      'Duration': duration,
      'Start': trail.first,
      'End': trail.last,
      'TargetID': _targetID,
      'TargetLocation': offsetToList(target),
    };

    if (addPath)
      t['Logs'] = trail;
    return t;
  }

  Map<String, dynamic> selectionLog(id, int moment, Offset pos, mode, Offset target) => {
    'SelectionID': id,
    'Moment': moment,
    'Mode': enumToString(mode),
    'TargetID': _targetID,
    'TargetLocation': offsetToList(target),
    'Coordinates': offsetToList(pos),
  };

  double getIndexOfDifficulty() {
    final a = _taskBuilder.getAmplitude();
    final w = _taskBuilder.getTargetWidth();
    return math.log(a/w+1) / math.log(2);
  }

  double getTotalTrailDuration() {
    double mt = 0;
    final dt = _pointer.isDwellingEnabled() ? _pointer.getDwellTime() : 0;
    _trails.forEach((l){mt += (l['Duration'] - dt);});
    return mt;
  }

  double getTotalTransitionDuration() {
    double mt = 0;
    final dt = _pointer.isDwellingEnabled() ? _pointer.getDwellTime() : 0;
    _transitions.forEach((l){mt += (l['Duration'] - dt);});
    return mt;
  }

  double getTotalDuration() {
    return getTotalTrailDuration() + getTotalTransitionDuration();
  }

  double getAverageTrailDuration() {
    return getTotalTrailDuration() / _trails.length;
  }

  double getAverageTransitionDuration() {
    return getTotalTransitionDuration() / _transitions.length;
  }

  double calculateThroughput() {
    if (_trails.isEmpty)
      return 0;
    return getIndexOfDifficulty() / getAverageTrailDuration();
  }

  Map<String, dynamic> logInformation() => {
    'CorrectSelections': _selections,
    'Throughput': calculateThroughput(),
    'TotalDuration': getTotalDuration(),
    'TotalTrailDuration': getTotalTrailDuration(),
    'AverageTrailDuration': getAverageTrailDuration(),
    'TotalTransitionDuration': getTotalTransitionDuration(),
    'AverageTransitionDuration': getAverageTransitionDuration(),
    'trails': _trails, // frame by frame pointer logs with timestamps
    'transitions': _transitions, // pointer logs with timestamps between subspaces
  };

  Map<String, dynamic> logInformationWithPath(int docID, int testID) => {
    'DocID': docID,
    'TestID': testID,
    'BlockID': _blockID,
    'Throughput': calculateThroughput(),
    'TotalDuration': getTotalDuration(),
    'TotalTrailDuration': getTotalTrailDuration(),
    'AverageTrailDuration': getAverageTrailDuration(),
    'TotalTransitionDuration': getTotalTransitionDuration(),
    'AverageTransitionDuration': getAverageTransitionDuration(),
    'CorrectSelections': _selections,
    'MissedSelections': _missedSelections,
    'trails': _trailsWithPath, // frame by frame pointer logs with timestamps
    'transitions': _transitionsWithPath, // pointer logs with timestamps between subspaces
  };

  Map<String, dynamic> blockInformation({bool completedSuccessfully: true}) => {
    'BlockID': _blockID,
    'Status': completedSuccessfully ? 'Complete' : 'Incomplete',
    'Paused': _everPaused ? 'Yes' : 'Never',
    'Amplitude': _taskBuilder.getAmplitude(),
    'TargetWidth': _taskBuilder.getTargetWidth(),
    'IndexOfDifficulty': getIndexOfDifficulty(),
    'BlockTrailCount': _taskBuilder.getBlockTrailCount(),
    'OuterTargetCount': _taskBuilder.getOuterTargetCount(), // ones on circumference
    'SubspaceTargetCount': _taskBuilder.getSubspaceTargetCount(), // in a subspace
    'BlockTargetCount': _taskBuilder.getBlockTargetCount(), // in the block (4 subspaces)
    'OffsetToEdges':  offsetToList(_taskBuilder.getOffsetToEdges()), // location of top-left center
//    'TargetLocations': _targetPoints.map((o) => offsetToIntList(o)).toList(), // coordinates
    'TaskBuilderCanvasSize': sizeToList(_taskBuilder.getCanvasSize()),
    'LogInformation': logInformation(), // lists of important timestamps and pointer logs
  };

  void setConfiguration(Map<String, dynamic> config) {
    if (config == null)
      _taskBuilder = MDCTaskBuilder(_canvasSize, _pointer, recorder: this);
    else if (config.containsKey('PointingTaskType')) {
      if (config['PointingTaskType'] == PointingTaskType.Jeff)
        _taskBuilder = JeffTaskBuilder(_canvasSize, _pointer, image);
      else // if (pointingTaskType == PointingTaskType.MDC)
        _taskBuilder = MDCTaskBuilder(_canvasSize, _pointer,
            recorder: this, layout: config);
    } else
      _taskBuilder = MDCTaskBuilder(_canvasSize, _pointer,
          recorder: this, layout: config);

  }

  MDCTestBlock(this._canvasSize, this._blockID, this._pointer, this._now, {Map config}) {
    _startMoment = _now;
    _lastSelectionMoment = _startMoment;
    setConfiguration(config);
  }

  void updateTaskBuilder(MDCTaskBuilder taskBuilder) {
    _taskBuilder = taskBuilder;
  }

  void recordTargetPoints(List<Offset> targetPoints) {
    _targetPoints.addAll(targetPoints);
  }

  void _recordTrailLog(currentTargetIndex, selectionMoment, target) {
    _lastMovementDuration = (selectionMoment - _lastSelectionMoment) / 1000;
    if (currentTargetIndex > 0) {
      final log = trailLog(_trailID, _lastMovementDuration, target, _trailLogs);
      _trails.add(log);
      final log2 = trailLog(_trailID, _lastMovementDuration, target, _trailLogs,
          addPath: true);
      _trailsWithPath.add(log2);
      _trailID++;
    } else {
      final log = trailLog(_transitionID, _lastMovementDuration, target, _trailLogs);
      _transitions.add(log);
      final log2 = trailLog(_trailID, _lastMovementDuration, target, _trailLogs,
          addPath: true);
      _transitionsWithPath.add(log2);
      _transitionID++;
    }
    _trailLogs = List<Map>();
  }
  void _recordSelection(currentTargetIndex, selectionMoment, target) {
    final mode = _pointer.getLastFiredSelectionMode();
    final p = _pointer.getPosition();
    final log = selectionLog(_selectionID, selectionMoment, p, mode, target);
    _selections.add(log);
    _selectionID++;
    _targetID++;
  }

  void recordTrail(currentTargetIndex, {dwellTime}) {
    final selectionMoment = _now;
    final target = _targetPoints[_targetID]; // Target Index
    _recordTrailLog(currentTargetIndex, selectionMoment, target);
    _recordSelection(currentTargetIndex, selectionMoment, target);
    _lastSelectionMoment = selectionMoment;
//    print(toJsonBasic());
//    saveJsonFile();
//    print(jsonEncode(this));
  }

  void _recordIfMissedSelection(selectionMoment, position) {
    if (_pointer.pressingDown()) {
      final targetWidth = _taskBuilder.getTargetWidth().toDouble();
      final target = _targetPoints[_targetID]; // Target Index
      if (!_pointer.touches(target, targetWidth)) {
        final selectionMode = _pointer.getLastFiredSelectionMode();
        final log = selectionLog(_missedSelectionID, selectionMoment, position, selectionMode, target);
        _missedSelections.add(log);
        _missedSelectionID++;
      }
    }
  }

  void log(int now) {
    if (_paused) {
      _paused = false;
      _totalPauseDuration += _pauseDuration;
    }
    _now = now;
    _blockDuration = (_now - _startMoment) / 1000 - _totalPauseDuration;
    final pos = _pointer.getPosition();
    final log = pointerLog(pos, _now);
    _trailLogs.add(log);
    _recordIfMissedSelection(_now, pos);
  }
  void start(int now) {
    _now = now;
    _startMoment = _now;
    _lastSelectionMoment = _startMoment;
  }

  void keepPaused(int now) {
    _everPaused = true;
    if (!_paused) {
      _paused = true;
      _blockPauseMoment = now;
    }
    _now = now;
    _pauseDuration = (_now - _blockPauseMoment) / 1000;
  }

  String _doubleToPrettyString(double d, {int padding: 4, int frictions: 0}) {
    return d.toStringAsFixed(frictions).padLeft(padding, '0');
  }

  String getCurrentStatusToDisplay(int _testID) {
    final target = _targetID.toString().padLeft(2, '0');
    final count = _taskBuilder.getBlockTargetCount().toString().padLeft(2, '0');
    final duration = _doubleToPrettyString(_blockDuration, frictions: 1);
    return 'Test: $_testID B: $_blockID T: $target/$count D: $duration';
  }

  void completeBlock() {
    _completed = true;
  }

  bool isCompleted() => _completed;

  MDCTaskBuilder getTaskBuilder() => _taskBuilder;

  int getStartMoment() => _startMoment;

  double getLastMovementDuration() => _lastMovementDuration;

//  String getSummary() {
//    if (_trails.length == 0 || _transitions.length == 0)
//      return 'Nothing to show';
//    double d = 0;
//  }
}