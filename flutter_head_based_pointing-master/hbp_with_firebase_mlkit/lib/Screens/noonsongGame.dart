import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:HeadPointing/Demo/DemoScreen.dart';
import 'package:HeadPointing/CameraHandler.dart';
import 'dart:ui' as ui;

class NoonsongGame extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(13, 45, 132, 1),
        ),
        home: GameStart()
    );
  }
}

class GameStart extends StatefulWidget {

  @override
  _GameStartState createState() => _GameStartState();
}

class _GameStartState extends State<GameStart> {
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
        title: Text('메뉴'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('게임 시작'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyMainView(
                  title: 'Head-based Pointing NoonSong Game',
                  image: image,),
                )
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
      title: Text("얼굴  인식  눈송이  맞추기  게임",
        style: TextStyle(
            color: Colors.white,
            fontSize: 19.0,
            fontFamily: "WandocleanseaR"
        ),),
      centerTitle: true,
    );
  }

  Widget _buildMainView() {
    return Container(
        constraints: const BoxConstraints.expand(),
        child: _demoScreen.getDemoScreenView());
  }

  FloatingActionButton addFloatingActionButton() {
    Icon icon = const Icon(
      Icons.flip_camera_ios,
      color: Color.fromRGBO(13, 45, 132, 1),
    );
    if (_cameraHandler.isBackCamera()) icon = const Icon(
      Icons.flip_camera_ios,
      color: Color.fromRGBO(13, 45, 132, 1),
    );
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
