import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:mln_app_flutter/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mln_app_flutter/route_controller.dart';

void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoadingDone = false;
  bool isEnableLoginForm = false;
  final textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    textController.addListener(_handleTextController);
    Timer(Duration(seconds: 5), () async {
      bool isLoggedIn = await Utility.checkIsLoggedIn();
      isLoadingDone = true;
      setState(() {
        isEnableLoginForm = !isLoggedIn;
      });
    });
  }
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: Router.generateRoute,
      initialRoute: _checkIsNeedRedirectToNextPage() ? MAIN_ROUTE : LOGIN_ROUTE,
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
                flex: 4,
                child: Center(
                  child: Image.asset("assets/milano_logo.png"),
                ),
              ),
              isEnableLoginForm ? Expanded(
                flex: 1,
                child: Container(),
              ) : Container(),
              isEnableLoginForm ? _buildLoginForm() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm () {
    return Expanded(
      flex: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 50, right: 50),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    style: TextStyle(color: Colors.black54),
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
                Text(
                  'Hoặc đăng nhập qua mạng xã hội',
                  style: TextStyle(fontSize: 17),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        height: 40,
                        width: 120,
                        color: Color.fromRGBO(60, 90, 152, 1.0),
                        child: Center(
                          child: Text(
                            'Facebook',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Utility.handleSignIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e)),
                      child: Container(
                        height: 40,
                        width: 120,
                        color: Color.fromRGBO(219, 68, 55, 1.0),
                        child: Center(
                          child: Text(
                            'Google',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  child: ClipOval(
                    child: Container(
                      width: 75,
                      height: 75,
                      color: Colors.black12,
                      child: Image.asset("assets/faceid_icon.png"),
                    ),
                  ),
                ),
                Text('Đăng nhập bằng Face ID')
              ],
            ),
        )
      ),
    );
  }

  _checkIsNeedRedirectToNextPage() => isLoadingDone && !isEnableLoginForm;

  _handleTextController(){

  }
}