import 'package:flutter/material.dart';
import 'package:folk/pages/Create/create_post.dart';
import 'package:folk/pages/Create/create_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostType extends StatefulWidget {
  PostType({Key key}) : super(key: key);

  @override
  _PostTypeState createState() => _PostTypeState();
}

class _PostTypeState extends State<PostType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildHeader(context),
          _buildDevider(context),
          SizedBox(
            height: 17.0,
          ),
          _buildTitle(context),
          SizedBox(
            height: MediaQuery.of(context).size.height /15,
          ),
          _buildBtnTiles(context)
        ],
      ),
    );
  }
 Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print('Clikced on back btn');
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(),
              child: new Text('Step 1-2',
                  style: TextStyle(fontFamily: "Montserrat", fontSize: 17.0)),
            ),
            Container(
                child: Text(
              "blah",
              style: TextStyle(color: Colors.white),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildDevider(BuildContext context) {
    return Flexible(
        fit: FlexFit.loose,
        child: Container(
          margin: const EdgeInsets.only(top: 7),
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFf45d27), Color(0xFFFF8A65)],
            ),
          ),
        ));
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a New',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  // letterSpacing: 1
                  ),
            ),
            Text(
              'Select a content',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w300),
            ),
          ],
        )
      ]),
    );
  }

  Widget _buildBtnTiles(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              List nullList = [];
              clearSharedPrefValues();
              Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CreatePost(nullList)));
            },
            child: Container(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300],
                      spreadRadius: 0.5,
                      blurRadius: 10,
                      offset: Offset(
                        -2,
                        10,
                      ), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Container(
                    child: Image.asset(
                      'assets/images/createpost.png',
                      height: MediaQuery.of(context).size.height /8,
                      // width: MediaQuery.of(context).size.width / 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height /45,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateEvent()));
            },
            child: Container(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                      color: Colors.grey[300],
                      spreadRadius: 0.5,
                      blurRadius: 10,
                      offset: Offset(
                        -2,
                        10,
                      ), // changes position of shadow
                    ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Container(
                      child: Image.asset(
                        'assets/images/createvent.png',
                        height: MediaQuery.of(context).size.height /8,
                      ),
                    ),
                  ),
                )),
          ),
        ]);
  }

  clearSharedPrefValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('catString');
    prefs.remove('Postdescription');
    prefs.remove('toggleVal');
    prefs.remove('selectedDate');
    prefs.remove('typology');
    prefs.remove('isPost');
    prefs.remove('isChatGroup');
    prefs.remove("postcats");
    print("sharedPref Values Cleared ");
  }

}