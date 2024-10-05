import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_qr/view/auth/auth_phone/quickmainscreen.dart';

import 'view/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 3));

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => QuickMainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Container(
            child: Image.asset(
              'images/ic_launcher.gif',
              width: 250,
              height: 250,
            ),
          ),
          Positioned(
              top: 100,
              left: 110,
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              )),
        ]),
      ),
    );
  }
}
