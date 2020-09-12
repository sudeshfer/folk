import 'package:flutter/material.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:folk/Utils/HelperWidgets/ratings_bar.dart';
import 'package:folk/pages/Filter_Page/Widgets/categoryFilter.dart';
import 'package:folk/pages/Filter_Page/Widgets/sortByFilter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:folk/pages/HomePage/Home.dart';
import 'package:folk/pages/Filter_Page/Widgets/whenFIlter.dart';
import 'package:folk/pages/Filter_Page/Widgets/typologyFilter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String isExpanded = "";
  bool verified = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("filterTypology");
              prefs.remove("filterWhen");
              prefs.remove("filterSort");
              prefs.remove("cats");
              prefs.remove("categoryAll");
              Fluttertoast.showToast(
                  msg: "All the Filters are Cleard !",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Color(0xFFFF6038),
                  textColor: Colors.white,
                  fontSize: 16.0);
                  // Navigator.of(context).pop();
                  Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => FilterPage()));

              print("removeddddddddd");
            },
            child: Center(
              child: Text(
                "Clear",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 8)
        ],
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Home()));
          },
        ),
        centerTitle: true,
        title: Text(
          "Filter",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SortByFilter(),
          WhenFilter(),
          TypologyFilter(),
          CategoryFilter(),
          // buildFadeAnimation(context, "Categories",
          //     ["All Categories", "Culture", "Culture", "Culture"]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 40, 10, 0),
                child: Text(
                  "Rating",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: RatingsBar(3),
              )
            ],
          ),
          SizedBox(height: 10),
          Container(
            child: Row(
              children: <Widget>[
                SizedBox(width: 20),
                Checkbox(
                    value: verified,
                    onChanged: (value) {
                      setState(() {
                        verified = value;
                      });
                    }),
                Text(
                  "Only verified profiles",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 30),
          
          // SizedBox(height: 30),
        ],
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 8,
                child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Home()));
                },
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 15,
                    width: MediaQuery.of(context).size.width * .65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      // color: Color.fromRGBO(255, 94, 58, 1),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 94, 58, 1),
                          Color.fromRGBO(255, 149, 0, 1)
                        ],
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "SHOW 100+ EVENTS",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ),
              ),
      ),
    );
  }

  FadeAnimation buildFadeAnimation(
      BuildContext context, String title, List<String> itemList) {
    return FadeAnimation(
      0.9,
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 18),
        child: ExpansionTile(
          title: buildExpansionHeader(title),
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
                      children: _buildRowList(itemList)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRowList(List<String> itemList) {
    List<Widget> items = []; // this will hold Rows according to available lines
    for (var i in itemList) {
      items.add(buildInterestContainor(context, i));
    }
    return items;
  }

  changeIcon() {
    setState(() {
      isExpanded = "false";
    });
    print(isExpanded);
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

  Widget buildInterestContainor(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 7, 12),
      // padding: const EdgeInsets.all(12.0),
      // margin: const EdgeInsets.only(right: 5),
      height: 35,
      width: MediaQuery.of(context).size.width * 0.03 * (title.length + 1),
      decoration: BoxDecoration(
          color: Color(0xFFffebee),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
              bottomLeft: Radius.circular(0.0))),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: Color.fromRGBO(255, 112, 67, 1),
                fontSize: 13),
          ),
        ),
      ),
    );
  }
}
