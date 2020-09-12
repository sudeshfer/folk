import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:folk/app_localizations.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:folk/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:folk/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:folk/pages/HomePage/Home.dart';

class ResetPassword extends StatefulWidget {
  final resetEmail;
  ResetPassword({Key key, this.resetEmail}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _resetCode = TextEditingController();
  String _errorTxt = '';
  ProgressDialog prd;

  @override
  void initState() {
    setState(() {
      _errorTxt = "";
    });
    log(widget.resetEmail);
    super.initState();
  }

  void startVerifyEmail(String email, String code) async {
    prd.show();
    var url = '${Constants.SERVER_URL}user/verifyemail';

    try {
      var response = await http.post(
        url,
        body: {'email': email.toLowerCase(), "code": code.toString()},
      );
      var jsonResponse = await convert.jsonDecode(response.body);
      bool error = jsonResponse['error'];
      if (error) {
        prd.hide();
        setState(() {
          _errorTxt =
              AppLocalizations.of(context).translate('invalid_check_again');
        });
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
      } else {
        var userData = jsonResponse['data'];
        print(userData);

        // saveData(
        //     myModel.id, myModel.name, myModel.email, myModel.token);
        if (userData != "") {
          prd.hide();
          UserModel myModel = UserModel.fromJson(userData);

          //make my model usable to all widgets
          Provider.of<AuthProvider>(context, listen: false).userModel = myModel;

           String categoryString = '';

          for (var i = 0; i < myModel.userInterests.length; i++) {
            print(myModel.userInterests[i].interestname);

             if (categoryString == '') {
                        categoryString += myModel.userInterests[i].interestname;
                      } else {
                        categoryString +=
                            " - " + myModel.userInterests[i].interestname;
                      }
          }

          print("cat string is = "+categoryString);
          Provider.of<AuthProvider>(context, listen: false)
            .updateCategoryString(categoryString);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("gettoken", jsonResponse['token']);
          prefs.setString("email", email);

                 Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Home()));
        } else {
          setState(() {
            _errorTxt = "Something went wrong Try again !";
          });
        }
      }
    } catch (err) {
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
    prd = new ProgressDialog(context, type: ProgressDialogType.Normal);
    // prd.style(message: 'Sending Email..');

    prd.style(
        message: AppLocalizations.of(context).translate('verifying_acc'),
        borderRadius: 10.0,
        progressWidget: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/loading2.gif'),
                    fit: BoxFit.cover))),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 4));

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
                    AppLocalizations.of(context).translate('reset_password'),
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
                                .translate('reset_was_sent') +
                            "\n" +
                            AppLocalizations.of(context)
                                .translate('enter_the_code'),
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
                1.1,
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7.0, horizontal: 25),
                  child: TextField(
                    controller: _resetCode,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide:
                                new BorderSide(color: Color(0xFFE0E0E0))),
                        labelText: AppLocalizations.of(context)
                            .translate('reset_code'),
                        errorText: _errorTxt,
                        errorBorder: _errorTxt.isEmpty
                            ? OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Color(0xFFE0E0E0)))
                            : null,
                        focusedBorder: _errorTxt.isNotEmpty
                            ? OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFE0E0E0)))
                            : null),
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
                          });

                          if (validatePhone()) {
                            startVerifyEmail(widget.resetEmail ,_resetCode.text);
                          }

                          // Navigator.of(context).pushNamed("/resetpw");
                        } else {
                          prd.hide();
                          setState(() {
                            _errorTxt = AppLocalizations.of(context)
                                .translate('err_should_fill');
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
                                .translate('change_phn_no')
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            ),
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
    if (_resetCode.text == '') {
      return false;
    } else {
      return true;
    }
  }

  bool validatePhone() {
    if (_resetCode.text.length == 6) {
      print("valid code");
      return true;
    } else {
      setState(() {
        _errorTxt = AppLocalizations.of(context).translate('err_must_contail');
      });
      return false;
    }
  }
}
