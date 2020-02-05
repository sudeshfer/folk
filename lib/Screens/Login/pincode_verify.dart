import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folk/Controllers/OTP.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:folk/Screens/Login/setup_step1.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:folk/Utils/Login_utils/loading_dialogs.dart';
import 'package:folk/Utils/Login_utils/pin_code_fields.dart';

FlutterOtp otp = FlutterOtp();
String result;
int enteredOtp;

class PincodeVerify extends StatefulWidget {
  final String phone;
  final int newotp;
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  final loginType;
  final loginStatus;
  // PincodeVerify({Key key}) : super(key: key);
  PincodeVerify(
      {this.phone,
      this.newotp,
      this.fbId,
      this.fbName,
      this.fbEmail,
      this.fbPicUrl,
      this.loginType,
      this.loginStatus});
  @override
  _PincodeVerifyState createState() => _PincodeVerifyState();
}

class _PincodeVerifyState extends State<PincodeVerify> {
  @override
  void initState() {
    setState(() {
      // _errorTxt = "";
    });
    // print(widget.fbId +
    //     "\n" +
    //     widget.fbName +
    //     "\n" +
    //     widget.fbEmail +
    //     "\n" +
    //     widget.fbPicUrl +
    //     "\n" +
    //     widget.phone);
    super.initState();
  }

  // navigateToHome() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => SettingUpScreen(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    log("OTP sent");

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.black,
                    iconSize: 38,
                    onPressed: () {
                      log('Clikced on back btn');
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                alignment: Alignment.centerLeft,
              ),
              SizedBox(height: 12),
              FadeAnimation(
                0.8,
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Enter the code',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              FadeAnimation(
                0.9,
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                  child: RichText(
                    text: TextSpan(
                        text: "A verification code has been sent to ",
                        children: [
                          TextSpan(
                              text: widget.phone,
                              style: TextStyle(
                                  color: Color(0xFFf45d27),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ],
                        style: TextStyle(color: Colors.black54, fontSize: 18)),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FadeAnimation(
                1,
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 7.0, horizontal: 25),
                    child: PinCodeTextField(
                      length: 4,
                      obsecureText: false,
                      shape: PinCodeFieldShape.box,
                      fieldHeight: 57,
                      backgroundColor: Colors.white,
                      fieldWidth: 67,
                      onCompleted: (v) {
                        print("Completed");
                      },
                      onChanged: (val) {
                        enteredOtp = int.parse(val);
                      },
                    )),
              ),
              InkWell(
                onTap: () {
                  if (widget.newotp != enteredOtp) {
                        final login_type = widget.loginType;
                        final login_status = widget.loginStatus;

                        if (login_type == "otp" && login_status == "otpolduser") 
                        {
                          log("otp old user // has otp login // should go to home");
                          navigateToVerifyingScreen();

                        } 
                        else if (login_type == "otp" && login_status == "otpnewuser") {
                          log("otp new user // no otp login // should go to stepOne ");
                          navigateToStepOne();

                        } 
                        else if (login_type == "fb" && login_status == "fbnewuserOtpOld") {
                          log("fb new user // has otp login // should go to home ");
                          navigateToHome();

                        } 
                        else if (login_type == "fb" && login_status == "fbnewuserOtpNew") {
                          log("fb new user // no otp login // should go to stepOne ");
                          navigateToStepOne();
                        } 
                        else
                        {
                          log("somehting went wrong");
                        }
                  } 
                  else 
                  {
                    showAlert(
                      context: context,
                      title: "Empty or Invalid OTP",
                    );
                    log("Invalid OTP");
                  }
                  // final _phone = widget.phone;
                  //   final _fbId = widget.fbId;
                  //   final _fbName = widget.fbName;
                  //   final _fbEmail = widget.fbEmail;
                  //   final _fbPicUrl = widget.fbPicUrl;
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => SetupStepOne(
                  //             phone: _phone,
                  //             fbId: _fbId,
                  //             fbName: _fbName,
                  //             fbEmail: _fbEmail,
                  //             fbPicUrl: _fbPicUrl,
                  //             loginType: widget.loginType,
                  //           )));
                  // if (widget.newotp == enteredOtp) {
                  //   final _phone = widget.phone;
                  //   final _fbId = widget.fbId;
                  //   final _fbName = widget.fbName;
                  //   final _fbEmail = widget.fbEmail;
                  //   final _fbPicUrl = widget.fbPicUrl;
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => SetupStepOne(
                  //             phone: _phone,
                  //             fbId: _fbId,
                  //             fbName: _fbName,
                  //             fbEmail: _fbEmail,
                  //             fbPicUrl: _fbPicUrl,
                  //           )));
                  // } else {
                  //   showAlert(
                  //     context: context,
                  //     title: "Empty or Invalid OTP",
                  //   );
                  //   log("Invalid OTP");
                  // }
                },
                child: FadeAnimation(
                  1.2,
                  Container(
                    padding: EdgeInsets.only(top: 32),
                    child: Center(
                      child: Container(
                        height: 51,
                        width: MediaQuery.of(context).size.width / 1.12,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF6038), Color(0xFFFF9006)],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Text(
                            'Continue'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(top: 30),
              ),
              FadeAnimation(
                1.4,
                InkWell(
                  onTap: () {
                    log('Clikced on back btn');
                    Navigator.of(context).pop();
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "I didn't get a code",
                        style: TextStyle(
                            color: Color(0xFFf45d27),
                            fontSize: 17.5,
                            fontFamily: 'Montserrat'),
                        children: [
                          TextSpan(
                              text:
                                  " \n Tap Continue to accept Facebook's Terms",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontFamily: 'Montserrat'))
                        ]),
                  ),
                ),
              ),
              SizedBox(
                height: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> navigateToHome() {
    return showDialog(
      builder: (context) => CupertinoAlertDialog(
        title: Text('You already have an account with this number !'),
        content: Column(
          children: <Widget>[
            Text("click ok to veify & sign in !"),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            color: Colors.orange,
            onPressed: () {
              navigateToVerifyingScreen();
            },
            child: Text('OK',
                style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold
                        ),
            ),
          )
        ],
      ),
      context: context,
    );
  }

  navigateToVerifyingScreen() {
    final _phone = widget.phone;
    final _fbId = widget.fbId;
    final _fbName = widget.fbName;
    final _fbEmail = widget.fbEmail;
    final _fbPicUrl = widget.fbPicUrl;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyingScreen(
          phone: _phone,
          fbId: _fbId,
          fbName: _fbName,
          fbEmail: _fbEmail,
          fbPicUrl: _fbPicUrl,
        ),
      ),
    );
  }

   navigateToStepOne() {
     final _phone = widget.phone;
    final _fbId = widget.fbId;
    final _fbName = widget.fbName;
    final _fbEmail = widget.fbEmail;
    final _fbPicUrl = widget.fbPicUrl;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetupStepOne(phone: _phone,
          fbId: _fbId,
          fbName: _fbName,
          fbEmail: _fbEmail,
          fbPicUrl: _fbPicUrl,
          loginType: widget.loginType),
      ),
    );
  }
}
