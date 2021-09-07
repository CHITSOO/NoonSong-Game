import 'package:HeadPointing/Screens/homeScreen.dart';
import 'package:HeadPointing/Screens/noonsongGame.dart';
import 'package:HeadPointing/Screens/signInPage.dart';
import 'package:HeadPointing/Screens/signUpPage.dart';
import 'package:HeadPointing/Screens/splashScreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(
    MaterialApp(
      title: 'NoonSong Game',
      debugShowCheckedModeBanner: false,
      //home: SignInPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => NoonsongGame(),
      },
    )
);
