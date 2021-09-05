import 'package:flutter/material.dart';

class NoonsongHomepage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 150),
                child: Text(
                  'NoonSong App',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cafe24Ssurround",
                    color: Color.fromRGBO(13, 45, 132, 1),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 40),
                child: Image.asset(
                    'images/character_new40.png',
                    width: 250,
                    height: 250
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  height: 40,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context,'/i');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(13, 45, 132, 1),
                      onPrimary: Colors.white,
                    ),
                    child: Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Cafe24Ssurround",
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 40),
                child: SizedBox(
                  height: 40,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context,'/u');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Cafe24Ssurround",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}