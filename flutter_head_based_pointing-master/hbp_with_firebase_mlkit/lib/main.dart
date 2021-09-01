import 'package:HeadPointing/Demo/DemoScreen.dart';
import 'package:HeadPointing/CameraHandler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'dart:ui' as ui;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Remove the back/home/etc. buttons at the bottom of the screen
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: FirstRoute(),
    );
  }
}

class FirstRoute extends StatefulWidget {

  @override
  _FirstRouteState createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {

  ui.Image image;

  @override
  void initState() {
    super.initState();

    loadImage('assets/image.gif');
  }

  Future loadImage(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);

    setState(() => this.image = image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyMainView(
                title: 'Head-based Pointing with Flutter',
                image: image,)),
            );
          },
        ),
      ),
    );
  }
}

class MyMainView extends StatefulWidget {
  MyMainView({Key key, this.title, this.image}) : super(key: key);
  final String title;
  final ui.Image image;

  @override
  MyMainViewState createState() => MyMainViewState(image: image);
}

enum MODE { DEBUG, RELEASE }

enum Answers { YES, NO }

enum AppState { welcome, configure, test, demo }

class MyMainViewState extends State<MyMainView> {
  CameraHandler _cameraHandler;
  DemoScreen _demoScreen;
  final ui.Image image;

  MyMainViewState({this.image});

  void setStateForImageStreaming(dynamic result) {
    setState(() {
      //_taskScreen.updateInput(result, context: context);
      _demoScreen.updateInput(result, context: context);
    });
  }

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    _cameraHandler = CameraHandler(this);
    _demoScreen = DemoScreen(_cameraHandler, image ,context: context);
//    setTaskScreenConfiguration();
  }

  AppBar getAppBar() {
    return AppBar(
      title: Text('Head Pointing Demo'),
    );
  }

  Widget _buildMainView() {
    return Container(
        constraints: const BoxConstraints.expand(),
        child: _demoScreen.getDemoScreenView());
  }

  FloatingActionButton addFloatingActionButton() { //안씀
    Icon icon = const Icon(Icons.camera_front);
    if (_cameraHandler.isBackCamera()) icon = const Icon(Icons.camera_rear);
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
        child: _buildMainView(),
      ),
            floatingActionButton: addFloatingActionButton(),
    );
  }
}
