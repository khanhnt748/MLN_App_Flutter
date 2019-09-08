import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(SplashScreen());

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splash_screen.jpg"),
            fit: BoxFit.cover,
          )
        ),
        child: Container(
          padding:EdgeInsets.all(50),
          child: SvgPicture.asset("assets/milano_logo.svg"),
        ),
      ),
    );
  }
}
