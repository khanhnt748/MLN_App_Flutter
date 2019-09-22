import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpinView {
  @required BuildContext context;
  @required int numSpin;

  SpinView({
    this.context,
    this.numSpin
  });

  Widget build() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        this.numSpin,
          (index) {
            return Container(
              width: 25,
              child: Row(
                children: <Widget>[
                  TextField(
                    onChanged: (value) {

                    },
                  ),
                  SizedBox(width: 5,),
                  index == (numSpin - 1) ? Container() : Text(
                      "➖"
                  )
                ],
              ),
            );
        }
      )
    );
  }
}