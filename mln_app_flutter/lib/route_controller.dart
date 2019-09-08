import 'package:flutter/material.dart';
import 'package:mln_app_flutter/login_screen.dart';

const String LOGIN_ROUTE = "/";
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name){
      case LOGIN_ROUTE:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      default:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
  }
}