import 'package:flutter/material.dart';
import 'package:mln_app_flutter/login_screen.dart';
import 'package:mln_app_flutter/main_screen.dart';

const String LOGIN_ROUTE = "/";
const String MAIN_ROUTE = "/main";
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name){
      case LOGIN_ROUTE:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case MAIN_ROUTE:
        return MaterialPageRoute(builder: (_) => MainScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}