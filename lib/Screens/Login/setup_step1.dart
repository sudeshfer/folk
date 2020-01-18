import 'package:flutter/material.dart';

class SetupStepOne extends StatefulWidget {
  SetupStepOne({Key key}) : super(key: key);

  @override
  _SetupStepOneState createState() => _SetupStepOneState();
}

class _SetupStepOneState extends State<SetupStepOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: RaisedButton(
                     child: Text("go to step 2"),
                     onPressed: (){
                       Navigator.of(context).pushNamed("/setupstep2");
                     },
                   ),
          ),
          Text("setup step 1 page"),
        ],
      )),
    );
  }
}