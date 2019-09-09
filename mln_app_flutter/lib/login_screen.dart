import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                flex: 2,
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
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(20),
        ),
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
              Padding(
                padding: EdgeInsets.only(left: 75, right: 75),
                child: Container(
                  color: Colors.black45,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: textController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '\tNhập số điện thoại',
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding: EdgeInsets.all(8)
                    ),
                  ),
                ),
              ),
              Text('Hello'),
              Padding(
                padding: EdgeInsets.only(left: 75, right: 75),
                child: Container(
                  color: Colors.black45,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: textController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: '\tNhập số điện thoại',
                        hintStyle: TextStyle(color: Colors.white),
                        contentPadding: EdgeInsets.all(8)
                    ),
                  ),
                ),
              ),
              Text('Hello'),
              Text('Hello'),
            ],
          )
      ),
    );
  }

  _handleTextController(){

  }
}