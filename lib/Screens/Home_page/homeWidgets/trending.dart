import 'package:flutter/material.dart';

class Trending extends StatefulWidget {
  Trending({Key key}) : super(key: key);

  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                spreadRadius: 6,
                blurRadius: 6,
                offset: Offset(
                  5,
                  -2,
                ),
              )
            ]),
        margin: const EdgeInsets.only(top:4) ,
        padding: const EdgeInsets.only(top: 20.0, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                "Trending",
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
              ),
            ),
            Row(
              children: <Widget>[
                getContaniers(),
                getContaniers(),
                getContaniers(),
                getContaniers(),
              ],
            )
          ],
        ));
  }

  getContaniers() {
    return Container(
      margin: EdgeInsets.only(right: 7),
      height: 30,
      width: MediaQuery.of(context).size.width / 5.5,
      decoration: BoxDecoration(
          color: Color(0xFFffebee),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
              bottomLeft: Radius.circular(0.0))),
      child: Center(
        child: Text(
          "culture",
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: Color.fromRGBO(255, 112, 67, 1),
              fontSize: 13),
        ),
      ),
    );
  }
}
