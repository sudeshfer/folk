import 'package:flutter/material.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WhenFilter extends StatefulWidget {
  WhenFilter({Key key}) : super(key: key);

  @override
  _WhenFilterState createState() => _WhenFilterState();
}

class _WhenFilterState extends State<WhenFilter> {
  String isExpanded = "";
  bool verified = false;
  bool allDates = false;
  bool today = false;
  bool tomorrow = false;
  bool tWeek = false;
  bool lWeek = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeTypology();
  }

  initializeTypology() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(
        "typology issssssssssssssss " + '${prefs.getString("filterTypology")}');

    if (prefs.getString("filterWhen") == "") {
      print("empty");
      setState(() {
        today = false;
        allDates = false;
        tomorrow = false;
        tWeek = false;
        lWeek = false;
      });
    }
    if (prefs.getString("filterWhen") == "all") {
      setState(() {
        allDates = true;
        today = false;
        tomorrow = false;
        tWeek = false;
        lWeek = false;
      });
    }
    if (prefs.getString("filterWhen") == "today") {
      setState(() {
        today = true;
        allDates = false;
        tomorrow = false;
        tWeek = false;
        lWeek = false;
      });
    }
    if (prefs.getString("filterWhen") == "tomorrow") {
      setState(() {
        today = false;
        allDates = false;
        tomorrow = true;
        tWeek = false;
        lWeek = false;
      });
    }
    if (prefs.getString("filterWhen") == "tweek") {
      setState(() {
        today = false;
        allDates = false;
        tomorrow = false;
        tWeek = true;
        lWeek = false;
      });
    }
    if (prefs.getString("filterWhen") == "lweek") {
      setState(() {
        today = false;
        allDates = false;
        tomorrow = false;
        tWeek = false;
        lWeek = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      0.9,
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 18),
        child: ExpansionTile(
          title: buildExpansionHeader("When"),
          onExpansionChanged: changeIcon(),
          trailing: Icon(
            Icons.keyboard_arrow_down,
            size: 35,
            color: isExpanded == "false" ? Colors.black : Colors.black,
          ),
          initiallyExpanded: false,
          children: <Widget>[
            FadeAnimation(
              0.5,
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 30.0, left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              allDates = !allDates;
                              today = false;
                              tomorrow = false;
                              tWeek = false;
                              lWeek = false;
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            if (allDates == true) {
                              prefs.setString("filterWhen", "all");
                              print(prefs.getString("filterWhen"));
                              showToast("Filter set to All posts !");
                            
                            } else if (allDates == false) {
                              prefs.remove("filterWhen");
                              showToast("Filter cleard !");
                              print("removeddddddddd");
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 7, 12),
                            // padding: const EdgeInsets.all(12.0),
                            // margin: const EdgeInsets.only(right: 5),
                            height: 35,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFE0E0E0)),
                                color:
                                    allDates ? Color(0xFFFFEBE7)
                                            : Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0),
                                    bottomLeft: Radius.circular(0.0))),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "All Dates",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color.fromRGBO(255, 112, 67, 1),
                                      fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              today = !today;
                              allDates = false;
                              tomorrow = false;
                              tWeek = false;
                              lWeek = false;
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            if (today == true) {
                              prefs.setString("filterWhen", "today");
                              print(prefs.getString("filterWhen"));
                              showToast("Filter set to Today's posts !");

                            } else if (today == false) {
                              prefs.remove("filterWhen");
                              showToast("Filter cleard !");
                              print("removeddddddddd");
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 7, 12),
                            // padding: const EdgeInsets.all(12.0),
                            // margin: const EdgeInsets.only(right: 5),
                            height: 35,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFE0E0E0)),
                                color: today ? Color(0xFFFFEBE7)
                                            : Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0),
                                    bottomLeft: Radius.circular(0.0))),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Today",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color.fromRGBO(255, 112, 67, 1),
                                      fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              tomorrow = !tomorrow;
                              allDates = false;
                              today = false;
                              tWeek = false;
                              lWeek = false;
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            if (tomorrow == true) {
                              prefs.setString("filterWhen", "tomorrow");
                              print(prefs.getString("filterWhen"));
                              showToast("Filter set to Upcoming posts !");

                            } else if (tomorrow == false) {
                              prefs.remove("filterWhen");
                              showToast("Filter cleard !");
                              print("removeddddddddd");
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 7, 12),
                            // padding: const EdgeInsets.all(12.0),
                            // margin: const EdgeInsets.only(right: 5),
                            height: 35,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFE0E0E0)),
                                color:
                                    tomorrow ? Color(0xFFFFEBE7)
                                            : Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0),
                                    bottomLeft: Radius.circular(0.0))),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "tomorrow",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color.fromRGBO(255, 112, 67, 1),
                                      fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              tWeek = !tWeek;
                              allDates = false;
                              today = false;
                              tomorrow = false;
                              lWeek = false;
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            if (tWeek == true) {
                              prefs.setString("filterWhen", "tweek");
                              print(prefs.getString("filterWhen"));
                              showToast("Filter set to posts from This Week !");

                            } else if (tWeek == false) {
                              prefs.remove("filterWhen");
                              showToast("Filter cleard !");
                              print("removeddddddddd");
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 7, 12),
                            // padding: const EdgeInsets.all(12.0),
                            // margin: const EdgeInsets.only(right: 5),
                            height: 35,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFE0E0E0)),
                                color: tWeek ? Color(0xFFFFEBE7)
                                            : Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0),
                                    bottomLeft: Radius.circular(0.0))),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "This Week",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color.fromRGBO(255, 112, 67, 1),
                                      fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              lWeek = !lWeek;
                              allDates = false;
                              today = false;
                              tomorrow = false;
                              tWeek = false;
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            if (lWeek == true) {
                              prefs.setString("filterWhen", "lweek");
                              print(prefs.getString("filterWhen"));
                              showToast("Filter set to posts from Last Week !");
                              
                            } else if (lWeek == false) {
                              prefs.remove("filterWhen");
                              showToast("Filter Cleard !");
                              print("removeddddddddd");
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 7, 12),
                            // padding: const EdgeInsets.all(12.0),
                            // margin: const EdgeInsets.only(right: 5),
                            height: 35,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFE0E0E0)),
                                color: lWeek ? Color(0xFFFFEBE7)
                                            : Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0),
                                    bottomRight: Radius.circular(50.0),
                                    bottomLeft: Radius.circular(0.0))),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Last Week",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color.fromRGBO(255, 112, 67, 1),
                                      fontSize: 13),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildExpansionHeader(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  changeIcon() {
    setState(() {
      isExpanded = "false";
    });
    print(isExpanded);
  }

  showToast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xFFFF6038),
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
