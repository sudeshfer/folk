import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 50.0,
            left: (MediaQuery.of(context).size.width) / 35,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              iconSize: 40,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 160.0,
            left: (MediaQuery.of(context).size.width) / 17,
            child: Text(
              "Reset Password \n",
              style: TextStyle(
                color: Color.fromRGBO(64, 75, 105, 1),
                fontSize: 21,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Positioned(
            top: 210.0,
            left: (MediaQuery.of(context).size.width) / 17,
            child: Text(
              "Reset code was sent your email. Please \n"
              "enter ther code and create new password.",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  color: Color.fromRGBO(64, 75, 105, 3),
                  fontSize: 17.5,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400),
            ),
          ),
          Positioned(
            top: 300.0,
            left: (MediaQuery.of(context).size.width) / 15,
            child: TextField(
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey)),
                  labelText: 'Reset Code'),
            ),
            height: 100.0,
            width: 360.0,
          ),
          Positioned(
            top: 385.0,
            left: 28,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width / 1.15,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Change Phone number'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
