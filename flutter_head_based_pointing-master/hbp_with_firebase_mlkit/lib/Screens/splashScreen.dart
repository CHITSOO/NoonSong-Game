import 'package:HeadPointing/main.dart';
import 'package:flutter/material.dart';
import 'package:HeadPointing/Screens/homeScreen.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: '/h',
      title: Text(
        "Noonsong App",
        style: TextStyle(
          fontSize: 45,
          color: Color.fromRGBO(13, 45, 132, 1),
          fontFamily: "WandocleanseaB",
        ),
      ),
      image: Image.asset("images/character_new30.png"),
      backgroundColor: Colors.white,
      photoSize: 140,
      loaderColor: Color.fromRGBO(13, 45, 132, 1),
      loadingText: Text(
        "from SeosongJisongHwangsong",
        style: TextStyle(
            color: Color.fromRGBO(13, 45, 132, 1),
            fontSize: 16.0,
            fontFamily: "WandocleanseaR"
        ),
      ),
    );
  }
}