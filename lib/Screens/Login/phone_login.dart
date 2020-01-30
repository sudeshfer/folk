import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:folk/Controllers/OTP.dart';
import 'package:folk/Screens/Login/pincode_verify.dart';

class PhoneLogin extends StatefulWidget {
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  PhoneLogin({Key key, this.fbId, this.fbName, this.fbEmail, this.fbPicUrl})
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

  @override
  void initState() {
    setState(() {
      _errorTxt = "";
    });
    // print(widget.fbId +
    //     "\n" +
    //     widget.fbName +
    //     "\n" +
    //     widget.fbEmail +
    //     "\n" +
    //     widget.fbPicUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false, // this avoids the overflow error
      resizeToAvoidBottomInset: true,
      body: InkWell(
        onTap: () {
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
                      //go back
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
                        Container(
                          width: MediaQuery.of(context).size.width / 1.6,
                          margin: EdgeInsets.only(top: 40),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _phoneNo,
                            maxLength: 15,
                            decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: Color(0xFFF5F5F5))),
                                labelText: 'Phone Number',
                                errorText: _errorTxt,
                                errorBorder: _errorTxt.isEmpty
                                    ? OutlineInputBorder(
                                        borderSide:
                                            new BorderSide(color: Color(0xFFE0E0E0)))
                                    : null,
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFE0E0E0)))),
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

                          final String phoneNum = _countrycode + _phoneNo.text;
                          print(phoneNum);
                          otp.sendOtp(phoneNum);
                          int code = otp.get_otp();

                          final _fbId = widget.fbId;
                          final _fbName = widget.fbName;
                          final _fbEmail = widget.fbEmail;
                          final _fbPicUrl = widget.fbPicUrl;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PincodeVerify(phone: phoneNum,
                                                newotp:code,
                                                fbId: _fbId,
                                                fbName: _fbName,
                                                fbEmail: _fbEmail,
                                                fbPicUrl: _fbPicUrl,
                                              )));

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
                )
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

  // bool checklength() {
  //   if (_phoneNo.text == '') {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
}