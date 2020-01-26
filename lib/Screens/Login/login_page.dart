import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as JSON;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: new Image.asset(
              'assets/images/bg-white.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
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
                  InkWell(
                    onTap: (){
                      log('Clikced on Login with facebook btn');
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF2672CB), Color(0xFF2672CB)],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        color: Colors.white, fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
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
                  InkWell(
                    onTap: () {
                      log('Clikced on Login with 4n btn');
                      Navigator.of(context).pushNamed("/phonelogin");
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF6038), Color(0xFFFF9006)],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'Login with phone number'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
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
                  Center(
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
                                  fontSize: 15,
                                  decoration: TextDecoration.underline)),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        child: Text('By clicking start, you agree to our',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        child: Text('Terms and Conditions',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
