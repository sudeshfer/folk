// import 'package:location/location.dart';
// import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
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
      PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse).then(_updateStatus);
    // print(widget.fbId +
    //     "\n" +
    //     widget.fbName +
    //     "\n" +
    //     widget.fbEmail +
    //     "\n" +
    //     widget.fbPicUrl);
    super.initState();
    // currentLocation['latitude'] = 0.0;
    // currentLocation['longintube'] = 0.0;
    // initPlatformState();
    // locationSubscription = location.onLocationChanged().listen((Map<String,double> result){
    //   setState(() {
    //     currentLocation = result;
    //   });
    // } );
  }

  void _updateStatus(PermissionStatus status){
    if(status != _status){
      setState(() {
        _status = status;
      });
      print(_status);
    }
  }
 
 void _askPermission(){
   PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]).then(_onStatusRequested);
 }

 void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses){
    final status = statuses[PermissionGroup.locationWhenInUse];
    // if(status != PermissionStatus.granted){
    //   PermissionHandler().openAppSettings();
    // }
    // else{
    //   _updateStatus(status);
    // }
    _updateStatus(status);
 }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:  Stack(
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
            top: 50.0,
            left: (MediaQuery.of(context).size.width) / 20,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/location.jpg'),
                      fit: BoxFit.cover)),
              height: 350.0,
              width: 365.0,
            ),
          ),
           Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 95.0,bottom: 15),
                      child: Container(
                        child: Text('Where are you?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold
                            )),
                      ),
                    ),
                  ),
       Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 240.0,bottom: 50),
                      child: Container(
                        child:  RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Your location service need to be turned on  \n",
                    
                    style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: 'Montserrat'),
                    children: [
                      TextSpan(
                          text: "order for this to work.",
                          style: TextStyle(
                              color: Colors.white,fontFamily: 'Montserrat',
                              fontSize: 16))
                    ]),
              ),
                      ),
                    ),
                  ),
          Positioned(
           top: 440,
            left: 32,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                 
                  InkWell(
                    onTap: () {
                      _askPermission();
                      // initPlatformState();
                      // Navigator.of(context).pushNamed("/");
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                            color: Colors.white, 
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                              
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'enable location'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18,fontFamily: 'Montserrat',
                                       // fontWeight: FontWeight.w600,
                                        letterSpacing: 0.2,
                                        height: 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
