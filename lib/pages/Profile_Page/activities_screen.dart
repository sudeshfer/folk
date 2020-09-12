import 'package:flutter/material.dart';
import 'package:folk/pages/DiscoverPages/discover_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/pages/DiscoverPages/SwipeAnimation/index.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';

class ActivitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildActivitiesPageAppBar(context),
      body: ListView(
        children: <Widget>[UserBox(width: width), ShowMeBox(), FreeToBox()],
      ),
    );
  }

  AppBar buildActivitiesPageAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      centerTitle: true,
      title: Text(
        "Dating Filters",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DiscoverPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.check),
          ),
        )
      ],
      backgroundColor: Colors.white,
    );
  }
}

class FreeToBox extends StatefulWidget {
  const FreeToBox({
    Key key,
  }) : super(key: key);

  @override
  _FreeToBoxState createState() => _FreeToBoxState();
}

class _FreeToBoxState extends State<FreeToBox> {
  String choice;
  @override
  Widget build(BuildContext context) {
    List<String> imgPaths = [
      "assets/images/Orion_taco.png",
      "assets/images/Orion_cocktail.png",
      "assets/images/Orion_movie-clapperboard.png",
      "assets/images/Orion_camping-tent.png",
      "assets/images/Orion_flip-flops.png",
      "assets/images/Orion_watch.png",
    ];
    return Container(
      // color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
              child: Text(
                "I'm free to...",
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            // color: Colors.grey[200],
            child: Column(
              children: <Widget>[
                buildChoiceBox("Grabbing a bite", imgPaths[0]),
                buildChoiceBox("Getting a drink", imgPaths[1]),
                buildChoiceBox("Catching a movie", imgPaths[2]),
                buildChoiceBox("Going out", imgPaths[3]),
                buildChoiceBox("Going for a walk", imgPaths[4]),
                buildChoiceBox("Going for a run", imgPaths[5]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildChoiceBox(String text, String path) {
    return GestureDetector(
      onTap: () {
        setState(() {
          choice = text;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[100],
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Icon(
                Icons.radio_button_checked,
                color: (choice == text) ? Colors.deepOrange : Colors.grey[300],
                size: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Image(
                image: AssetImage(path),
                height: 40,
              ),
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class ShowMeBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey[200],
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
            child: Text(
              "Show me",
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ShowMeButton(
                text: "Single",
                icon: FontAwesomeIcons.glassMartiniAlt,
              ),
              ShowMeButton(
                text: "Group",
                icon: FontAwesomeIcons.users,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ShowMeButton extends StatefulWidget {
  final String text;
  final IconData icon;
  const ShowMeButton({
    @required this.text,
    @required this.icon,
    Key key,
  }) : super(key: key);

  @override
  _ShowMeButtonState createState() => _ShowMeButtonState();
}

class _ShowMeButtonState extends State<ShowMeButton> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: (isSelected) ? Colors.white : Colors.grey[200],
              ),
              color: (isSelected) ? Colors.deepOrange : Colors.white,
            ),
            child: Center(
              child: FaIcon(
                widget.icon,
                size: 30,
                color: (isSelected) ? Colors.white : Colors.grey[800],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            widget.text,
            style: TextStyle(
                fontSize: 12,
                color: (isSelected) ? Colors.deepOrange : Colors.black),
          ),
        )
      ],
    );
  }
}

class UserBox extends StatelessWidget {
  const UserBox({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      // color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            // color: Colors.red[100],
            height: 100,
            width: 110,
            child: Stack(
              children: <Widget>[
                CircleUser(
                  size: 100,
                  url:
                      "https://image.shutterstock.com/image-photo/portrait-smiling-red-haired-millennial-260nw-1194497251.jpg",
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey[200],
                      ),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.glassMartiniAlt,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              // color: Colors.grey[500],
              width: width - 160,
              child: Center(
                child: Text(
                  "Let the folks know the activity you wish to do!",
                  textAlign: TextAlign.center,
                ),
              ))
        ],
      ),
    );
  }
}
