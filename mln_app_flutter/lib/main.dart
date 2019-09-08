import 'package:flutter/material.dart';
import 'package:mln_app_flutter/route_controller.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application',
      onGenerateRoute: Router.generateRoute,
      initialRoute: LOGIN_ROUTE,
    );
  }
}