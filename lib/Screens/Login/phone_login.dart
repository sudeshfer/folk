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
         child: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               Center(
                 child: RaisedButton(
                   child: Text("go to otp code"),
                   onPressed: (){
                     Navigator.of(context).pushNamed("/pincode");
                   },
                 ),
               ),
               Text("phone login page"),
             ],
           ),
         ),
      ),
    );
  }
}