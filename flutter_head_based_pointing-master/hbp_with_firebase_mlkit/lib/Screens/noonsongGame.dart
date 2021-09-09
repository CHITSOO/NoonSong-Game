import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:NoonSongGame/Demo/DemoScreen.dart';
import 'package:NoonSongGame/CameraHandler.dart';
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
        home: GameStart());
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
        title: Text('게임 방법',
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 2.0,
              fontSize: 26.0,
              fontFamily: 'Cafe24SsurroundAir',
              fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          padding: EdgeInsets.only(top: 5, left: 10),
          color: Colors.white,
          icon: Icon(Icons.arrow_back_ios, size: 40),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromRGBO(13, 45, 132, 1),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '원을 움직여 눈송이를 맞춰라!',
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontSize: 26.0,
                    fontFamily: 'Cafe24SsurroundAir',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              SizedBox(
                  height: 400,
                  width: 400,
                  child: Image.asset('assets/game.gif')),
              SizedBox(height: 30),
              Text(
                '얼굴 방향에 따라 원이 움직여요',
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontSize: 26.0,
                    fontFamily: 'Cafe24SsurroundAir',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 43),
              SizedBox(
                width: 300.0,
                //height: 40,
                child: new RaisedButton(
                  child: Text(
                    '게임 시작',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontSize: 19.0,
                        fontFamily: 'Cafe24SsurroundAir',
                        fontWeight: FontWeight.bold),
                  ),
                  color: Colors.green,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyMainView(
                            title: 'Head-based Pointing NoonSong Game',
                            image: image,
                          ),
                        ));
                  },
                ),
              ),
              SizedBox(height: 62),
            ]),
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
    _demoScreen = DemoScreen(_cameraHandler, image, context: context);
//    setTaskScreenConfiguration();
  }

  AppBar getAppBar() {
    return AppBar(
      title: Text(
        "눈송 게임",
        style: TextStyle(
            color: Colors.white,
            letterSpacing: 2.0,
            fontSize: 26.0,
            fontFamily: 'Cafe24SsurroundAir',
            fontWeight: FontWeight.bold),
      ),
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
    if (_cameraHandler.isBackCamera())
      icon = const Icon(
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
