// import 'package:location/location.dart';
// import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:folk/Screens/Home_page/home_page.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GetLocation extends StatefulWidget {
  GetLocation({Key key}) : super(key: key);

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  PermissionStatus _status;
  bool isPermissionIgnored = false;
  bool isGoTOSettingsClicked = false;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    TimerFunction();
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus);
  }

  Future<void> initializeToken() async {
    
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var _token = prefs.getString('gettoken');
      print(_token);

      SharedPreferences prefs2 = await SharedPreferences.getInstance();
      prefs2.setString("token", _token);
    }


  TimerFunction() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) => {
      print("timer running"),
       PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus),

      
      if(_status==PermissionStatus.granted){
        t.cancel(),
        initializeToken(),
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepage()))        
      }
    });
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      _status = status;
      print(_status);
    }
    print(status);
  }

  Future<PermissionStatus> _onBackPressed() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus);
  }

  void _askPermission() {
    PermissionHandler().requestPermissions(
        [PermissionGroup.locationWhenInUse]).then(_onStatusrequested);
  }

  void _onStatusrequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final status = statuses[PermissionGroup.locationWhenInUse];
    if (status != PermissionStatus.granted) {
      openSettingsDialog();
    } else {
      _updateStatus(status);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Homepage()));
      // navigateToHome();
    }
  }

  // navigateToHome() {
  //   if (_status == PermissionStatus.granted) {
  //     Navigator.of(context)
  //         .push(MaterialPageRoute(builder: (context) => Homepage()));
  //   } else {
  //     print("permission denied");
  //   }
  // }

  Future<bool> openSettingsDialog() {
    return showDialog(
      builder: (context) => CupertinoAlertDialog(
        title: Text('You have to enable your location for whole experience !'),
        content: Column(
          children: <Widget>[
            Text("click ok to veify & sign in !"),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            color: Colors.orange,
            onPressed: () {
              PermissionHandler().openAppSettings();
            },
            child: Text(
              'Open Settings',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold),
            ),
          ),
          FlatButton(
            color: Colors.orangeAccent,
            onPressed: () {
              _updateStatus(_status);
              Navigator.of(context).pop();
              setState(() {
                isPermissionIgnored = true;
              });
              // navigateToHome();
            },
            child: Text(
              'close',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: new Image.asset(
              'assets/images/location_bg.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 30.0,
            // left: (MediaQuery.of(context).size.width) / 13,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FadeAnimation(
                    0.8,
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/location_ico.jpg'),
                              fit: BoxFit.cover)),
                      height: 340.0,
                      width: 340.0,
                    ),
                  ),
                  FadeAnimation(
                    0.9,
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 2),
                        child: isPermissionIgnored
                            ? Text(
                                "Oops !",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Text(
                                "Where are you?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Center(
                    child: FadeAnimation(
                      1,
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 18),
                          child: isPermissionIgnored
                              ? Text(
                                  "Your location service need to be turned on\norder for this to work",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Montserrat',
                                  ),
                                )
                              : Text(
                                  "Your location service need to be turned in\norder for this to work",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  FadeAnimation(
                    1.2,
                    isPermissionIgnored
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                isGoTOSettingsClicked = true;
                              });
                              PermissionHandler().openAppSettings();
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Container(
                                  height: 55,
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Center(
                                    child: Text(
                                      'Go To Settings'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Montserrat',
                                          // fontWeight: FontWeight.w600,
                                          // letterSpacing: 0.2,
                                          height: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              _askPermission();
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Container(
                                  height: 55,
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Center(
                                    child: Text(
                                      'Enable location'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Montserrat',
                                          // fontWeight: FontWeight.w600,
                                          // letterSpacing: 0.2,
                                          height: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // void initPlatformState() async{
  //   Map<String,double> my_location;

  //   try{
  //     my_location = await location.getLocation();
  //     error = "";
  //   }
  //   on PlatformException catch(e){
  //     if(e.code == 'PERMISSION_DENIED')
  //     error = 'Permission Denied';

  //     else if(e.code == 'PERMISSION_DENIED_NEVER_ASK')
  //     error = 'Permission denied - please ask the user to enable it from the app settings';
  //     my_location = null;
  //   }

  //   setState(() {
  //     currentLocation = my_location;
  //   });

  //   final lat = "${currentLocation['latitude']}";
  //   final long = "${currentLocation['longitude']}";

  //   print(lat +"\n"+ long);

  // }
}
