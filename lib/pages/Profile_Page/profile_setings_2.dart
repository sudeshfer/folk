import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/Utils/HelperWidgets/buttons.dart';

class ProfileSettings2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          TrustScoreBox(),
          MissionsBox(),
          InfractionsBox(),
        ],
      ),
    );
  }
}

class InfractionsBox extends StatelessWidget {
  const InfractionsBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      // color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Infractions",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          Text(
              "Reset code was sent to your email.Please enter the code and create new password."),
          SizedBox(height: 20),
          MissionItem(
            text: "1 Abandoned Chats or Events",
            color: Colors.red[700],
          ),
          MissionItem(
            text: "5 Abandoned Chats or Events",
            isChecked: false,
            trailingText: "- 50 %",
          ),
        ],
      ),
    );
  }
}

class MissionsBox extends StatelessWidget {
  const MissionsBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      // color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Missions",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          Text(
              "Reset code was sent to your email.Please enter the code and create new password."),
          SizedBox(height: 20),
          MissionItem(text: "Verify the email"),
          MissionItem(text: "Verify the email"),
          MissionItem(
            text: "Verify the email",
            isChecked: false,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: 40,
                width: 180,
                child: RoundedBorderButton(
                  "SHOW MORE...",
                  color1: Color.fromRGBO(255, 94, 58, 1),
                  color2: Color.fromRGBO(255, 149, 0, 1),
                  textColor: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MissionItem extends StatelessWidget {
  final String text;
  final bool isChecked;
  final Color color;
  final String trailingText;
  MissionItem({
    @required this.text,
    this.isChecked = true,
    this.color = Colors.deepOrange,
    this.trailingText = "+ 5 %",
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Image(
                    image: AssetImage("assets/images/achivement.png"),
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  color: (isChecked) ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
          (isChecked)
              ? FaIcon(
                  FontAwesomeIcons.solidCheckCircle,
                  color: color,
                  size: 30,
                )
              : Text(
                  trailingText,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
        ],
      ),
    );
  }
}

class TrustScoreBox extends StatelessWidget {
  const TrustScoreBox({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      // color: Colors.grey[100],
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "Trust Score",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 20),
              Container(
                height: 30,
                width: 90,
                // padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.deepOrange),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Text(
                        "50%",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Text(
                "Reset code was sent to your email.Please enter the code and create new password."),
          ),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(255, 94, 58, 1),
                      Color.fromRGBO(255, 149, 0, 1),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 120,
                          height: 10,
                          color: Colors.grey[100],
                        ),
                        Container(
                          width:
                              (MediaQuery.of(context).size.width - 120) * 0.5,
                          height: 10,
                          color: Colors.deepOrange,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(
                      "Missions & Achievements: 20",
                      style: TextStyle(
                        color: Colors.deepOrange,
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
