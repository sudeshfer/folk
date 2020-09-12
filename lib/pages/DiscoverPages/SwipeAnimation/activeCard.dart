import 'dart:math';
import 'package:flutter/material.dart';
import 'package:folk/utils/HelperWidgets/buttons.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';

Positioned cardDemo(
    DecorationImage img,
    double bottom,
    double right,
    double left,
    double cardWidth,
    double rotation,
    double skew,
    BuildContext context,
    Function dismissImg,
    int flag,
    Function addImg,
    Function swipeRight,
    Function swipeLeft) {
  double screenHeight = MediaQuery.of(context).size.height;

  return new Positioned(
    bottom: screenHeight * 0.1,
    right: flag == 0 ? right != 0.0 ? right : null : null,
    left: flag == 1 ? right != 0.0 ? right : null : null,
    child: new Dismissible(
      key: new Key(new Random().toString()),
      crossAxisEndOffset: -0.3,
      onResize: () {},
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart)
          dismissImg(img);
        else
          addImg(img);
      },
      child: new Transform(
        alignment: flag == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
        transform: new Matrix4.skewX(skew),
        child: new RotationTransition(
          turns: new AlwaysStoppedAnimation(
              flag == 0 ? rotation / 360 : -rotation / 360),
          child: new GestureDetector(
            onTap: () {
              // Navigator.of(context).push(
              //   new PageRouteBuilder(
              //     pageBuilder: (_, __, ___) => new DetailPage(type: img),
              //   ),
              // );
            },
            child: buildDiscoverCard(swipeLeft, swipeRight),
          ),
        ),
      ),
    ),
  );
}

Center buildDiscoverCard(Function swipeLeft, Function swipeRight) {
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
                  onTap: () {
                    swipeRight();
                  },
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
                    swipeLeft();
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
