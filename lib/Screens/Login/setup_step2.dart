import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:folk/Screens/Login/setup_step3.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SetupStepTwo extends StatefulWidget {
  SetupStepTwo({Key key}) : super(key: key);

  @override
  _SetupStepTwoState createState() => _SetupStepTwoState();
}

class _SetupStepTwoState extends State<SetupStepTwo> {
  final _birthday = TextEditingController();
  final _email = TextEditingController();
  String _errorTxt = '';
  // String _errorBday = "";
  String _gender = "";
  bool isMaleClicked = false;
  bool isFemaleClicked = false;

  @override
  void initState() {
    isFemaleClicked = true;
    // String _gender = "female";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, // this avoids the overflow error
      resizeToAvoidBottomInset: true,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode()); //
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
              Padding(
                padding: const EdgeInsets.only(left:25.0,right: 25.0,bottom: 10,top: 30),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFE0E0E0)
                    )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
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
                      Container(
                        // margin: const EdgeInsets.only( top: 10),
                        child: Container(
                          child: IconButton(
                            icon: Icon(FontAwesomeIcons.solidCalendarAlt),
                            iconSize: 30,
                            color: Color(0XFFFF5E3A),
                            onPressed: () {
                              
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(1980, 12, 31),
                                  maxTime: DateTime(2020, 12, 31),
                                  onChanged: (date) {
                                //print the date
                                print('change $date');
                                                    }, 
                                  onConfirm: (date) {
                                    final bday = "$date";

                                    setState(() {
                                      _birthday.text = bday; 
                                      //eaqual the bday value to text editing controller
                                    });

                                //print the bday
                                print('confirm ' + bday);
                              }, locale: LocaleType.en);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 7.0, horizontal: 25),
                    child: TextField(
                      controller: _email,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Color(0xFFE0E0E0))),
                          labelText: 'Email',
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
                ],
              ),
              Center(
                child: Container(
                  margin:
                      EdgeInsets.only(top: 25, left: 26, right: 26, bottom: 25),
                  child: InkWell(
                    onTap: () {
                      if (checkNull()) {
                        setState(() {
                          _errorTxt = "";
                        });

                        String bday = _birthday.text;
                        String gender = _gender;
                        String email = _email.text;

                        print(bday + gender + email);
                        //passing data to next screens
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SetupStepThree(
                                bday: bday, gender: gender, email: email)));

                        // Navigator.of(context).pushNamed("/pincode");
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

  //funnction to check the controllers are null or not
  bool checkNull() {
    if (_birthday.text == '' && _email.text == '') {
      return false;
    } else {
      return true;
    }
  }
}