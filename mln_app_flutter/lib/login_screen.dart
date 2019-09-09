import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:mln_app_flutter/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoadingDone = false;
  final textController = TextEditingController();
  @override
  void initState() {
    textController.addListener(_handleTextController);
    super.initState();
  }
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      setState(() {
        isLoadingDone = true;
      });
    });
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/splash_screen.jpg"),
                fit: BoxFit.cover,
              )
          ),
          child:Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Center(
                  child: Image.asset("assets/milano_logo.png"),
                ),
              ),
              isLoadingDone ? Expanded(
                flex: 1,
                child: Container(),
              ) : Container(),
              isLoadingDone ? _buildLoginForm() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm () {
    return Expanded(
      flex: 6,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 75, right: 75),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: textController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Nhập số điện thoại',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.arrow_forward_ios)
                    ),
                  ),
                ),
                Text('Hoặc đăng nhập qua mạng xã hội'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: FlatButton.icon(
                          onPressed: () => Utility.handleSignIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e)),
//                          onPressed: null,
                          color: Colors.blue,
                          icon: Icon(Icons.error),
                          label: Text('Facebook'),
                      ),
                    ),
                    Container(
                      height: 45,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: FlatButton.icon(
                          onPressed: () => Utility.handleSignIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e)),
//                          onPressed: null,
                          color: Colors.red,
                          icon: Icon(Icons.error),
                          label: Text('Google')
                      ),
                    ),
                  ],
                ),
                Text('Hello'),
              ],
            ),
        )
      ),
    );
  }

  _handleTextController(){

  }
}