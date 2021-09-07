import 'package:NoonSongGame/MDCTaskHandler/TaskScreen.dart';
import 'package:NoonSongGame/CameraHandler.dart';
import 'package:NoonSongGame/MDCTaskHandler/ConfigScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Remove the back/home/etc. buttons at the bottom of the screen
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyMainTestView(title: 'Head-based Pointing with Flutter'),
    );
  }
}

class MyMainTestView extends StatefulWidget {
  MyMainTestView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyMainTestViewState createState() => MyMainTestViewState();
}
enum MODE {
  DEBUG,
  RELEASE
}

enum Answers{
  YES,
  NO
}

enum AppState {
  welcome,
  configure,
  test
}

class MyMainTestViewState extends State<MyMainTestView> {
  AppState _state = AppState.welcome;
  MODE _runningMode = MODE.RELEASE;
  CameraHandler _cameraHandler;
  ConfigScreen _configScreen;
  TaskScreen _taskScreen;
  String _experimentID;
  String _subjectID;

  void setStateForImageStreaming(dynamic result)  {
    setState(() {_taskScreen.updateInput(result, context: context); });
  }

  Future setTaskScreenConfiguration() async {
    final config = _configScreen.getFinalConfiguration();
    if (config != null)
      _taskScreen.setConfiguration(config);
  }

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    _configScreen = ConfigScreen(context: context);
    _cameraHandler = CameraHandler(this);
    _taskScreen = TaskScreen(_cameraHandler, _experimentID, _subjectID,
        exitAction: _setAppStateWelcome, context: context);
//    setTaskScreenConfiguration();
  }

  void _setAppStateWelcome()  async {
    if (await _taskScreen.getCurrentTest().isUserSure()) {
      _state = AppState.welcome;
      _configScreen.reset();
      _experimentID = null;
      _subjectID = null;
      _taskScreen = TaskScreen(
          _cameraHandler, _experimentID, _subjectID, exitAction:
      _setAppStateWelcome, context: context);
    }
  }

  Future _setAppStateConfigure() async {
//    await _configScreen.loadLastConfigurations();
    _state = AppState.configure;
  }

  String getUniqueExperimentID() {
    String date = new DateTime.now().toIso8601String().replaceAll(':', '-');
    date = date.split('.').first;
    if (_runningMode == MODE.DEBUG)
      date = date.split('T').last;
    return 'EXP_$date';
  }

  void addExperimentDocumentData(String path, Map<String, dynamic> data) {
    CollectionReference exp = Firestore.instance.collection(_experimentID);
    exp.document(path).setData(data);
  }

  Future<String> getSubjectID() async {
    String id;
    return await showDialog(
        context: context,
        builder: (_) => new SimpleDialog(
          title: Row(
            children: <Widget>[
              Container(width: 80, child: Text('Enter Subject ID:')),
              Container(
                  width: 80,
                  child: TextField(
                    onChanged: (e){id = e;},
                    onSubmitted: (e){id = e;},
                  )
              )
            ],
          ),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text('OK'),
              onPressed: (){Navigator.pop(context, id);},
            ),
          ],
        )
    );
  }

  Future _startSavingLogsIfWanted() async {
    _experimentID = getUniqueExperimentID();
    final subjectID = await getSubjectID();
    if (subjectID != null)
      if (subjectID.length > 0) {
        _subjectID = subjectID;
        _experimentID = '$_experimentID-$_subjectID';
      }
    Firestore.instance.document(_experimentID);
    addExperimentDocumentData('IDs', {'ID': _experimentID,
      'SubjectID': _subjectID});
    final configs = _configScreen.getFinalConfiguration();
    addExperimentDocumentData('TestConfigurations', {'List': configs});
    print('Starting $_experimentID');
  }

  Future _setAppStateTesting() async {
    await _startSavingLogsIfWanted();
    _state = AppState.test;
    _taskScreen = TaskScreen(_cameraHandler, _experimentID, _subjectID,
        exitAction: _setAppStateWelcome, context: context);
    _taskScreen.startStudyScreen();
    setTaskScreenConfiguration();
  }

  RaisedButton _getAppBarButton(String text, Function onPressed, Color color) {
    return RaisedButton(
      elevation: 4.0,
      color: color,
      textColor: Colors.white,
      child: Text(text),
      splashColor: Colors.blueGrey,
      onPressed: onPressed,
    );
  }

  List<Widget> _getAppBarButtonList() {
    return <Widget>[
      _getAppBarButton('Edit\nTests', _setAppStateConfigure, Colors.purpleAccent),
      _getAppBarButton('Start', _setAppStateTesting, Colors.purple),
    ];
  }

  AppBar getAppBar() {
    RaisedButton backButton = _getAppBarButton('Back', _setAppStateWelcome,
        Colors.red);
    switch(_state) {
      case AppState.configure:
        return _configScreen.getAppBar(backButton);
      case AppState.test:
        return _taskScreen.getAppBar();
      case AppState.welcome:
      default:
        return  AppBar(
          title: Text('Head Pointing Test'),
          actions: _getAppBarButtonList(),
        );
    }
  }

  Widget _buildMainView() {
    if (_taskScreen.isStudyCompleted())
      _setAppStateWelcome();
    Widget child;
    if (_cameraHandler.isCameraNull())
      child = _cameraHandler.getCameraInitializationView();
    else {
      switch(_state) {
        case AppState.configure:
          child = _configScreen.getConfigsScreenView();
          break;
        case AppState.test:
        case AppState.welcome:
        default:
          child = _taskScreen.getTaskScreenView();
          break;
      }
    }
    return Container(constraints: const BoxConstraints.expand(), child: child);
  }

  FloatingActionButton addFloatingActionButton() {
    Icon icon = const Icon(Icons.camera_front);
    if (_cameraHandler.isBackCamera())
      icon = const Icon(Icons.camera_rear);
    return FloatingActionButton(
      onPressed: _cameraHandler.toggleCameraDirection,
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Center(
        child:  _buildMainView(),
      ),
      //      floatingActionButton: _addFloatingActionButton(),
    );
  }
}