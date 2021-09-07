import 'package:NoonSongGame/Screens/noonsongGame.dart';
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
