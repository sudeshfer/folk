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
import 'package:folk/app_localizations.dart';

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
    new Timer.periodic(
        oneSec,
        (Timer t) => {
              print("timer running"),
              PermissionHandler()
                  .checkPermissionStatus(PermissionGroup.locationWhenInUse)
                  .then(_updateStatus),
              if (_status == PermissionStatus.granted)
                {
                  setState(() {
                    isPermissionIgnored = false;
                  }),

                  t.cancel(),
                  initializeToken(),
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Homepage()))
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
    if (status == PermissionStatus.neverAskAgain) {
      // openSettingsDialog();
      setState(() {
        isPermissionIgnored = true;
      });
      _updateStatus(_status);
    } else if (status == PermissionStatus.denied) {
      setState(() {
        isPermissionIgnored = false;
      });

      _updateStatus(status);
    } else if (status == PermissionStatus.granted) {
      setState(() {
        isPermissionIgnored = false;
      });

      _updateStatus(status);
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => Homepage()));
      // navigateToHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFF6038), Color(0xFFFF9006)],
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FadeAnimation(
            0.8,
            Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/location_ico.jpg'),
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
                        AppLocalizations.of(context).translate('oops'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context)
                                    .translate('where_you'),
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
          FadeAnimation(
            1,
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 18),
                child: isPermissionIgnored
                    ? Text(
                        AppLocalizations.of(context)
                                      .translate('need_enabled'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Montserrat',
                        ),
                      )
                    : Text(
                       AppLocalizations.of(context)
                                      .translate('need_enabled'),
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
                          width: MediaQuery.of(context).size.width / 1.4,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)
                                          .translate('goto_settings')
                                          .toUpperCase(),
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
                      setState(() {
                        isPermissionIgnored = false;
                      });
                      _askPermission();
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width / 1.4,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)
                                          .translate('enable_location')
                                          .toUpperCase(),
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
    )
    );
  }
}
