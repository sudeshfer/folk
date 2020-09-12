import 'dart:async';
import 'package:folk/pages/DiscoverPages/SwipeAnimation/activeCard.dart';
import 'package:folk/pages/DiscoverPages/SwipeAnimation/dummyCard.dart';
import 'package:folk/utils/HelperWidgets/buttons.dart';

import 'data.dart';
//import 'package:animation_exp/PageReveal/page_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class CardDemo extends StatefulWidget {
  @override
  CardDemoState createState() => new CardDemoState();
}

class CardDemoState extends State<CardDemo> with TickerProviderStateMixin {
  AnimationController _buttonController;
  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;
  Animation<double> width;
  int flag = 0;

  List data = imageData;
  List selectedData = [];
  void initState() {
    super.initState();

    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    rotate = new Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    rotate.addListener(() {
      setState(() {
        if (rotate.isCompleted) {
          var i = data.removeLast();
          data.insert(0, i);

          _buttonController.reset();
        }
      });
    });

    right = new Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    bottom = new Tween<double>(
      begin: 15.0,
      end: 100.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    width = new Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  dismissImg(DecorationImage img) {
    setState(() {
      data.remove(img);
    });
  }

  addImg(DecorationImage img) {
    setState(() {
      data.remove(img);
      selectedData.add(img);
    });
  }

  swipeRight() {
    if (flag == 0)
      setState(() {
        flag = 1;
      });
    _swipeAnimation();
  }

  swipeLeft() {
    if (flag == 1)
      setState(() {
        flag = 0;
      });
    _swipeAnimation();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;

    double initialBottom = 15.0;
    var dataLength = data.length;
    double backCardPosition = initialBottom + (dataLength - 1) * 10;
    double backCardWidth = -10.0;
    return (new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: new Color.fromRGBO(255, 137, 96, 1.0),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          new GestureDetector(
            onTap: () {},
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
        child: dataLength > 0
            ? new Stack(
                alignment: AlignmentDirectional.center,
                children: data.map((item) {
                  if (data.indexOf(item) == dataLength - 1) {
                    return cardDemo(
                        item,
                        bottom.value,
                        right.value,
                        0.0,
                        backCardWidth + 10,
                        rotate.value,
                        rotate.value < -10 ? 0.1 : 0.0,
                        context,
                        dismissImg,
                        flag,
                        addImg,
                        swipeRight,
                        swipeLeft);
                  } else {
                    backCardPosition = backCardPosition - 10;
                    backCardWidth = backCardWidth + 10;

                    return cardDemoDummy(item, backCardPosition, 0.0, 0.0,
                        backCardWidth, 0.0, 0.0, context);
                  }
                }).toList())
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: new Text("No Discoveries Yet...",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/home");
                    },
                    child: RoundedBorderButton(
                      "HOME >>>",
                      fontSize: 18,
                      color1: Colors.white,
                      color2: Colors.white,
                      shadowColor: Colors.transparent,
                      width: 300,
                      height: 50,
                    ),
                  ),
                ],
              ),
      ),
    ));
  }
}
