import 'package:flutter/material.dart';
import 'dart:async';
import 'package:folk/Screens/Login/login_page.dart';
import 'package:folk/Utils/Animations/delayed_reveal.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),
        ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 246, 250, 1),
      body: DelayedReveal(
        delay: Duration(milliseconds: 1200),
              child: Center(
          child: Image.asset('assets/images/logo.png',width: 280,height: 280,),
        ),
      ),

      // body: Center(
      //   child: Container(
      //     height: 300,
      //     width: 300,
      //     decoration: BoxDecoration(
      //       image:DecorationImage(
      //         image:AssetImage('assets/images/sent.gif'),
      //         fit: BoxFit.cover
      //       )
      //     ),
      //   ),
      // ),
    );
  }
}