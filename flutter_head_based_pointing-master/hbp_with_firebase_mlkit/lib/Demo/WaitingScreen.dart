import 'package:flutter/material.dart';

class waitingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(13, 45, 132, 1),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/loading.gif')),
              SizedBox(height: 200),
              Text(
                'Loading ..',
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 2.0,
                    fontSize: 26.0,
                    fontFamily: 'Cafe24SsurroundAir',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
            ]),
      ),
    );
  }
}
