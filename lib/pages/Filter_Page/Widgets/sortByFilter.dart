import 'package:flutter/material.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SortByFilter extends StatefulWidget {
  SortByFilter({Key key}) : super(key: key);

  @override
  _SortByFilterState createState() => _SortByFilterState();
}

class _SortByFilterState extends State<SortByFilter> {
   String isExpanded = "";
  bool verified = false;
  bool relevence = false;
  bool recent = false;
  bool popularity = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeSort();
  }

    initializeSort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("typology issssssssssssssss "+'${prefs.getString("filterSort")}');

    if(prefs.getString("filterSort") == ""){
       setState(() {
        recent = false;
        relevence = false;
        popularity = false;
      });
    }
    if(prefs.getString("filterSort") == "relevance"){
      setState(() {
        recent = false;
        relevence = true;
        popularity = false;
      });
    }
    if(prefs.getString("filterSort") == "recent"){
       setState(() {
        recent = true;
        relevence = false;
        popularity = false;
      });
    }
     if(prefs.getString("filterSort") == "popularity"){
       setState(() {
        popularity = true;
        relevence = false;
        recent = false;
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
                title: buildExpansionHeader("Sort by"),
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
                      padding: const EdgeInsets.only(
                          top: 16, bottom: 30.0, left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    relevence = !relevence;
                                    recent = false;
                                    popularity = false;
                                  });
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                   if (relevence == true) {
                                      prefs.setString("filterSort", "relevance");
                                      print(prefs.getString("filterSort"));
                                      showToast("Sort by relevence !");
                                    
                                    } else if (relevence == false) {
                                      prefs.remove("filterSort");
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
                                      border:
                                          Border.all(color: Color(0xFFE0E0E0)),
                                      color: relevence
                                          ? Color(0xFFFFEBE7)
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
                                        "Relevence",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    recent = !recent;
                                    relevence = false;
                                    popularity = false;
                                  });
                                  SharedPreferences prefs = await SharedPreferences.getInstance();

                                   if (recent == true) {
                                      prefs.setString("filterSort", "recent");
                                      print(prefs.getString("filterSort"));
                                      showToast("Sort by recent posts !");
                                    
                                    } else if (recent == false) {
                                      prefs.remove("filterSort");
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
                                      border:
                                          Border.all(color: Color(0xFFE0E0E0)),
                                      color: recent
                                          ? Color(0xFFFFEBE7)
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
                                        "Recent",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    popularity = !popularity;
                                    recent = false;
                                    relevence = false;
                                  });
                                  SharedPreferences prefs = await SharedPreferences.getInstance();

                                if (popularity == true) {
                                      prefs.setString("filterSort", "popularity");
                                      print(prefs.getString("filterSort"));
                                      showToast("Sort by popularity posts !");
                                    
                                    } else if (popularity == false) {
                                      prefs.remove("filterSort");
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
                                      border:
                                          Border.all(color: Color(0xFFE0E0E0)),
                                      color: popularity
                                          ? Color(0xFFFFEBE7)
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
                                        "Popularity",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color:
                                                Color.fromRGBO(255, 112, 67, 1),
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
}