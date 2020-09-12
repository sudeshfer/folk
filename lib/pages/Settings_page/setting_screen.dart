import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/pages/LoginPage.dart';
import 'package:folk/pages/Settings_page/progresBar.dart';
import 'package:folk/pages/editEmail&Phone/editEmail.dart';
import 'package:folk/pages/editEmail&Phone/editPhoneNumber.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  UserModel userModel;

  double _lowerValue = 18.0;
  double _upperValue = 80.0;
  double _lowerValue_s = 50;
  bool togglevalue = false;
  bool togglevalue1 = false;

  
  // RangeValues _values = RangeValues(18, 80);
  double _value = 1;

  String maxDistance = "2";
  double sliderDistanceVal = 2;
  double sliderAgeMaxVal = 90;
  double sliderAgeLoweVal = 18;
  String lowerAge = "1";
  String maxAge = "100";
  String city;
  String country;
  String email;
  String phone;

  double loverAge = 18;
  double endAge = 55;

  initiateDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      city = prefs.getString("city");
      email = userModel.email;
      phone = userModel.phoneNum;
    });

    if (prefs.getString("maxDis") != null) {
      print("hutttttooooooooo eka");
      setState(() {
        maxDistance = prefs.getString("maxDis");
        _value = double.parse(maxDistance);
      });
    }
    if (prefs.getInt("lowerAge") != null) {
      print("hutttttooooooooo vda");
      setState(() {
        loverAge = prefs.getInt("lowerAge").toDouble();
      });
    }
    if (prefs.getInt("maxAge") != null) {
      print("hutttttooooooooo vda");
      setState(() {
        endAge = prefs.getInt("maxAge").toDouble();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    initiateDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: new Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        child: new SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    print(email);
                  },
                  child: DetailBox(
                      Icon(Icons.pin_drop), "Location", city, () => null)),
              DetailBox(Icon(Icons.email), "Email", email,
                  () => navigateToUpdateEmail()),
              DetailBox(
                  Icon(Icons.phone),
                  "Phone",
                  phone != "" ? phone : "Null",
                  () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditPhoneNumPage()))),
              SizedBox(height: 20),
              SliderTitle("Max. Distance : ", maxDistance + " km"),
              Container(
                  margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                  alignment: Alignment.centerLeft,
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.deepOrange,
                      inactiveTrackColor: Colors.grey[200],
                      trackShape: RectangularSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbColor: Colors.deepOrange,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayColor: Colors.deepOrange.withAlpha(32),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                    ),
                    child: Slider(
                      min: 0,
                      max: 100,
                      value: _value,
                      onChanged: (val) async {
                        // _value = val;
                        setState(() {
                          _value = val;
                        });
                        print(_value.toInt());

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setInt("maxDistance", _value.toInt() * 1000);
                        prefs.setString("maxDis", _value.toInt().toString());
                        int max = prefs.getInt("maxDistance");
                        print("Max Distance is " + max.toString());

                        setState(() {
                          maxDistance = prefs.getString("maxDis");
                        });
                      },
                    ),
                  )
                  // FlutterSlider(
                  //   values: [sliderDistanceVal, 100],
                  //   max: 100,
                  //   min: 0,
                  //   tooltip: FlutterSliderTooltip(
                  //     alwaysShowTooltip: true,
                  //   ),
                  //   step: 1.5,
                  //   onDragging: (handlerIndex, lowerValue, upperValue) async {
                  //     _lowerValue_s = lowerValue;
                  //     await setDistance();
                  //   },
                  // ),
                  ),
              SizedBox(height: 10),
              SliderTitle(
                  "Age Range : ",
                  loverAge.toStringAsFixed(0) +
                      " - " +
                      endAge.toStringAsFixed(0)),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                  alignment: Alignment.centerLeft,
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.deepOrange,
                      inactiveTrackColor: Colors.grey[200],
                      trackShape: RectangularSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbColor: Colors.deepOrange,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayColor: Colors.deepOrange.withAlpha(32),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 28.0),
                    ),
                    child: RangeSlider(
                      min: 18,
                      max: 80,
                      values: RangeValues(loverAge, endAge),
                      // divisions: 1,
                      onChanged: (newvalues) async {
                        setState(() {
                          // _values = newvalues;
                          loverAge= newvalues.start;
                          endAge = newvalues.end;
                        });
                        print(newvalues.end.toInt());
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setInt("lowerAge", newvalues.start.toInt());
                        prefs.setInt("maxAge", newvalues.end.toInt());
                      },
                    ),
                  )),
              SizedBox(height: 20),
              buildToggler('assets/images/ic_notification_setting.png',
                  "Enable Notification", 'notification'),
              SizedBox(
                height: 20,
              ),
              buildToggler('assets/images/ic_on_location.png',
                  "Show me on Folk", 'folk'),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Turning this on will hide you from the matches for as long as you choose. You can still messages your existing matches.',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 30),
              Container(
                margin: new EdgeInsetsDirectional.only(start: 20.0, end: 1.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 20),
              AboutUsWidget(
                  'assets/images/ic_feedback.png', "Terms of service"),
              SizedBox(height: 30),
              AboutUsWidget('assets/images/ic_about.png', "Contact us"),
              SizedBox(height: 30),
              AboutUsWidget('assets/images/ic_update.png', "Privacy policy"),
              SizedBox(height: 30),
              Center(
                child: Container(
                  child: Text(
                    "Folk version 1.0",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: InkWell(
                            onTap: () {
                              //
                              logOut();
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 1.15,
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: Center(
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed("/mmmm");
                                    },
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width /
                                          1.15,
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      child: Center(
                                        child: Text(
                                          'Delete Account',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color.fromRGBO(
                                                  255, 94, 58, 1),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future setAgeRange() async {
  //    SharedPreferences prefs =
  //       await SharedPreferences.getInstance();
  //   prefs.setString("lowerAge", _lowerValue.toString());
  //   prefs.setString("maxAge", _upperValue.toString());
  //   String maxage = prefs.getString("maxAge");
  //   String lowerage = prefs.getString("lowerAge");
  //   print("max age is "+maxage);
  //   setState(() {
  //     lowerAge = lowerage;
  //     maxAge = maxage;
  //   });
  // }

  // Future setDistance() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt("maxDistance", _lowerValue_s.toInt()*1000);
  //   prefs.setString("maxDis", _lowerValue_s.toString());
  //   int max = prefs.getInt("maxDistance");
  //   print("Max Distance is "+max.toString());
  //   setState(() {
  //     maxDistance = prefs.getString("maxDis");
  //   });
  // }

  Row buildToggler(String imgPath, String title, String type) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 15),
        Image.asset(
          imgPath,
          height: 30,
        ),
        SizedBox(width: 15),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontFamily: 'Montserrat',
          ),
        ),
        Spacer(),
        CupertinoSwitch(
          value: (type == 'notification') ? togglevalue : togglevalue1,
          onChanged: (bool value) {
            setState(() {
              (type == 'notification')
                  ? togglevalue = value
                  : togglevalue1 = value;
            });
          },
        ),
        SizedBox(width: 15),
      ],
    );
  }

  logOut() async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('gettoken');
    prefs2.remove("token");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext ctx) => LoginPage()));
  }

  navigateToUpdateEmail() {
    if (userModel.imagesource == 'userimage') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EditEmailPage()));
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Sorry !"),
              content: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "since you are using the facebook login we can't allow you to change the email",
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 35,
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }
}

