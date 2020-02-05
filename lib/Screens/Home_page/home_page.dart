import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Homepage extends StatefulWidget {
  final String phone;
  final int newotp;
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  final loginType;
  final loginStatus;
  Homepage({Key key,this.phone,
      this.newotp,
      this.fbId,
      this.fbName,
      this.fbEmail,
      this.fbPicUrl,
      this.loginType,
      this.loginStatus}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  
  Future<bool> _onBackPressed() {
    return AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            // customHeader: Image.asset("assets/images/macha.gif"),
            animType: AnimType.TOPSLIDE,
            btnOkText: "yes",
            btnCancelText: "Hell No..",
            tittle: 'Are you sure ?',
            desc: 'Do you want to exit an App',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              exit(0);
            }).show() ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
          child: Scaffold(
         body: Container(
           child: Center(
             child: Text("Welcome to home page"),
           ),
         ),
      ),
    );
  }
}