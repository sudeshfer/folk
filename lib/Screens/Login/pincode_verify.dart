import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:folk/Screens/Login/setup_step1.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:folk/Utils/Login_utils/loading_dialogs.dart';
import 'package:folk/Utils/Login_utils/pin_code_fields.dart';
import 'package:folk/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

String result;
String enteredOtp;

class PincodeVerify extends StatefulWidget {
  final String phone;
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  final loginType;
  final loginStatus;
  // PincodeVerify({Key key}) : super(key: key);
  PincodeVerify(
      {this.phone,
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
  String smsCode;
  String verificationId;
  SharedPreferences prefs;

  bool isLoading = false;

  @override
  void initState() {
    verifyPhone();
    print(widget.loginStatus);
    print(widget.loginType);

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
  Future<bool> _onBackPressed() {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Future<void> verifyPhone() async {
    setState(() {
      isLoading = true;
    });
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verID) {
      this.verificationId = verID;
      setState(() {
        isLoading = false;
      });
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      print('sent');

      setState(() {
        isLoading = false;
      });
    };
    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential phoneAuthCredential) {
      navigate();
      print('verified');
      setState(() {
        isLoading = false;
      });
    };
    final PhoneVerificationFailed verifyFailed = (AuthException exception) {
      print('${exception.message}');
      setState(() {
        isLoading = false;
      });
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifyFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve);

    log("OTP sent");
  }

  navigate() async {
    final login_type = widget.loginType;
    final login_status = widget.loginStatus;
    print(login_type + login_status);

    if (login_type == "otp" && login_status == "otpolduser") {
      print("otp old user // has otp login // should go to home");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final _token = prefs.getString("gettoken");
      log(_token);

      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      prefs2.setString("token", _token);

      navigateToVerifyingScreen();
    } else if (login_type == "otp" && login_status == "otpnewuser") {
      print("otp new user // no otp login // should go to stepOne ");
      navigateToStepOne();
    } else if (login_type == "fb" && login_status == "fbnewuserOtpOld") {
      print("fb new user // has otp login // should go to home ");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final _token = prefs.getString("gettoken");
      log(_token);

      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      prefs2.setString("token", _token);

      navigateToHome();
    } else if (login_type == "fb" && login_status == "fbnewuserOtpNew") {
      print("fb new user // no otp login // should go to stepOne ");
      navigateToStepOne();
    } else {
      print("somehting went wrong");
    }
  }

  signIn() {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: enteredOtp,
    );
    FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      navigate();
    }).catchError((e) {
      showAlert(
        context: context,
        title: AppLocalizations.of(context).translate('err_empty_invalid'),
      );
      log("Invalid OTP");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                )
              : Container(
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
                            AppLocalizations.of(context)
                                .translate('enter_code'),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8),
                          child: RichText(
                            text: TextSpan(
                                text: AppLocalizations.of(context)
                                    .translate('has_sent_to'),
                                children: [
                                  TextSpan(
                                      text: widget.phone,
                                      style: TextStyle(
                                          color: Color(0xFFf45d27),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                ],
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 18)),
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
                                vertical: 7.0, horizontal: 7.0),
                            child: PinCodeTextField(
                              length: 6,
                              obsecureText: false,
                              shape: PinCodeFieldShape.box,
                              fieldHeight: 50,
                              backgroundColor: Colors.white,
                              fieldWidth: 50,
                              onCompleted: (v) {
                                print("Completed");
                              },
                              onChanged: (val) {
                                enteredOtp = val;
                              },
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          signIn();
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
                                      colors: [
                                        Color(0xFFFF6038),
                                        Color(0xFFFF9006)
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('continue')
                                        .toUpperCase(),
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
                            verifyPhone();
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: AppLocalizations.of(context)
                                    .translate('i_did_not'),
                                style: TextStyle(
                                    color: Color(0xFFf45d27),
                                    fontSize: 17.5,
                                    fontFamily: 'Montserrat'),
                                children: [
                                  TextSpan(
                                      text: " \n " +
                                          AppLocalizations.of(context)
                                              .translate('tap_continue'),
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
      ),
    );
  }

  Future<bool> navigateToHome() {
    return showDialog(
      builder: (context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context).translate('already_have')),
        content: Column(
          children: <Widget>[
            Text(AppLocalizations.of(context).translate('click_ok_to')),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            color: Colors.orange,
            onPressed: () {
              navigateToVerifyingScreen();
            },
            child: Text(
              AppLocalizations.of(context).translate('txt_ok'),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold),
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
        builder: (context) => SetupStepOne(
            phone: _phone,
            fbId: _fbId,
            fbName: _fbName,
            fbEmail: _fbEmail,
            fbPicUrl: _fbPicUrl,
            loginType: widget.loginType),
      ),
    );
  }
}
