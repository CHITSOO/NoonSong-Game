import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 60, left: 15),
              child: Text(
                '회원가입',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Cafe24Ssurround',
                  color: Color.fromRGBO(13, 45, 132, 1),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                '이름',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    //labelText: '이름',
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                '아이디',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            /*Container(
              padding: EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: () {  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.black12,
                    onPrimary: Colors.black,
                  ),
                  child: Text(
                    '인증코드 보내기',
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                '이메일 인증코드',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Container(
                    child: SizedBox(
                      width: 250,
                      height: 45,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      width: 120,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {  },
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          primary: Colors.black12,
                          onPrimary: Colors.black,
                        ),
                        child: Text(
                          '인증코드 확인',
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),*/
            Container(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                '비밀번호',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: 45,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),Container(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                '비밀번호 확인',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: SizedBox(
                width: 370,
                height: 45,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      primary: Color.fromRGBO(13, 45, 132, 1),
                      onPrimary: Colors.white,
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Cafe24Ssurround'
                      ),
                    )
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 10, left: 20),
                child: SizedBox(
                    width: 370,
                    height: 45,
                    child: ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          primary: Colors.white,
                          onPrimary: Colors.black,
                        ),
                        child: Text(
                            ''
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