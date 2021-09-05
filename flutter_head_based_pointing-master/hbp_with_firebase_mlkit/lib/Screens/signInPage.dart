import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          padding: EdgeInsets.only(top: 5, left: 10),
          color: Color.fromRGBO(13, 45, 132, 1),
          icon: Icon(Icons.arrow_back_ios, size: 40),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                '로그인',
                style: TextStyle(
                    fontSize: 30,
                    color: Color.fromRGBO(13, 45, 132, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cafe24Ssurround'
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, left: 30, right: 30),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '이메일',
                  prefixIcon: Icon(Icons.perm_identity),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '****',
                    prefixIcon: Icon(Icons.vpn_key),
                  ),
                )
            ),
            Container(
                padding: EdgeInsets.only(top: 30, left: 30, bottom: 30),
                child: SizedBox(
                    width: 350,
                    height: 45,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context,'/g');
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          primary: Color.fromRGBO(13, 45, 132, 1),
                          onPrimary: Colors.white,
                        ),
                        child:Text(
                          '로그인',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Cafe24Ssurround'
                          ),
                        )
                    )
                )
            )
          ],
        ),
      ),
    );
  }
}