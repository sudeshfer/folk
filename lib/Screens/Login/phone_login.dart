import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:folk/Controllers/OTP.dart';
import 'package:folk/Controllers/ApiServices/OtpLoginService.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:folk/Utils/Login_utils/loading_dialogs.dart';

class PhoneLogin extends StatefulWidget {
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  final loginType;
  PhoneLogin(
      {Key key,
      this.fbId,
      this.fbName,
      this.fbEmail,
      this.fbPicUrl,
      this.loginType})
      : super(key: key);

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

FlutterOtp otp = FlutterOtp();

class _PhoneLoginState extends State<PhoneLogin> {
  final _phoneNo = TextEditingController();
  Country _selected;
  String _countrycode = '';
  String _errorTxt = '';
  String _loginStatus = "";
  String phoneNum = "";
  bool isClicked = false;

  @override
  void initState() {
    setState(() {
      _errorTxt = "";
      _loginStatus = "";
    });
    // print(widget.fbId +
    //     "\n" +
    //     widget.fbName +
    //     "\n" +
    //     widget.fbEmail +
    //     "\n" +
    //     widget.fbPicUrl);
    log("LoginType = " + widget.loginType);
    super.initState();
  }

  // showLoader() {
  //   return Center(
  //     child: Container(
  //       height: 150,
  //       width: 150,
  //       decoration: BoxDecoration(
  //           image: DecorationImage(
  //               image: AssetImage('assets/images/otpsend.gif'),
  //               fit: BoxFit.cover)),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false, // this avoids the overflow error
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            _errorTxt = "";
          });
        },
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50.0, left: 14),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 38,
                    onPressed: () {
                      log('Clikced on back btn');
                      Navigator.of(context).pop();
                      //go back
                    },
                  ),
                ),
                FadeAnimation(
                  0.8,
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Text(
                        "Enter Your Phone Number",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(64, 75, 105, 1),
                          fontSize: 25,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                FadeAnimation(
                  1,
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 3.7,
                            margin: EdgeInsets.only(top: 40),
                            child: CountryPicker(
                              dense: false,
                              showFlag: true, //displays flag, true by default
                              showDialingCode:
                                  true, //displays dialing code, false by default
                              showName:
                                  false, //displays country name, true by default
                              showCurrency: false, //eg. 'British pound'
                              showCurrencyISO: false, //eg. 'GBP'
                              onChanged: (Country country) {
                                setState(() {
                                  _selected = country;
                                });

                                final countryCode = "+${country.dialingCode}";

                                _countrycode = countryCode.toString();

                                print(_countrycode);
                              },
                              selectedCountry: _selected,
                            ),
                          ),
                          FadeAnimation(
                            1,
                            Container(
                              width: MediaQuery.of(context).size.width / 1.6,
                              margin: EdgeInsets.only(top: 40),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _phoneNo,
                                // maxLength: 15,
                                decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Color(0xFFE0E0E0))),
                                    labelText: 'Phone Number',
                                    errorText: _errorTxt,
                                    errorBorder: _errorTxt.isEmpty
                                        ? OutlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Color(0xFFE0E0E0)))
                                        : null,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFE0E0E0)))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                FadeAnimation(
                  1.2,
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 30, left: 28, right: 28),
                      child: Text(
                        "Tap Next to receive an SMS confirmation from \n Account Kit powered by Facebook. Folk uses \n Facebook technology to keep you sign in.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF404B69),
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ),
                FadeAnimation(
                  1.4,
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 45, left: 26, right: 26),
                      child: InkWell(
                        onTap: () {
                          if (checkNull()) {
                            setState(() {
                              _errorTxt = "";
                              isClicked = true;
                            });
                           if(validatePhone())
                           {
                             phoneNum =  _countrycode + _phoneNo.text;
                            print(phoneNum);

                            final body = {"phone": phoneNum};
                            final _loginType = widget.loginType;

                            if (_loginType == "otp") {
                              
                              otp.sendOtp(phoneNum);
                              int code = otp.get_otp();
                              if (code != null) {
                                LoginwithOtpService.LoginWithOtp(body)
                                    .then((success) {
                                  if (success) {
                                    setState(() {
                                      _loginStatus = "otpolduser";
                                      //should go to home after verify
                                    });
                                    print('login status - ' + _loginStatus);
                                    //otp login old user
                                    navigateToVerifyingScreen();

                                  } else {
                                    setState(() {
                                      _loginStatus = "otpnewuser";
                                      //should go to stepone after verify
                                    });
                                    print('login status - ' + _loginStatus);
                                    //otp login new user
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => SentScreen(
                                                phone: phoneNum,
                                                newotp: code,
                                                loginStatus: _loginStatus,
                                                loginType: _loginType)));
                                  }
                                });
                              } else {
                                print("something went wrong otp not sent");
                                //if otp isnt sent
                              }
                            } else {
                              //fb login new user
                              LoginwithOtpService.LoginWithOtp(body)
                                  .then((success) {
                                if (success) {
                                  setState(() {
                                    _loginStatus = "fbnewuserOtpOld";
                                    //should go to home after verify
                                  });
                                  print("login status - " + _loginStatus);
                                  log("fb new user who already have an otp login");

                                  navigateToVerifyingScreen();

                                } else {
                                  

                                  setState(() {
                                    _loginStatus = "fbnewuserOtpNew";
                                    //should go to stepone after verify
                                  });
                                  otp.sendOtp(phoneNum);
                                  int code = otp.get_otp();

                                  print("login status - " + _loginStatus);
                                  log("fb new user who doesnt hvae an otp login");

                                  final _fbId = widget.fbId;
                                  final _fbName = widget.fbName;
                                  final _fbEmail = widget.fbEmail;
                                  final _fbPicUrl = widget.fbPicUrl;
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SentScreen(
                                            phone: phoneNum,
                                            newotp: code,
                                            fbId: _fbId,
                                            fbName: _fbName,
                                            fbEmail: _fbEmail,
                                            fbPicUrl: _fbPicUrl,
                                            loginType: widget.loginType,
                                            loginStatus: _loginStatus,
                                          )));
                                }
                              });
                            }
                           }

                           

                            // Navigator.of(context).pushNamed("/pincode");
                          } 
                          else {
                            setState(() {
                              _errorTxt = "Country Code & phone number needed !";
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 1.15,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF6038), Color(0xFFFF9006)],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Text(
                              'Next'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //     padding: const EdgeInsets.only(top: 8.0),
                //     child: isClicked ? showLoader() : null),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkNull() {
    if (_phoneNo.text == '') {
      return false;
    } else {
      return true;
    }
  }

  // isCountryCode(){
  //   if(_countrycode == ''){
  //     setState(() {
  //       _errorTxt = "Select your country code";
  //     });
  //   }
  //   else{
  //     setState(() {
  //       _errorTxt = "";
  //     });
  //   }
  // }

  bool validatePhone(){
    if(_countrycode== ''){
      setState(() {
        _errorTxt = "Select your country code";
      });
      return false;
    }
    else if(_phoneNo.text.length >= 9){
      print("valid 4n number");
      return true;
    }
    else{
      setState(() {
        _errorTxt = "This should long 9 digits or higher!";
      });
      return false;
    }
    
  }

  // Future<bool> navigateToLogin() {
  //   return showDialog(
  //     builder: (context) => CupertinoAlertDialog(
  //       title: Text('You already have an Otp login with this number !'),
  //       content: Column(
  //         children: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.only(top:8.0),
  //             child: Text("Try login with phone number !"),
  //           ),
  //         ],
  //       ),
  //       actions: <Widget>[
  //         FlatButton(
  //           color: Colors.orange,
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             Navigator.of(context).pop();
  //           },
  //           child: Text('Go Back To Login',
  //               style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 14,
  //                         fontFamily: 'Montserrat',
  //                         fontWeight: FontWeight.bold
  //                       ),
  //           ),
  //         )
  //       ],
  //     ),
  //     context: context,
  //   );
  //   false;
  // }

  navigateToVerifyingScreen() {
    final _phone = phoneNum;
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

  // bool checklength() {
  //   if (_phoneNo.text == '') {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
}
