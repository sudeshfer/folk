import 'package:flutter/material.dart';
import 'package:folk/pages/Settings_page/setting_screen.dart';
import 'package:folk/pages/editEmail&Phone/pincode_verify.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String phone;
  VerifyPhoneScreen(
      {Key key, this.phone,})
      : super(key: key);

  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  @override
  void initState() {
    // log(widget.fbName);
    navigate();
    super.initState();
  }

   navigate() {
    Future.delayed(
      Duration(seconds: 5),
      () {
        // Navigator.pop(context);
       final phoneNum = widget.phone;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SentScreen(phone: phoneNum,),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/sending.gif'),
                      fit: BoxFit.cover)),
            ),
            Container(
              child: Text('Verifying Phone Number..!',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class SentScreen extends StatefulWidget {
  final String phone;
  SentScreen(
      {Key key,this.phone,})
      : super(key: key);

  @override
  _SentScreenState createState() => _SentScreenState();
}

class _SentScreenState extends State<SentScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 4),
      () {
        // Navigator.pop(context);
        final phoneNum = widget.phone;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PincodeVerify(phone: phoneNum,),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/sent.gif'),
                      fit: BoxFit.cover)),
            ),
            Container(
                child: Text("Otp Sent !",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                    )))
          ],
        ),
      ),
    );
  }
}

class VerifyingScreen extends StatefulWidget {
  VerifyingScreen(
      {Key key})
      : super(key: key);

  @override
  _VerifyingScreenState createState() => _VerifyingScreenState();
}

class _VerifyingScreenState extends State<VerifyingScreen> {

  @override
  void initState() {
    super.initState();
     navigate();
  }
  
  navigate() {
    Future.delayed(
      Duration(seconds: 5),
      () {
        // Navigator.pop(context);
        
        Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingScreen()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/sending.gif'),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                child: Text("Verifying You !",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}