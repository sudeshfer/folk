import 'package:flutter/material.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TypologyFilter extends StatefulWidget {
  TypologyFilter({Key key}) : super(key: key);

  @override
  _TypologyFilterState createState() => _TypologyFilterState();
}

class _TypologyFilterState extends State<TypologyFilter> {
   String isExpanded = "";
  bool verified = false;
  bool isPost = false;
  bool isChatGroup = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeTypology();
  }

  initializeTypology() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("typology issssssssssssssss "+'${prefs.getString("filterTypology")}');

    if(prefs.getString("filterTypology") == ""){
      print("huttooooooooooooo");
       setState(() {
        isChatGroup = false;
        isPost = false;
      });
    }
    if(prefs.getString("filterTypology") == "all"){
      setState(() {
        isChatGroup = true;
        isPost = true;
      });
    }
    if(prefs.getString("filterTypology") == "post"){
       setState(() {
        isChatGroup = false;
        isPost = true;
      });
    }
     if(prefs.getString("filterTypology") == "chatgroup"){
       setState(() {
        isChatGroup = true;
        isPost = false;
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
                title: buildExpansionHeader("Typology"),
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
                                    isPost = !isPost;
                                  });
                                  SharedPreferences prefs = await SharedPreferences.getInstance();

                                  if(isPost== true && isChatGroup == true){
                                    
                                    prefs.setString("filterTypology", "all");
                                    print(prefs.getString("filterTypology"));
                                    showToast("Filter set to All typologies !");

                                  }else if(isPost == true && isChatGroup == false){
                                    prefs.setString("filterTypology", "post");
                                    print(prefs.getString("filterTypology"));
                                    showToast("Typology Filter set to Posts !");

                                  }else if(isPost == false && isChatGroup == false){
                                    prefs.remove("filterTypology");
                                    print("removeddddddddd");
                                    showToast("Typology Filter cleard !");
                                  }
                                  else if(isPost == false){
                                    prefs.setString("filterTypology", "chatgroup");
                                    print(prefs.getString("filterTypology"));
                                    showToast("Typology Filter set to ChatGroups !");
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
                                      color: isPost
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
                                        "Post",
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
                                    isChatGroup = !isChatGroup;
                                  });
                                  SharedPreferences prefs = await SharedPreferences.getInstance();

                                  if(isPost== true && isChatGroup == true){
                                    
                                    prefs.setString("filterTypology", "all");
                                    print(prefs.getString("filterTypology"));
                                    showToast("Filter set to All typologies !");

                                  }else if(isPost == false && isChatGroup == true){
                                    prefs.setString("filterTypology", "chatgroup");
                                    print(prefs.getString("filterTypology"));
                                    showToast("Typology Filter set to ChatGroups !");
                                  }
                                  else if(isPost == false && isChatGroup == false){
                                    prefs.remove("filterTypology");
                                    showToast("Typology Filter cleard !");
                                    print("removeddddddddd");
                                  }
                                  else if(isChatGroup == false){
                                    prefs.setString("filterTypology", "post");
                                    print(prefs.getString("filterTypology"));
                                    showToast("Typology Filter set to Posts !");
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
                                      color: isChatGroup
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
                                        "Chat Group",
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