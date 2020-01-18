import 'package:flutter/material.dart';

class PincodeVerify extends StatefulWidget {
  PincodeVerify({Key key}) : super(key: key);

  @override
  _PincodeVerifyState createState() => _PincodeVerifyState();
}

class _PincodeVerifyState extends State<PincodeVerify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: RaisedButton(
              child: Text("go to setup step1"),
              onPressed: () {
                Navigator.of(context).pushNamed("/setupstep1");
              },
            ),
          ),
          Text("pincode verify page"),
        ],
      )),
    );
  }
}
