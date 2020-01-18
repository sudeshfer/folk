import 'package:flutter/material.dart';

class SetupStepTwo extends StatefulWidget {
  SetupStepTwo({Key key}) : super(key: key);

  @override
  _SetupStepTwoState createState() => _SetupStepTwoState();
}

class _SetupStepTwoState extends State<SetupStepTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: RaisedButton(
                     child: Text("go to home"),
                     onPressed: (){
                       Navigator.of(context).pushNamed("/setupstep2");
                     },
                   ),
          ),
          Text("setup step 2 page"),
        ],
      )),
    );
  }
}