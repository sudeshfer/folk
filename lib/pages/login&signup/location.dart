// import 'package:location/location.dart';
// import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:folk/app_localizations.dart';
import 'package:folk/pages/HomePage/Home.dart';
import 'package:folk/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';

class GetLocation extends StatefulWidget {
  GetLocation({Key key}) : super(key: key);

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  bool ispermissionGranted;
  bool isPermissionIgnored = false;
  bool isGoTOSettingsClicked = false;
  SharedPreferences prefs;
  PermissionStatus _status;
  UserModel _userModel;

  String _platformVersion;
  Position _currentPosition;
  double latt;
  // Permission permission;

  @override
  void initState() {
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    TimerFunction();
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus);
  }

  Future<void> initializeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _token = prefs.getString("gettoken");
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
                  if (_status == PermissionStatus.neverAskAgain) {
                  print("hutto wada"),
                  setState(() {
                    isPermissionIgnored = true;
                  }),
                  _updateStatus(_status),
                },
              if (latt != null)
                {
                            setState(() {
                  isPermissionIgnored = false;
                }),
                  print("location permission enabled !"),
                  t.cancel(),
                  print("timer canceled !"),
                  print(latt.toString()),
                  initializeToken(),
              
                startUpdateGeo( _currentPosition.longitude,_currentPosition.latitude,_userModel.id)
                 
                }
              else
                {
                  print("location permission not enabled !"),
                }
            });
  }

   void startUpdateGeo(double long, double lat, String userid) async {
      try {
        final geo = {
        "pintype": "Point",
        "coordinates": [long, lat]
      };

      print("============= "+geo.toString() + userid);

        Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

          var req = await http.post('${Constants.SERVER_URL}user/update_user_location',headers: requestHeaders,
              body: jsonEncode({
                'user_id': '$userid',
                "geometry": geo
              }));

              print("update geo ssssssssssssssssss $userid");
          var res = convert.jsonDecode(req.body);
          print("errorrrrrrrrrrrrrr "+res['error'].toString());

          if (!res['error']) {
            // Fluttertoast.showToast(msg: 'You requested follow ${widget.profile[0].name}');
            print("update geo success");
             Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Home()));
          }
     
      } catch (err) {} finally {}
    }

  Future<PermissionStatus> _updateStatus(PermissionStatus status) async {
    if (status != _status) {
      _status = status;
      print(_status);
    }

     if (_status == PermissionStatus.granted) {
            _currentPosition = await Geolocator()
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

            List<Placemark> placemark = await Geolocator()
                .placemarkFromCoordinates(
                    _currentPosition.latitude, _currentPosition.longitude);
            Placemark place = placemark[0];
            print(" City is " + place.locality);
            print(" COuntry is " + place.country);

            latt = _currentPosition.latitude;

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setDouble("lat", _currentPosition.latitude);
            prefs.setDouble("lng", _currentPosition.longitude);
            prefs.setString("city", place.locality.toString());
            prefs.setString("country", place.country.toString());
            double lat = prefs.getDouble("lat");
            print("latitude is " + lat.toString());

            print(_currentPosition.latitude.toString());
            print(_currentPosition.longitude.toString());
          }
    print(status);
    return _status;
  }

  

  Future<void> _askPermission() async {
    PermissionHandler()
        .requestPermissions([
          PermissionGroup.locationWhenInUse,
          // PermissionGroup.location,
          // PermissionGroup.locationAlways
        ])
        .then(_onStatusrequested);
       
  }

  void _onStatusrequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final status = statuses[PermissionGroup.locationWhenInUse];
     if (status == PermissionStatus.denied) {
      setState(() {
        isPermissionIgnored = false;
      });

      _updateStatus(status);
    } if (status == PermissionStatus.granted) {
      setState(() {
        isPermissionIgnored = false;
      });

      _updateStatus(status);
    }
    
  }

  //  _getCurrentLocation() async {
  //    if(_status == PermissionStatus.neverAskAgain){
  //      print("getting location running");
  //      setState(() {
  //        isPermissionIgnored = true;
  //      });
  //    }
  //    else if(_status == PermissionStatus.granted){
  //      print("getting location runningg");
  //     setState(() {
  //        isPermissionIgnored = false;
  //      });
  //    }
  //    else if(_status == PermissionStatus.denied){
  //       print("getting location runningggggg");
  //      _currentPosition = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  //       List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
  // Placemark place = placemark[0];
  // print(" City is "+ place.locality);

  // latt = _currentPosition.latitude;

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setDouble("lat", _currentPosition.latitude);
  //   prefs.setDouble("lng", _currentPosition.longitude);
  //   prefs.setString("city", place.locality.toString());
  //   double lat = prefs.getDouble("lat");
  //   print("latitude is " + lat.toString());

  //   print(_currentPosition.latitude.toString());
  //   print(_currentPosition.longitude.toString());

  //    }
  // }

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
        mainAxisAlignment: MainAxisAlignment.center,
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
                        AppLocalizations.of(context).translate('where_you'),
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
                        AppLocalizations.of(context).translate('need_enabled'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                        ),
                      )
                    : Text(
                        AppLocalizations.of(context).translate('need_enabled'),
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
                      PermissionHandler().openAppSettings();
                      // setState(() {
                      //   isPermissionIgnored = false;
                      // });
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
                      // setState(() {
                      //   isPermissionIgnored = false;
                      // });
                      _askPermission();
                      // _getCurrentLocation();
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
    ));
  }
}
