import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:folk/app_localizations.dart';
import 'package:folk/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:folk/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:folk/pages/login&signup/resetPassword.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _email = TextEditingController();
  String _errorTxt = '';
  bool isLoaidng = false;
  ProgressDialog pr;

  @override
  void initState() {
    setState(() {
      _errorTxt = "";
    });
    super.initState();
  }

   void startSendMail(String email) async {
     pr.show();
    var url = '${Constants.SERVER_URL}user/sendresetmail';

    try {
      var response = await http.post(
        url,
        body: {'email': email.toLowerCase()},
      );
      var jsonResponse = await convert.jsonDecode(response.body);
      bool error = jsonResponse['error'];
      String status = jsonResponse['status'];
      print(error);
      print(status);
      if (error == true) {
        pr.hide();
             _errorTxt = AppLocalizations.of(context)
                                    .translate('dont_belong');
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: Text('${jsonResponse['message']}'),
        //         actions: <Widget>[
        //           FlatButton(
        //               onPressed: () {
        //                 Navigator.pop(context);
        //               },
        //               child: Text('close'))
        //         ],
        //       );
        //     });
      } else if(status == "sent"){
            
          var status = jsonResponse['status'];
          print(status);
          // UserModel myModel = UserModel.fromJson(userData);

          // //make my model usable to all widgets
          // Provider.of<AuthProvider>(context, listen: false).userModel = myModel;

          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setString("gettoken", jsonResponse['token']);
          // prefs.setString("email", email);
          
          // saveData(
          //     myModel.id, myModel.name, myModel.email, myModel.token);
          if(status == "sent"){
                pr.hide();
              Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ResetPassword(
                                          resetEmail: _email.text,
                                        )));
        
          }
          else{
            pr.hide();
            setState(() {
              _errorTxt = "Something went wrong Try again !";
            });
          }
         
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

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
        message: AppLocalizations.of(context).translate('sending_email'),
        borderRadius: 10.0,
        progressWidget: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/emailSend.gif'),
                    fit: BoxFit.cover))),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(fontFamily: 'Montserrat'));

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            _errorTxt = "";
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              // SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.only(top: 50.0, left: 14),
                child: Container(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.black,
                    iconSize: 38,
                    onPressed: () {
                      log('Clikced on back btn');
                      Navigator.of(context).pop();
                    },
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),

              SizedBox(height: 12),
              FadeAnimation(
                0.8,
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                  child: Text(
                    AppLocalizations.of(context).translate('forgot_password'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(64, 75, 105, 1),
                        fontFamily: 'Montserrat',
                        fontSize: 22),
                    textAlign: TextAlign.left,
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
                        text: AppLocalizations.of(context)
                            .translate('please_enter'),
                        style: TextStyle(
                            color: Color.fromRGBO(64, 75, 105, 1),
                            fontSize: 16)),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FadeAnimation(
                0.1,
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7.0, horizontal: 25),
                  child: TextField(
                    controller: _email,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: Color(0xFFE0E0E0))),
                        labelText:
                            AppLocalizations.of(context).translate('email'),
                        errorText: _errorTxt,
                        errorBorder: _errorTxt.isEmpty
                            ? OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Color(0xFFE0E0E0)))
                            : null,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFE0E0E0)))),
                  ),
                ),
              ),

              FadeAnimation(
                1.2,
                Container(
                  padding: EdgeInsets.only(top: 32),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        if (checkNull()) {
                          setState(() {
                            _errorTxt = "";
                            isLoaidng = true;
                          });

                          if (validateEmail()) {
                           
                             startSendMail(_email.text);
                           
                          }
                        } else {
                          pr.hide();
                          setState(() {
                            _errorTxt = AppLocalizations.of(context)
                                .translate('fill_out');
                          });
                        }
                      },
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
                            AppLocalizations.of(context)
                                .translate('send_request')
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
                height: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkNull() {
    if (_email.text == '') {
      return false;
    } else {
      return true;
    }
  }

  ///function tht validate the email
  bool validateEmail() {
    String email = _email.text;
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid) {
      print("Valid email !");
      log("Valid email !");
      return true;
    } else {
      setState(() {
        _errorTxt = AppLocalizations.of(context).translate('not_valid');
      });
      return false;
    }
  }
}
