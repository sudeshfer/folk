import 'dart:developer';

import 'package:flutter/material.dart';

class PhoneLogin extends StatefulWidget {
  PhoneLogin({Key key}) : super(key: key);

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 60.0, left: 14),
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
              child: Container(
                margin: EdgeInsets.only(top: 40, left: 30, right: 30),
                child: TextField(
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color.fromRGBO(238, 238, 238, 0.1))),
                      labelText: 'Phone Number'),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30, left: 30, right: 30),
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
                margin: EdgeInsets.only(top: 45, left: 30, right: 30),
                child: InkWell(
                  onTap: () {
                    log('Clikced on next btn');
                        Navigator.of(context).pushNamed("/pincode");
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
    );
  }
}
