import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:folk/pin_code_fields.dart';

class PincodeVerify extends StatefulWidget {
  PincodeVerify({Key key}) : super(key: key);

  @override
  _PincodeVerifyState createState() => _PincodeVerifyState();

  
}

class _PincodeVerifyState extends State<PincodeVerify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                
            child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
                  alignment: Alignment.centerLeft,
                
              ),
          
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Enter the code',
                  style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Montserrat', fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                    
                child: RichText(
                  text: TextSpan(
                      text: "A verification code has been sent to ",
                      
                      children: [
                        TextSpan(
                            text: "12345",
                            style: TextStyle(
                                color: Color(0xFFf45d27),
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 18)),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7.0, horizontal: 25),
                  child: PinCodeTextField(
                    length: 4,
                    obsecureText: false,
                    shape: PinCodeFieldShape.box,
                    fieldHeight: 57,
                    backgroundColor: Colors.white,
                    fieldWidth: 67,
                    onCompleted: (v) {
                      print("Completed");
                    },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                      });
                    },
                  )),
             
             
           
                  
              InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed("/setupstep1");
                },
                              child: Container(
                     padding: EdgeInsets.only(top: 32),
                      child: Center(
                      child: Container(
                        height: 51,
                        width: MediaQuery.of(context).size.width / 1.12,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Text(
                            'Continue'.toUpperCase(),
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
                SizedBox(
                height: 20,
              ),
              Container(
                 padding: EdgeInsets.only(top: 30),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "I didn't get a code",
                    style: TextStyle(color: Color(0xFFf45d27), fontSize: 17.5),
                    children: [
                      TextSpan(
                          text: " \n Tap Continue to accept Facebook's Terms",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14))
                    ]),
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
}
