import 'package:flutter/material.dart';

class SetupStepThree extends StatefulWidget {
final bday;
final gender;
final email;
  // PincodeVerify({Key key}) : super(key: key);
  SetupStepThree({this.bday,this.gender,this.email});

  @override
  _SetupStepThreeState createState() => _SetupStepThreeState();
}

class _SetupStepThreeState extends State<SetupStepThree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(child: Center(child: Text(widget.bday+' '+ widget.gender+' '+ widget.email))),
    );
  }
}