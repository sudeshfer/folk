import 'dart:developer';

import 'package:flutter/material.dart';

class SetupStepOne extends StatefulWidget {
  SetupStepOne({Key key}) : super(key: key);

  @override
  _SetupStepOneState createState() => _SetupStepOneState();
}

class _SetupStepOneState extends State<SetupStepOne> {
  final _name = TextEditingController();
  String _errorName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, // this avoids the overflow error
      resizeToAvoidBottomInset: true,
      body: InkWell(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
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
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 30),
                child: Text(
                  "Introduce Yourself",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(64, 75, 105, 1),
                    fontSize: 25,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  log("image upload btn clicked");
                },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 45),
                    child: Align(
                        alignment: Alignment.center,
                        child: Image.asset('assets/images/btn_upload_cover.png',
                            width: 220.0, height: 220.0, fit: BoxFit.cover)),
                  ),
                ),
              ),
              Container(
                // width: MediaQuery.of(context).size.width / 1.5,
                margin: EdgeInsets.only(top: 45, left: 28, right: 28),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _name,
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color.fromRGBO(238, 238, 238, 0.1))),
                      labelText: 'Name',
                      errorText: _errorName,
                      errorBorder: _errorName.isEmpty
                          ? OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey))
                          : null,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green))),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 35, left: 26, right: 26),
                  child: InkWell(
                    onTap: () {
                      if (checkNull()) {
                        setState(() {
                          _errorName = "";
                        });

                        Navigator.of(context).pushNamed("/setupstep2");
                      } else {
                        setState(() {
                          _errorName = "You should fill out this field !";
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
                          borderRadius: BorderRadius.all(Radius.circular(50))),
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
              )
            ],
          )),
        ),
      ),
    );
  }

  bool checkNull() {
    if (_name.text == '') {
      return false;
    } else {
      return true;
    }
  }
}
