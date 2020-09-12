import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:folk/app_localizations.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:folk/pages/editEmail&Phone/lodingScreens.dart';
import 'package:folk/utils/Login_utils/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

String result;
String enteredOtp;

class PincodeVerify extends StatefulWidget {
  final String phone;

  PincodeVerify(
      {this.phone});
  @override
  _PincodeVerifyState createState() => _PincodeVerifyState();
}

class _PincodeVerifyState extends State<PincodeVerify> {
  String smsCode;
  String verificationId;
  SharedPreferences prefs;
  ProgressDialog pr;
  UserModel userModel;

  bool isLoading = false;

  @override
  void initState() {
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    verifyPhone();
    super.initState();
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop();
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
  
     pr.show();
    var url = '${Constants.SERVER_URL}user/update_phone';

    try {
      var response = await http.post(
        url,
        body: {
          'user_id': userModel.id,
          'phone': widget.phone
          },
      );
      var jsonResponse = await convert.jsonDecode(response.body);
      bool error = jsonResponse['error'];
      String status = jsonResponse['data'];
      print(error);
      print(status);
      if (!jsonResponse['error']) {
        pr.hide();
         print("update success");
        Provider.of<AuthProvider>(context, listen: false)
            .updatePhone(widget.phone);

             navigateToVerifyingScreen();
        
      } else if(jsonResponse['error']) {
        pr.hide();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(' huttooo ${jsonResponse['data']}'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('close'))
                ],
              );
            });
         
      }
    } catch (err) {
      pr.hide();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('check your internet connection'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('close'))
              ],
            );
          });
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
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
        message: 'Please wait...',
        borderRadius: 10.0,
        progressWidget: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/loading2.gif'),
                    fit: BoxFit.cover))),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(fontFamily: 'Montserrat'));

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

  // Future<bool> navigateToHome() {
  //   return showDialog(
  //     builder: (context) => CupertinoAlertDialog(
  //       title: Text(AppLocalizations.of(context).translate('already_have')),
  //       content: Column(
  //         children: <Widget>[
  //           Text(AppLocalizations.of(context).translate('click_ok_to')),
  //         ],
  //       ),
  //       actions: <Widget>[
  //         FlatButton(
  //           color: Colors.orange,
  //           onPressed: () {
  //             navigateToVerifyingScreen();
  //           },
  //           child: Text(
  //             AppLocalizations.of(context).translate('txt_ok'),
  //             style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 14,
  //                 fontFamily: 'Montserrat',
  //                 fontWeight: FontWeight.bold),
  //           ),
  //         )
  //       ],
  //     ),
  //     context: context,
  //   );
  // }

  navigateToVerifyingScreen() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyingScreen(
        ),
      ),
    );
  }
}
