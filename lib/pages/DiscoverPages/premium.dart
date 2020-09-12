import 'package:flutter/material.dart';
import 'package:folk/Utils/HelperWidgets/buttons.dart';

class PrimiumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/hi_folks_page");
            },
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Upper(),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.lens,
                    color: Colors.grey[200],
                    size: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.lens,
                    color: Colors.grey[200],
                    size: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.lens,
                    color: Colors.grey[200],
                    size: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.lens,
                    color: Colors.grey[200],
                    size: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.lens,
                    color: Colors.grey[200],
                    size: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.lens,
                    color: Colors.deepOrange[200],
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            // color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildMonthCard(context, number: "1", cost: "19,99 \$/mese"),
                buildMonthCard(context,
                    number: "3", cost: "15,99 \$/mese", selected: true),
                buildMonthCard(context, number: "6", cost: "10,99 \$/mese"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: RoundedBorderButton(
              "DIVENTA VIP!",
              color1: Color.fromRGBO(255, 94, 58, 1),
              color2: Color.fromRGBO(255, 149, 0, 1),
              textColor: Colors.white,
              width: MediaQuery.of(context).size.width - 40,
              height: 50,
              shadowColor: Colors.transparent,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Container buildMonthCard(BuildContext context,
      {String number, String cost, bool selected = false}) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: (selected) ? Colors.blue : Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.all(10),
            height: 180,
            width: (MediaQuery.of(context).size.width - 60) / 3,
            // color: Colors.grey[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "1",
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),
                Text("mese"),
                SizedBox(height: 10),
                Text(
                  "19,99 \$/mese",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: (selected)
                ? Text(
                    "Piu popolare",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}

class Upper extends StatelessWidget {
  const Upper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 200,
      // color: Colors.grey[100],
      child: Row(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width - 120,
            child: RichText(
              text: TextSpan(
                  text: "Scopri ",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "chi ti ha valutato",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ]),
            ),
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Container(
                height: 50,
                width: 66,
                child: Row(
                  children: <Widget>[
                    Text(
                      "5",
                      style: TextStyle(fontSize: 40, color: Colors.grey[800]),
                    ),
                    Icon(
                      Icons.star,
                      size: 40,
                      color: Colors.deepOrange[200],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
