import 'package:flutter/material.dart';
import 'package:folk/pages/DiscoverPages/vip_page.dart';
import 'package:folk/utils/HelperWidgets/buttons.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';

class HiFolksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 94, 58, 1),
              Color.fromRGBO(255, 149, 0, 1),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(height: 30),
            Column(
              children: <Widget>[
                Text(
                  "Hi Folks!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  "It's a match",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            buildStackedArt(width),
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VIPPage()),
                    );
                  },
                  child: RoundedBorderButton(
                    "SEND MESSAGE",
                    color1: Colors.white,
                    color2: Colors.white,
                    shadowColor: Colors.transparent,
                    width: width * 0.7,
                    height: 50,
                  ),
                ),
                SizedBox(height: 20),
                RoundedBorderButton(
                  "Skip",
                  color1: Colors.transparent,
                  color2: Colors.transparent,
                  shadowColor: Colors.transparent,
                  textColor: Colors.white,
                  width: width * 0.7,
                  height: 50,
                  fontSize: 22,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Stack buildStackedArt(double width) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        ShadowCircle(
          size: width * 0.95,
          color: Color.fromRGBO(2, 4, 51, 0.04),
        ),
        ShadowCircle(
          size: width * 0.70,
          color: Color.fromRGBO(2, 4, 51, 0.08),
        ),
        ShadowCircle(
          size: width * 0.5,
          color: Color.fromRGBO(2, 4, 51, 0.10),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, width * .4),
          child: Image(
            image: AssetImage("assets/images/Orion_flame.png"),
            height: width * .58,
          ),
        ),
        CircleUserBar(width: width),
      ],
    );
  }
}

class CircleUserBar extends StatelessWidget {
  const CircleUserBar({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * .85,
      child: Stack(
        children: <Widget>[
          AlignedCircleUser(
            Alignment(-1, 0),
            CircleUser(
              borderColor: Colors.white,
              borderThickness: 5,
              withBorder: true,
              size: width * 0.28,
              url:
                  "https://linustechtips.com/main/uploads/monthly_2017_04/cool-cat.thumb.jpg.cae04ebfb8304d3e1592f0d04c24f85d.jpg",
            ),
          ),
          AlignedCircleUser(
            Alignment(-0.33, 0),
            CircleUser(
              borderColor: Colors.white,
              borderThickness: 5,
              withBorder: true,
              size: width * 0.28,
              url:
                  "https://hips.hearstapps.com/ell.h-cdn.co/assets/16/41/980x980/square-1476463747-coconut-oil-final-lowres.jpeg?resize=480:*",
            ),
          ),
          AlignedCircleUser(
            Alignment(.33, 0),
            CircleUser(
              borderColor: Colors.white,
              borderThickness: 5,
              withBorder: true,
              size: width * 0.28,
              url:
                  "https://i.pinimg.com/236x/00/f0/85/00f0854dc796254312890d7df2b02f9c.jpg",
            ),
          ),
          AlignedCircleUser(
            Alignment(1, 0),
            CircleUser(
              borderColor: Colors.white,
              borderThickness: 5,
              withBorder: true,
              size: width * 0.28,
              url:
                  "https://hips.hearstapps.com/ell.h-cdn.co/assets/16/41/980x980/square-1476463747-coconut-oil-final-lowres.jpeg?resize=480:*",
            ),
          ),
        ],
      ),
    );
  }
}

class ShadowCircle extends StatelessWidget {
  const ShadowCircle({
    Key key,
    @required this.size,
    @required this.color,
  }) : super(key: key);

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2), color: color),
    );
  }
}
