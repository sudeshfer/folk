import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/pages/Settings_page/setting_screen.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/utils/Animations/FadeAnimation.dart';
import 'package:folk/utils/Constants.dart';
import 'package:gallery_saver/files.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:provider/provider.dart';

class EditEmailPage extends StatefulWidget {
  EditEmailPage({Key key}) : super(key: key);

  @override
  _EditEmailPageState createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  final _email = TextEditingController();
  String _errorTxt = '';
  bool isLoaidng = false;
  ProgressDialog pr;
   UserModel userModel;

  @override
  void initState() {
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    setState(() {
      _errorTxt = "";
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
     pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
        message: "Updating Email...",
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
                    "Change Your email ?",
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
                        text: "${userModel.email}",
                        style: TextStyle(
                            color: Color.fromRGBO(64, 75, 105, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                    TextSpan(
                      text: " is your current email address. Type your new email below and you will receive an email",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ]
                            ),
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
                            "Type your new Email",
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
                            _errorTxt = "You should fill out this field !";
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
                            "Send request"
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

  void startSendMail(String email) async {
     pr.show();
    var url = '${Constants.SERVER_URL}user/update_email';

    try {
      var response = await http.post(
        url,
        body: {
          'user_id': userModel.id,
          'email': email.toLowerCase()},
      );
      var jsonResponse = await convert.jsonDecode(response.body);
      bool error = jsonResponse['error'];
      String status = jsonResponse['status'];
      print(error);
      print(status);
      if (!jsonResponse['error']) {

        Provider.of<AuthProvider>(context, listen: false)
            .updateEmail(email);

            print("email updated");
            pr.hide();
        Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext ctx) => SettingScreen()));

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
             pr.hide();
             _errorTxt = "Something went wrong !";
         
         
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
        _errorTxt = "This is not a valid email !";
      });
      return false;
    }
  }
}