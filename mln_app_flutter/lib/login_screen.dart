import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:mln_app_flutter/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:mln_app_flutter/route_controller.dart';

import 'package:mln_app_flutter/sms_auth_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = true;
  final textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    textController.addListener(_handleTextController);
    Timer(Duration(seconds: 5), () => _checkAuthorizeStatus());
  }
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                flex: 4,
                child: Center(
                  child: Image.asset("assets/milano_logo.png"),
                ),
              ),
              isLoading ? Container() : Expanded(
                flex: 1,
                child: Container(),
              ),
              isLoading ? Container() : _buildLoginForm() ,
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
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: textController,
                    validator: (value) {
                      if (!value.isEmpty) {
//                        if(!value.startsWith('0'))
//                          return "Vui lòng nhập đầu số hợp lệ";
                        if(value.length != 9){
                          return "Độ dài số điện thoại chưa hợp lệ";
                        }
                      }
                      return null;
                    },
                    onChanged: (phoneNumber) {
                      if(_formKey.currentState.validate()) {
                        print("OnChanged");
                      }
                    },
                    onFieldSubmitted: (phoneNumber) {
                     if(_formKey.currentState.validate()) {
                       print("OnSubmited!!");
                     }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Nhập số điện thoại',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          if(_formKey.currentState.validate()) {
                            SMSAuthViaFirebase.handleSMSSignIn(
                              context: this.context,
                              phoneNumber: textController.text,
                            );
                            print("OnPressed!!");
                          }
                        }
                      )
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
                      onTap: _handleFacebookLogin,
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
                      onTap: _handleGoogleSignIn,
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
  
  _checkAuthorizeStatus() {
    print("_checkAuthorizeStatus!!!");
    Utility.checkIsLoggedIn().then((value) {
      if(value) {
        Navigator.pushReplacementNamed(context, MAIN_ROUTE);
        return;
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  _handleTextController() {

  }

  _handleGoogleSignIn() {
    Utility.handleGoogleSignIn().then((FirebaseUser user) {
      if(user != null) {
        Navigator.pushReplacementNamed(context, MAIN_ROUTE);
      }
    }).catchError((e) => print(e));
  }

  _handleFacebookLogin() {
    Utility.handleFacebookLogin().then((bool result){
      print("Current facebook result: $result");
      if (result == true) {
        Navigator.pushReplacementNamed(context, MAIN_ROUTE);
      }
    }).catchError((e) => print(e));
  }
}