import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:folk/app_localizations.dart';
import 'package:folk/pages/editEmail&Phone/lodingScreens.dart';
import 'package:folk/utils/Animations/FadeAnimation.dart';
import 'package:folk/utils/Constants.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:folk/models/UserModel.dart';
import 'package:provider/provider.dart';
import 'package:folk/providers/AuthProvider.dart';

class EditPhoneNumPage extends StatefulWidget {
  EditPhoneNumPage({Key key}) : super(key: key);

  @override
  _EditPhoneNumPageState createState() => _EditPhoneNumPageState();
}

class _EditPhoneNumPageState extends State<EditPhoneNumPage> {
  final _phoneNo = TextEditingController();
  Country _selected = Country.IT;
  String _countrycode = '+39';
  String _errorTxt = '';
  String phoneNum = "";
  bool isClicked = false;
  ProgressDialog pr;
  UserModel userModel;

   @override
  void initState() {
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    setState(() {
      _errorTxt = "";
    });

    print(_countrycode);
    super.initState();
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
                    "Change Your Phone Number ?",
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
                        text: "${userModel.phoneNum}",
                        style: TextStyle(
                            color: Color.fromRGBO(64, 75, 105, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                    TextSpan(
                      text: " is your current Phone number. Type your new phone number below and you will receive an otp",
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
              // SizedBox(
              //   height: 20,
              // ),
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
                            margin: EdgeInsets.only(top: 20),
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
                                    labelText: AppLocalizations.of(context)
                                        .translate('phone_no'),
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
                Container(
                  padding: EdgeInsets.only(top: 32),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        if (checkNull()) {
                          setState(() {
                            _errorTxt = "";
                            // isLoaidng = true;
                          });

                          if (validatePhone()) {
                           phoneNum = _countrycode + _phoneNo.text;
                           print(phoneNum);
                           navigateToVerifyingScreen();
                           
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

 bool checkNull() {
    if (_phoneNo.text == '') {
      return false;
    } else {
      return true;
    }
  }

  ///function tht validate the phonenum
 bool validatePhone() {
    if (_countrycode == '') {
      setState(() {
        _errorTxt = AppLocalizations.of(context).translate('err_select_c_code');
      });
      return false;
    } else if (_phoneNo.text.length >= 9) {
      print("valid 4n number");
      return true;
    } else {
      setState(() {
        _errorTxt = AppLocalizations.of(context).translate('err_shoub_be_9');
      });
      return false;
    }
  }

   navigateToVerifyingScreen() {
    final _phone = phoneNum;
    print("$_phone");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyPhoneScreen(
            phone: _phone),
      ),
    );
  }
}