import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mln_app_flutter/support_ui/SpinView.dart';

class SMSAuthViaFirebase {
  @required final BuildContext context;
  String countryCode;
  @required String phoneNumber;
  String verificationID;
  Duration timeoutDuration;
  SMSAuthViaFirebase({
    this.context,
    this.phoneNumber,
    this.verificationID,
    this.timeoutDuration = const Duration(seconds: 60),
  });
  static Future<FirebaseUser> handleSMSSignIn({
        BuildContext context,
        String phoneNumber,
        countryCode = "+84",
        timeoutDuration = const Duration(seconds: 60),
    }) async {
    final TAG = "SMS Auth -- ";
    Future<FirebaseUser> user;
    String verificationID;
    final PhoneCodeSent codeSent = (String vertificationID, [int forceResendingToken]) async {
      verificationID = vertificationID;
      showInputSMSCodeDialog(context);
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String vertificationID) {
      verificationID = vertificationID;
      print(TAG + "time out");
    };
    final PhoneVerificationFailed verificationFailed = (AuthException authException) {
      print(TAG + "phone number verification is failed with exception: "
          "code[${authException.code}] -- message[${authException.message}]");
    };
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential authCredential) {
      print(TAG + "phone number verification is successed with authCredential $authCredential");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode + phoneNumber,
      timeout: timeoutDuration,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
    );
    return user;
  }

  Future<FirebaseUser> authorizeWithSMS(inputCode) async {
    final AuthCredential authCredential = PhoneAuthProvider
        .getCredential(
          verificationId: this.verificationID,
          smsCode: inputCode
        );
    final FirebaseUser smsUser = (await FirebaseAuth.instance
        .signInWithCredential(authCredential))
        .user;
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(smsUser.uid == currentUser.uid);
    return smsUser;
  }

  static showInputSMSCodeDialog(BuildContext context) {
    final dialogWidth = MediaQuery.of(context).size.width - 100;
    final dialogHeigth = dialogWidth * 2 / 5; /// width = height * 2.5
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Verify SMS Code"),
          content: Container(
            width: dialogWidth,
            height: dialogHeigth,
            child: Column(
              children: <Widget>[
                Text(" Please input SMS code:"),
                TextFormField(
                  onChanged: (value) {

                  },
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            )
          ],
        );
      }
    );
  }
}