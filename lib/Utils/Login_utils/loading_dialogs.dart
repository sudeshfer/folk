import 'package:flutter/material.dart';
import 'package:folk/Screens/Home_page/home_page.dart';
import 'package:folk/Screens/Login/location.dart';
import 'dart:async';
import 'package:folk/Screens/Login/pincode_verify.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingUpScreen extends StatefulWidget {
  final String phone;
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  final loginType;
  final loginStatus;
  SettingUpScreen(
      {Key key,
      this.phone,
      this.fbId,
      this.fbName,
      this.fbEmail,
      this.fbPicUrl,
      this.loginType,
      this.loginStatus})
      : super(key: key);

  @override
  _SettingUpScreenState createState() => _SettingUpScreenState();
}

class _SettingUpScreenState extends State<SettingUpScreen> {
  @override
  void initState() {
    super.initState();
    // log(widget.fbName);
    navigate();
  }

  navigate() {
    Future.delayed(
      Duration(seconds: 5),
      () {
        // Navigator.pop(context);
        final _fbId = widget.fbId;
        final _fbName = widget.fbName;
        final _fbEmail = widget.fbEmail;
        final _fbPicUrl = widget.fbPicUrl;
        final _loginType = widget.loginType;
        final _loginStatus = widget.loginStatus;
        final phoneNum = widget.phone;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(
              fbId: _fbId,
              fbName: _fbName,
              fbEmail: _fbEmail,
              fbPicUrl: _fbPicUrl,
              loginType: _loginType,
              loginStatus: _loginStatus,
              phone: phoneNum,
            ),
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
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                child: Text("Setting up your profile..",
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

class SentScreen extends StatefulWidget {
  final String phone;
  final int newotp;
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  final loginType;
  final loginStatus;
  SentScreen(
      {Key key,
      this.phone,
      this.newotp,
      this.fbId,
      this.fbName,
      this.fbEmail,
      this.fbPicUrl,
      this.loginType,
      this.loginStatus})
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
        final _fbId = widget.fbId;
        final _fbName = widget.fbName;
        final _fbEmail = widget.fbEmail;
        final _fbPicUrl = widget.fbPicUrl;
        final _loginType = widget.loginType;
        final _loginStatus = widget.loginStatus;
        final code = widget.newotp;
        final phoneNum = widget.phone;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PincodeVerify(
              fbId: _fbId,
              fbName: _fbName,
              fbEmail: _fbEmail,
              fbPicUrl: _fbPicUrl,
              loginType: _loginType,
              loginStatus: _loginStatus,
              phone: phoneNum,
            ),
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
  final String phone;
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  final loginType;
  final loginStatus;
  VerifyingScreen(
      {Key key,
      this.phone,
      this.fbId,
      this.fbName,
      this.fbEmail,
      this.fbPicUrl,
      this.loginType,
      this.loginStatus})
      : super(key: key);

  @override
  _VerifyingScreenState createState() => _VerifyingScreenState();
}

class _VerifyingScreenState extends State<VerifyingScreen> {

  PermissionStatus _status;

  @override
  void initState() {
    super.initState();
    //  print(widget.fbName);
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus);

        TimerFunction();
    // navigate();

  }

    TimerFunction() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) => {
      print("timer running"),
       PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus),

      
      if(_status==PermissionStatus.denied || _status== PermissionStatus.neverAskAgain){
        t.cancel(),
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetLocation()))        
      }
      else{
        print("location permission enabled !"),
        t.cancel(),
        navigate(),
      }
    });
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      _status = status;
      print(_status);
    }
  }

  navigate() {
    Future.delayed(
      Duration(seconds: 5),
      () {
        // Navigator.pop(context);
        final _fbId = widget.fbId;
        final _fbName = widget.fbName;
        final _fbEmail = widget.fbEmail;
        final _fbPicUrl = widget.fbPicUrl;
        final _loginType = widget.loginType;
        final _loginStatus = widget.loginStatus;
        final phoneNum = widget.phone;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(
              fbId: _fbId,
              fbName: _fbName,
              fbEmail: _fbEmail,
              fbPicUrl: _fbPicUrl,
              loginType: _loginType,
              loginStatus: _loginStatus,
              phone: phoneNum,
            ),
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
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                child: Text("Verifying Code !",
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

class VerifyPhoneScreen extends StatefulWidget {
  final String phone;
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  final loginType;
  final loginStatus;
  VerifyPhoneScreen(
      {Key key,
      this.phone,
      this.fbId,
      this.fbName,
      this.fbEmail,
      this.fbPicUrl,
      this.loginType,
      this.loginStatus})
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
        final _fbId = widget.fbId;
        final _fbName = widget.fbName;
        final _fbEmail = widget.fbEmail;
        final _fbPicUrl = widget.fbPicUrl;
        final _loginType = widget.loginType;
        final _loginStatus = widget.loginStatus;
        final phoneNum = widget.phone;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SentScreen(
              fbId: _fbId,
              fbName: _fbName,
              fbEmail: _fbEmail,
              fbPicUrl: _fbPicUrl,
              loginType: _loginType,
              loginStatus: _loginStatus,
              phone: phoneNum,
            ),
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
