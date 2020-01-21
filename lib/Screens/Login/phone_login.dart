import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:folk/Screens/Login/pincode_verify.dart';

class PhoneLogin extends StatefulWidget {
  PhoneLogin({Key key}) : super(key: key);

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  Country _selected;
  String _countrycode = '';
  final _phoneNo = TextEditingController();
  String _errorTxt = '';
  bool _validate = false;

  @override
  void initState() {
    setState(() {
      _errorTxt = "";
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneNo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false, // this avoids the overflow error
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 4,
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
                            final country_code = "+${country.dialingCode}";
                            _countrycode = country_code.toString();

                            print(_countrycode);
                          },
                          selectedCountry: _selected,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        margin: EdgeInsets.only(top: 40),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _phoneNo,
                          maxLength: 9,
                          decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color:
                                          Color.fromRGBO(238, 238, 238, 0.1))),
                              labelText: 'Phone Number',
                              errorText: _errorTxt,
                              errorBorder: _errorTxt.isEmpty
                                  ? OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.grey))
                                  : null,
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.green))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 45, left: 26, right: 26),
                  child: InkWell(
                    onTap: () {
                      if (checkNull()) {
                        setState(() {
                          _errorTxt = "";
                        });

                        String phoneNum = _countrycode + _phoneNo.text;
                        print(phoneNum);

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                PincodeVerify(phone: phoneNum)));

                        // Navigator.of(context).pushNamed("/pincode");
                      } else {
                        setState(() {
                          _errorTxt = "You should fill out this field !";
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

  bool checklength() {
    if (_phoneNo.text == '') {
      return false;
    } else {
      return true;
    }
  }
}
