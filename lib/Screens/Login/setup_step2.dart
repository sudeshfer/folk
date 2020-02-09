import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:folk/Controllers/ApiServices/registerUserService.dart';
import 'package:folk/Screens/Login/setup_step3.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SetupStepTwo extends StatefulWidget {
  final phone;
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  final loginType;
  String imgSource;
  String base_64;
  SetupStepTwo(
      {Key key,
      this.phone,
      this.fbId,
      this.fbName,
      this.fbEmail,
      this.fbPicUrl,
      this.loginType,
      this.imgSource,
      this.base_64})
      : super(key: key);

  @override
  _SetupStepTwoState createState() => _SetupStepTwoState();
}

class _SetupStepTwoState extends State<SetupStepTwo> {
  final _birthday = TextEditingController();
  final _email = TextEditingController();
  String _errorTxt = '';
  // String _errorBday = "";
  String _gender = "female";
  bool isMaleClicked = false;
  bool isFemaleClicked = false;
  ProgressDialog pr;

  @override
  void initState() {
    isFemaleClicked = true;
    // String _gender = "female";
    _initiateEmailController();

    super.initState();
  }

  _initiateEmailController() {
    if (widget.fbEmail == null) {
      setState(() {
        _email.text = null;
      });
      print(_email);
    } else {
      setState(() {
        _email.text = widget.fbEmail;
      });
      print(_email.text);
    }
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

    return Scaffold(
      resizeToAvoidBottomPadding: false, // this avoids the overflow error
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            _errorTxt = "";
          }); //
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
                    Navigator.of(context).pop(); //go back
                  },
                ),
              ),
              FadeAnimation(
                0.8,
                Container(
                  margin: EdgeInsets.only(top: 25, left: 30),
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
              ),
              FadeAnimation(
                0.9,
                Container(
                  margin: EdgeInsets.only(top: 30, left: 30),
                  child: Text(
                    "Gender",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(64, 75, 105, 1),
                      fontSize: 19,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
              FadeAnimation(
                1,
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMaleClicked = true;
                                isFemaleClicked = false;
                                _gender = "male";
                              });

                              print("Selected gender = " + _gender);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 55),
                              height: 70.0,
                              width: 70.0,
                              decoration: new BoxDecoration(
                                border: Border.all(color: Color(0xFFE0E0E0)),
                                shape: BoxShape.circle,
                                color: isMaleClicked
                                    ? Color(0XFFFF5E3A)
                                    : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Container(
                                  child: isMaleClicked
                                      ? Image.asset(
                                          'assets/images/male-white.png')
                                      : Image.asset(
                                          'assets/images/male-black.png'),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 60.0),
                            child: Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Text("Male")),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFemaleClicked = true;
                                isMaleClicked = false;
                                _gender = "female";
                              });

                              print("Selected gender = " + _gender);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 55),
                              height: 70.0,
                              width: 70.0,
                              decoration: new BoxDecoration(
                                border: Border.all(color: Color(0xFFE0E0E0)),
                                shape: BoxShape.circle,
                                color: isFemaleClicked
                                    ? Color(0XFFFF5E3A)
                                    : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Container(
                                  child: isFemaleClicked
                                      ? Image.asset(
                                          'assets/images/female-white.png') //white icon show
                                      : Image.asset(
                                          'assets/images/female-black.png'), //black icon show
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, right: 60.0),
                            child: Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Text("Female")),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              FadeAnimation(
                1.1,
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, right: 25.0, bottom: 10, top: 30),
                  child: GestureDetector(
                    onTap: () {
                      showDatePicker();
                    },
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE0E0E0))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              height: 54,
                              width: MediaQuery.of(context).size.width / 1.5,
                              // margin: EdgeInsets.only(top: 15),
                              child: TextField(
                                controller: _birthday,
                                enabled: false,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Your Birthday',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // margin: const EdgeInsets.only( top: 10),
                            child: Container(
                              child: Icon(
                                FontAwesomeIcons.solidCalendarAlt,
                                size: 30,
                                color: Color(0XFFFF5E3A),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              FadeAnimation(
                1.1,
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.0, horizontal: 25),
                      child: TextField(
                        controller: _email,
                        enabled: widget.loginType == "fb" ? false : true,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Color(0xFFE0E0E0))),
                            labelText: 'Email',
                            errorText: _errorTxt,
                            errorBorder: _errorTxt.isEmpty
                                ? OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xFFE0E0E0)))
                                : null,
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFE0E0E0)))),
                      ),
                    ),
                  ],
                ),
              ),
              FadeAnimation(
                1.2,
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 25, left: 26, right: 26, bottom: 25),
                    child: InkWell(
                      onTap: () {
                        log(_gender);
                        if (checkNull()) {
                          setState(() {
                            _errorTxt = "";
                          });

                          if (validateEmail()) {
                            print(_birthday.text);

                            postUserData();
                          }
                        } else {
                          setState(() {
                            _errorTxt = "You should fill out this field !";
                          });
                        }
                      },
                      child: Container(
                        height: 55,
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
              )
            ],
          )),
        ),
      ),
    );
  }

  //funnction to check the controllers are null or not
  bool checkNull() {
    if (_birthday.text == '' && _email.text == '') {
      return false;
    } else {
      return true;
    }
  }

  bool validateEmail() {
    String email = _email.text;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if(_birthday.text == ''){
      bdayValidationDialog();
      return false;
    }
    else if (emailValid) {
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

  Future<bool> bdayValidationDialog() {
    return showDialog(
      builder: (context) => CupertinoAlertDialog(
        title: Text('Select Your birthday !'),
        actions: <Widget>[
          FlatButton(
            color: Colors.orange,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
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

  showDatePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1980, 12, 31),
        maxTime: DateTime(2020, 12, 31), onChanged: (date) {
      //print the date
      print('change $date');
    }, onConfirm: (date) {
      final bday = "$date";

      var formatter = new DateFormat('yyyy-MM-dd');
      var selecteddate = formatter.format(date);

      setState(() {
        _birthday.text = selecteddate;
        //eaqual the bday value to text editing controller
      });

      //print the bday
      print('confirm ' + selecteddate.toString());
    }, locale: LocaleType.en);
  }

  postUserData() {
    pr.show();
    String bday = _birthday.text;
    String gender = _gender;
    String email = _email.text;
    final _phone = widget.phone;
    final _fbId = widget.fbId;
    final _fbName = widget.fbName;
    final _fbEmail = _email.text;
    final _fbPicUrl = widget.fbPicUrl;

    print(_fbName + _fbEmail);

    final body = {
      "name": _fbName,
      "gender": gender,
      "bday": bday,
      "email": _fbEmail,
      "phone": _phone,
      "imagesource": widget.imgSource,
      "base_64": widget.base_64,
      "fb_url": _fbPicUrl
    };
    print(body);
    RegisterUserService.RegisterUser(body).then((success) {
      if (success) {
        print('Register Success');
        //passing data to next screens
        pr.hide();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SetupStepThree()));

        // Navigator.of(context).pushNamed("/pincode");

      } else {
        pr.hide();
         showAlert(
            context: context,
            title: "Something Went wrong",
          );
        print('Register Failed');
      }
    });
  }
}
