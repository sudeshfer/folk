import 'dart:developer';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:folk/Screens/Home_page/home_page.dart';
import 'package:folk/Screens/Login/location.dart';
import 'package:folk/Screens/Login/login_page.dart';
import 'package:folk/Utils/Animations/delayed_reveal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences prefs2;
  PermissionStatus _status;

  @override
  void initState() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus);

    checkLoginStatus();

    super.initState();
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      _status = status;
      print(_status);
    }
  }

  navigateToLogin() {
    Future.delayed(
      Duration(seconds: 3),
      () {
        // Navigator.pop(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      },
    );
  }

  navigateToHome() {
    if (_status == PermissionStatus.denied || _status== PermissionStatus.neverAskAgain) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => GetLocation()));
    } else {
      print("location permission enabled !");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Homepage()),
          (Route<dynamic> route) => false);
    }
  }

  checkLoginStatus() async {
    prefs2 = await SharedPreferences.getInstance();
    if (prefs2.getString("token") == null) {
      navigateToLogin();
    } else {
      prefs2 = await SharedPreferences.getInstance();
      final _token = prefs2.getString("token");
      log(_token);
      navigateToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 246, 250, 1),
      body: DelayedReveal(
        delay: Duration(milliseconds: 1200),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 280,
            height: 280,
          ),
        ),
      ),
    );
  }
}
