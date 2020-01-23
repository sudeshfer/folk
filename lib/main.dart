import 'package:flutter/material.dart';
import 'package:folk/Screens/Login/login_page.dart';
import 'package:folk/Screens/Login/phone_login.dart';
import 'package:folk/Screens/Login/forgotPassword.dart';
import 'package:folk/Screens/Login/resetPassword.dart';
import 'package:folk/Screens/Login/pincode_verify.dart';
import 'package:folk/Screens/Login/setup_step1.dart';
import 'package:folk/Screens/Login/setup_step2.dart';
import 'package:folk/Screens/Login/location.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Folk',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new GetLocation(),
      routes: <String, WidgetBuilder>{
        // login and resgistration routes
        "/login":(BuildContext context) => new LoginPage(),
        "/phonelogin":(BuildContext context) => new PhoneLogin(),
        "/forgotpw":(BuildContext context) => new ForgotPassword(),
        "/resetpw":(BuildContext context) => new ResetPassword(),
        "/pincode":(BuildContext context) => new PincodeVerify(),
        "/setupstep1":(BuildContext context) => new SetupStepOne(),
        "/setupstep2":(BuildContext context) => new SetupStepTwo(),



      },


    );
  }
}

