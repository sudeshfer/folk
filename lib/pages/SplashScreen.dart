//created by Suthura


import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:folk/pages/HomePage/Home.dart';
import 'package:folk/pages/LoginPage.dart';
import 'package:folk/pages/login&signup/location.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:folk/pages/welcomePage.dart';
import 'package:folk/utils/Constants.dart';
import 'dart:convert' as convert;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences prefs2;
  PermissionStatus _status;

  UserModel userModel;
  

  @override
  void initState() {
    super.initState();
    checkTheme();
     userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus);

    checkLoginStatus();

    // new Future.delayed(const Duration(milliseconds: 2500), () async {
    //   // Navigator.of(context).pushAndRemoveUntil(
    //   //     MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
    //   //     (Route<dynamic> route) => false);
    //     //check if email is save to start login if not Navigate to WelcomePage
       
    // });
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

  navigateToHome() async {
    if (_status == PermissionStatus.denied || _status== PermissionStatus.neverAskAgain || _status == PermissionStatus.disabled) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => GetLocation()));
    } else {
      print("location permission enabled !");
      print("initiate login  to go home !");
       SharedPreferences prefs = await SharedPreferences.getInstance();
        String email = prefs.getString('email');
        String fburl = prefs.getString('fburl');
        String phone = prefs.getString('phone');
        print(phone);
      
        if (email != null) {
          print(email);
          print("fblogin initiate started");
          startFbLogin(email,fburl);
        } else if(phone != null){
           print("otplogin initiate started");
           print(phone);
          startOtpLogin(phone);
        }
        else{
           Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (Route<dynamic> route) => false);
        }
    }
  }

  void startFbLogin(String email,String fburl) async {
    // check email and password if succ Move to Home if Not Move to WelcomePage
    var url = '${Constants.SERVER_URL}user/fblogin';

    try {
      var response = await http.post(
        url,
         body: {'email': email.toLowerCase(),'fb_url': fburl.toString()},
      );
      var jsonResponse = await convert.jsonDecode(response.body);
      bool error = jsonResponse['error'];

      if (error) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      } else {
         var userData = jsonResponse['data'];
         print(userData);
          UserModel myModel = UserModel.fromJson(userData);
        //make my model usable to all widgets
         Provider.of<AuthProvider>(context, listen: false).userModel = myModel;
         String categoryString = '';
          print("huttooooooooooooooooooooooooooooooooooooooooooo");

          if(myModel.userInterests[0].interestname != null){
                for (var i = 0; i < myModel.userInterests.length; i++) {
            // print(myModel.userInterests[i].interestname);

             if (categoryString == '') {
                        categoryString += myModel.userInterests[i].interestname;
                      } else {
                        categoryString +=
                            " - " + myModel.userInterests[i].interestname;
                      }
          }
          }

          print("cat string is = "+categoryString);
          Provider.of<AuthProvider>(context, listen: false)
            .updateCategoryString(categoryString);

         if (_status == PermissionStatus.denied || _status== PermissionStatus.neverAskAgain || _status == PermissionStatus.disabled) {
           print("going to location screen");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => GetLocation()));
       }else{
           print("going home");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Home()),
            (Route<dynamic> route) => false);
       }

          
      }
    } catch (err) {
      //case error (No internet connection) move to WelcomePage
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  void startOtpLogin(String phone) async {
    // check email and password if succ Move to Home if Not Move to WelcomePage
    var url = '${Constants.SERVER_URL}user/otplogin';

    try {
      var response = await http.post(
        url,
         body: {'phone': phone.toLowerCase()},
      );
      var jsonResponse = await convert.jsonDecode(response.body);
      bool error = jsonResponse['error'];

      if (error) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      } else {
         var userData = jsonResponse['data'];
          UserModel myModel = UserModel.fromJson(userData);
        //make my model usable to all widgets
         Provider.of<AuthProvider>(context, listen: false).userModel = myModel;
         String categoryString = '';
          print("huttooooooooooooooooooooooooooooooooooooooooooo");
 if(myModel.userInterests[0].interestname != null){
                for (var i = 0; i < myModel.userInterests.length; i++) {
            // print(myModel.userInterests[i].interestname);

             if (categoryString == '') {
                        categoryString += myModel.userInterests[i].interestname;
                      } else {
                        categoryString +=
                            " - " + myModel.userInterests[i].interestname;
                      }
          }
          }

          print("cat string is = "+categoryString);
          Provider.of<AuthProvider>(context, listen: false)
            .updateCategoryString(categoryString);
            
  if (_status == PermissionStatus.denied || _status== PermissionStatus.neverAskAgain || _status == PermissionStatus.disabled) {
           print("going to location screen");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => GetLocation()));
       }else{
           print("going home");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Home()),
            (Route<dynamic> route) => false);
       }
      }
    } catch (err) {
      //case error (No internet connection) move to WelcomePage
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  checkLoginStatus() async {
    prefs2 = await SharedPreferences.getInstance();
    if (prefs2.getString("token") == null) {
      final _token = prefs2.getString("token");
      print(_token);
      navigateToLogin();
    } else {
      prefs2 = await SharedPreferences.getInstance();
      final _token = prefs2.getString("token");
      print(_token);
      navigateToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    //splash screen deign
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 246, 250, 1),
      body: SafeArea(
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

  void checkTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool val = preferences.getBool('theme') ?? true;
    Provider.of<ThemeProvider>(context, listen: false).setThemeData = val;
  }
}
