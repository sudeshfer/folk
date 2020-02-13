import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:folk/Screens/Home_page/home_page.dart';
import 'dart:async';
import 'package:folk/Screens/Login/login_page.dart';
import 'package:folk/Utils/Animations/delayed_reveal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SharedPreferences prefs2;
  
  @override
  void initState() {

    checkLoginStatus();
    
    super.initState();
  }

  navigateToLogin(){
    Future.delayed(
      Duration(seconds: 3),
      () {
        // Navigator.pop(context);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>LoginPage()), (Route<dynamic> route) =>false);
      },
    );
  }

  navigateToHome(){
   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>Homepage()), (Route<dynamic> route) =>false);
    
  }
  checkLoginStatus() async {
    prefs2 = await SharedPreferences.getInstance();
    if(prefs2.getString("token") == null){
       navigateToLogin();
    }
    else{
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
