// import 'package:location/location.dart';
// import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:permission_handler/permission_handler.dart';

class GetLocation extends StatefulWidget {
  GetLocation({Key key}) : super(key: key);

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  // Map<String,double> currentLocation = new Map();
  // StreamSubscription<Map<String,double>> locationSubscription;

  // Location location = new Location();
  String error;
  PermissionStatus _status;

  @override
  void initState() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus);
  
    super.initState();
    
      
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      setState(() {
        _status = status;
      });
      print(_status);
    }
  }

  void _askPermission() {
    PermissionHandler().requestPermissions(
        [PermissionGroup.locationWhenInUse]).then(_onStatusRequested);
        
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final status = statuses[PermissionGroup.locationWhenInUse];
    // _updateStatus(status);
    if (status != PermissionStatus.granted){
      PermissionHandler().openAppSettings();
      
    } else {
      _navigateToHome();
      _updateStatus(status);
    }
    // _updateStatus(status);
  }

   _navigateToHome() {
      Navigator.of(context).pushNamed("/home");
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
                        child: Text(
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
                          child: Text(
                            "Your location service need to be turned on\norder for this to work",
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
                    InkWell(
                      onTap: () {
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
