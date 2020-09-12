import 'package:flutter/material.dart';
import 'package:folk/utils/HelperWidgets/buttons.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';
import 'package:folk/pages/Profile_Page/activities_screen.dart';
import 'package:folk/pages/HomePage/Home.dart';

class DiscoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: new Color.fromRGBO(255, 137, 96, 1.0),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          new GestureDetector(
            onTap: () {
              Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ActivitiesScreen()));
            },
            child: Container(
              margin: EdgeInsets.all(5),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)
                  // borderRadius: BorderRadius.all(Radius.circular(45))
                  ),
              child: Center(
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new AssetImage('assets/images/Filters.png')),
                  ),
                ),
              ),
            ),
          ),
        ],
        title: Text(
          "Discover",
          style: TextStyle(
            fontSize: 34,
          ),
        ),
      ),
      body: new Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 137, 96, 1.0),
                Color.fromRGBO(255, 98, 165, 1),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
                0.2,
                0.8,
              ]),
        ),
        alignment: Alignment.center,
        child: DiscoverCard(),
      ),
    );
  }
}

class DiscoverCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        width: 320,
        height: 570,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 200,
              child: Stack(
                // alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    width: 320,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 137, 96, 1),
                          Color.fromRGBO(255, 98, 165, 1)
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Image(
                          image: AssetImage(
                              "assets/images/discover_popup_purchase.png"),
                          height: 180,
                        ),
                        CircleUser(
                          size: 150,
                          url:
                              "https://hips.hearstapps.com/ell.h-cdn.co/assets/16/41/980x980/square-1476463747-coconut-oil-final-lowres.jpeg?resize=480:*",
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 140, 0, 0),
                      child: Image(
                        image: AssetImage(
                            "assets/images/discover_event_over_bannar.png"),
                        width: 280,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      "City of Lights",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Sun, 10 Mar at 21",
                    style: TextStyle(fontSize: 17, color: Colors.grey),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Share your feedback",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Please take few seconds to evaluate the people's attendance to the event. Your results will be used to determine the trust score.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: RoundedBorderButton(
                      "SHARE FEEDBACK",
                      color1: Color.fromRGBO(255, 94, 58, 1),
                      color2: Color.fromRGBO(255, 149, 0, 1),
                      shadowColor: Colors.transparent,
                      width: 250,
                      height: 50,
                      textColor: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: RoundedBorderButton(
                      "Skip",
                      color1: Colors.transparent,
                      color2: Colors.transparent,
                      shadowColor: Colors.transparent,
                      width: 250,
                      height: 50,
                      textColor: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
