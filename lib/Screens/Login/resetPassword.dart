import 'dart:developer';

import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {


final _resetCode = TextEditingController();
String _errorTxt = '';

 @override
  void initState() {
    setState(() {
      _errorTxt = "";
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(64, 75, 105, 1),
                      fontFamily: 'Montserrat',
                      fontSize: 22),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Reset code was sent your email. Please \n"
                          "enter ther code and create new password.",
                      style: TextStyle(
                          color: Color.fromRGBO(64, 75, 105, 1), fontSize: 16)),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 7.0, horizontal: 25),
                child: TextField(
                  controller: _resetCode,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey[200])),
                      labelText: 'Reset Code',
                      errorText: _errorTxt,
                      errorBorder: _errorTxt.isEmpty
                                  ? OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.grey))
                                  : null,
                              focusedBorder:_errorTxt.isNotEmpty? OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green)):null
                      ),
                      
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 32),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      if (checkNull()) {
                        setState(() {
                          _errorTxt = "";
                        });

                      Navigator.of(context).pushNamed("/resetpw");

                      } else {
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
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Change Phone number'.toUpperCase(),
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
}
