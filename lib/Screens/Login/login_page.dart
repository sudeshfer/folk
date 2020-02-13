import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:folk/Screens/Login/phone_login.dart';
import 'package:folk/Controllers/ApiServices/FbLoginService.dart';
import 'package:folk/Screens/Login/setup_step3.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:folk/Utils/Animations/delayed_reveal.dart';
import 'package:folk/Utils/Login_utils/loading_dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn = false;
  var profileData;
  String login_Type = "";
  ProgressDialog pr;

  SharedPreferences prefs;


  var facebookLogin = FacebookLogin();

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  @override
  void initState() {
    super.initState();
  }

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
        body: Stack(
          children: <Widget>[
            FadeAnimation(
              0.3,
              Container(
                child: new Image.asset(
                  'assets/images/bg-white.png',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 90.0,
              left: (MediaQuery.of(context).size.width) / 3,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.cover)),
                height: 66.0,
                width: 140.0,
              ),
            ),
            Positioned(
              bottom: 20,
              left: 32,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DelayedReveal(
                      delay: Duration(milliseconds: 300),
                      child: InkWell(
                        onTap: () {
                          log('Clikced on Login with facebook btn');
                          setState(() {
                            login_Type = "fb";
                          });
                          initiateFacebookLogin();
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF2672CB),
                                      Color(0xFF2672CB)
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/fb-icon.png',
                                      scale: 1.4,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 35.0, right: 20),
                                      child: Text(
                                        'Login with Facebook'.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'Montserrat',
                                          // fontWeight: FontWeight.w100,
                                          // letterSpacing: 0.2,
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    DelayedReveal(
                      delay: Duration(milliseconds: 450),
                      child: InkWell(
                        onTap: () {
                          log('Clikced on Login with 4n btn');
                          // CircularProgressIndicator();
                          setState(() {
                            login_Type = "otp";
                          });
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) =>
                          //         PhoneLogin(loginType: login_Type)));

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  SetupStepThree()));
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width / 1.2,
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        'Login with phone number'.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: 'Montserrat',
                                            // fontWeight: FontWeight.w600,
                                            // letterSpacing: 0.2,
                                            height: 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    DelayedReveal(
                      delay: Duration(milliseconds: 600),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: InkWell(
                            onTap: () {
                              log('Clikced on trouble with login');
                              Navigator.of(context).pushNamed("/forgotpw");
                            },
                            child: Container(
                              child: Text('Trouble Logging In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      decoration: TextDecoration.underline)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    DelayedReveal(
                      delay: Duration(milliseconds: 750),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Container(
                            child: Text('By clicking start, you agree to our',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                )),
                          ),
                        ),
                      ),
                    ),
                    DelayedReveal(
                      delay: Duration(milliseconds: 900),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            child: Text('Terms and Conditions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                )),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void initiateFacebookLogin() async {
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        pr.show();
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);
        print(profile.toString());

        onLoginStatusChanged(true, profileData: profile);

        final _fbId = "${profileData['id']}";
        final _fbName = "${profileData['name']}";
        final _fbEmail = "${profileData['email']}";
        // final _gender = "${profileData['user_gender']}";
        final _fbPicUrl = profileData['picture']['data']['url'];
        final body = {
          "email": _fbEmail,
        };

        if (_fbEmail != null) {
          LoginwithFBService.LoginWithFB(body).then((success) async {
            if (success) {
              print("fb old user");
              //Fb login old user
              //  Navigator.of(context).pushNamed("/home");
               SharedPreferences prefs = await SharedPreferences.getInstance();
              final _token = prefs.getString("gettoken");
              print(_token);

              SharedPreferences prefs2 = await SharedPreferences.getInstance();
              prefs2.setString("token", _token);
              pr.hide();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VerifyingScreen(
                      fbId: _fbId,
                      fbName: _fbName,
                      fbEmail: _fbEmail,
                      fbPicUrl: _fbPicUrl,
                      loginType: login_Type)));
            } else {
              print("fb new  user");
              //Fb login new user
             
              pr.hide();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PhoneLogin(
                      fbId: _fbId,
                      fbName: _fbName,
                      fbEmail: _fbEmail,
                      fbPicUrl: _fbPicUrl,
                      loginType: login_Type)));
            }
          });
        } else {
          showAlert(
            context: context,
            title: "Something Went wrong",
          );
          print("something went wrong ");
        }

        // print(_fbName+"\n"+_fbEmail);
        break;
    }
  }
}