// class CustomSlider extends StatefulWidget {
//   const CustomSlider({
//     Key key,
//   }) : super(key: key);

//   @override
//   _CustomSliderState createState() => _CustomSliderState();
// }

// class _CustomSliderState extends State<CustomSlider> {
//   double _value = 1;
//   @override
//   Widget build(BuildContext context) {
//     return SliderTheme(
//       data: SliderThemeData(
//         activeTrackColor: Colors.deepOrange,
//         inactiveTrackColor: Colors.grey[200],
//         trackShape: RectangularSliderTrackShape(),
//         trackHeight: 4.0,
//         thumbColor: Colors.deepOrange,
//         thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
//         overlayColor: Colors.deepOrange.withAlpha(32),
//         overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
//       ),
//       child: Slider(
//         min: 0,
//         max: 100,
//         value: _value,
//         onChanged: (val) async {
//           // _value = val;
//           setState(() {
//             _value = val;
//           });
//           print(_value.toInt());

//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setInt("maxDistance", _value.toInt() * 1000);
//           prefs.setString("maxDis", _value.toString());
//           int max = prefs.getInt("maxDistance");
//           print("Max Distance is " + max.toString());
//         },
//       ),
//     );
//   }
// }

// class CustomRangeSlider extends StatefulWidget {
//   const CustomRangeSlider({
//     Key key,
//   }) : super(key: key);

//   @override
//   _CustomRangeSliderState createState() => _CustomRangeSliderState();
// }

// class _CustomRangeSliderState extends State<CustomRangeSlider> {
//   RangeValues _values = RangeValues(0.3, 0.7);
//   @override
//   Widget build(BuildContext context) {
//     return SliderTheme(
//       data: SliderThemeData(
//         activeTrackColor: Colors.deepOrange,
//         inactiveTrackColor: Colors.grey[200],
//         trackShape: RectangularSliderTrackShape(),
//         trackHeight: 4.0,
//         thumbColor: Colors.deepOrange,
//         thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
//         overlayColor: Colors.deepOrange.withAlpha(32),
//         overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
//       ),
//       child: RangeSlider(
//         // min: 0,
//         // max: 100,
//         values: _values,
//         onChanged: (RangeValues values) {
//           setState(() {
//             _values = values;
//           });
//           print(values);

//           Future setAgeRange() async {
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             prefs.setString("lowerAge", values.end.toString());
//             prefs.setString("maxAge", values.start.toString());
//             String maxage = prefs.getString("maxAge");
//             String lowerage = prefs.getString("lowerAge");
//             print("max age is " + maxage);
//             // setState(() {
//             //   lowerAge = lowerage;
//             //   maxAge = maxage;
//             // });
//           }
//         },
//       ),
//     );
//   }
// }

class AboutUsWidget extends StatelessWidget {
  final String imgPath;
  final String title;
  AboutUsWidget(this.imgPath, this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 15),
        Image.asset(
          imgPath,
          height: 30,
        ),
        SizedBox(width: 15),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        Spacer(),
        Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
        SizedBox(width: 15),
      ],
    );
  }
}

class SliderTitle extends StatelessWidget {
  final String title;
  final String value;
  SliderTitle(this.title, this.value);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: new EdgeInsetsDirectional.only(start: 25.0, end: 1.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16),
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 94, 58, 1),
                    fontSize: 15.5,
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

class DetailBox extends StatelessWidget {
  final Icon icon;
  final String title;
  final String value;
  final Function() ontap;

  DetailBox(this.icon, this.title, this.value, this.ontap);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(2, 0, 2, 20),
      child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 15),
            icon,
            SizedBox(width: 15),
            Container(
              child: Text(
                title.toUpperCase(),
                style: TextStyle(fontSize: 17, color: Colors.black),
              ),
            ),
            Spacer(),
            Container(
              margin: new EdgeInsetsDirectional.only(start: 20.0, end: 1.0),
              child: GestureDetector(
                onTap: ontap,
                child: Text(
                  value,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 94, 58, 1),
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
            SizedBox(width: 5),
          ]),
    );
  }
}
