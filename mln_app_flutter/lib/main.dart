import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:mln_app_flutter/route_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mln_app_flutter/sms_auth_controller.dart';

class Utility {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FacebookLogin _facebookLogin = FacebookLogin();
//  static final LocalAuthentication _localAuth = LocalAuthentication();
  static String _verificationID;

  static Future<FirebaseUser> handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  static Future<bool> checkIsGoogleSignedIn() async {
    final FirebaseUser user = await _auth.currentUser();
    if(user != null) {
      print("Utility checkIsLoggedIn: true with user:" + user.toString());
      return true;
    }
    print("Utility checkIsLoggedIn: false");
    return false;
  }


  static Future<bool> handleFacebookLogin() async {
      final FacebookLoginResult facebookLoginResult = await _facebookLogin.logInWithReadPermissions(['email']);
      if(facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        print("Utility Facebook logged in true");
        return true;
      }
      print("Utility Facebook logged in false");
      return false;
  }

  static Future<bool> checkIsFacebookLoggedIn() async {
    final accessToken = await _facebookLogin.currentAccessToken;
    if (accessToken != null && accessToken.isValid()) {
      print("Utility checkIsFacebookLoggedIn: true with access token: $accessToken");
      return true;
    }
    print("Utility checkIsFacebookLoggedIn: false");
    return false;
  }

//  static Future<bool> checkIsSupportBiometric() async {
//    return await _localAuth.canCheckBiometrics;
//  }
//
//  static Future<bool> checkIsSupportFaceID() async {
//    if(await checkIsSupportBiometric() == true) {
//      final availableBiometric = await _localAuth.getAvailableBiometrics();
//      if(availableBiometric.contains(BiometricType.face))
//        return true;
//    }
//    return false;
//  }
//
//  static Future<bool> checkIsSupportFingerPrint() async {
//    if(await checkIsSupportBiometric() == true) {
//      final availableBiometric = await _localAuth.getAvailableBiometrics();
//      if(availableBiometric.contains(BiometricType.fingerprint))
//        return true;
//    }
//    return false;
//  }

  static Future<void> sendCodeToPhoneNumber(String phoneNumber, ScaffoldState scaffoldState) async {
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
    };
    final PhoneVerificationFailed verificationFailed = (AuthException authException) {
      print("SMS phone verification is failed with code: ${authException.code} -- message: ${authException.message}");
    };
    final PhoneCodeSent phoneCodeSent = (String verificationID, [int forceResendingToken]) async {
      scaffoldState.showSnackBar(
        SnackBar(
          content: Text('Vui lòng kiểm tra mã xác nhận từ tin nhắn điện thoại')
        )
      );
      _verificationID = verificationID;
    };
    PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout = (String verificationID) {
      _verificationID = verificationID;
    };
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 180),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout
    );
  }

  static Future<FirebaseUser> handlePhoneSMSSignIn(String verificationCode) async {
    final AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationID,
        smsCode: verificationCode,
    );
    final FirebaseUser smsUser = (await _auth.signInWithCredential(authCredential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(smsUser.uid == currentUser.uid);
    return smsUser;
  }

  static Future<bool> checkIsLoggedIn() async {
    var isDone = await checkIsGoogleSignedIn();
    if(isDone)
      return true;
    isDone = await checkIsFacebookLoggedIn();
    if(isDone)
      return true;
    return false;
  }
}

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: Router.generateRoute,
      initialRoute: LOGIN_ROUTE,
    );
  }
}