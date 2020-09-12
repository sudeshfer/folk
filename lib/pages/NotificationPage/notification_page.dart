import 'package:flutter/material.dart';
import 'package:folk/Utils/HelperWidgets/buttons.dart';
import 'package:folk/Utils/HelperWidgets/circle_user.dart';
import 'package:folk/Utils/MainWigets/bottomAppBar.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      bottomNavigationBar: BottomBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          FollowRequests(),
          JoinedEvent(),
          LikedPostComment(
            name: "Riy Wills",
            action: "commented",
            postOrComment: "post",
            content: "«this is awesome»",
          ),
          NotificationCardWithBtn(
            name: "Allie Hall",
            content: "started following you",
            time: "8 min",
            trailing: RoundedBorderButton(
              "FOLLOW",
              color1: Color.fromRGBO(255, 94, 58, 1),
              color2: Color.fromRGBO(255, 149, 0, 1),
              textColor: Colors.white,
              width: 100,
              shadowColor: Colors.transparent,
            ),
          ),
          LikedPostComment(
            name: "Lindesy Adrens",
            howMany: "21",
            action: "liked",
            postOrComment: "post",
            content: "<<Wow, great shot!>>",
          ),
          LikedPostComment(
            name: "Andrew Mills",
            action: "liked",
            postOrComment: "comment",
            content: "«Lindsey, this is awesome news!»",
          ),
          NotificationCardWithBtn(
            name: "Tyler Olson",
            content: "has accepted your follower's request",
            time: "8 min",
            trailing: RoundedBorderButton(
              "MESSAGE",
              color1: Colors.grey[100],
              color2: Colors.grey[100],
              textColor: Colors.blueGrey[700],
              width: 100,
              shadowColor: Colors.transparent,
            ),
          ),
          NotificationCardWithBtn(
            name: "Allie Hall",
            content: "started following you",
            time: "8 min",
            trailing: RoundedBorderButton(
              "FOLLOW",
              color1: Color.fromRGBO(255, 94, 58, 1),
              color2: Color.fromRGBO(255, 149, 0, 1),
              textColor: Colors.white,
              width: 100,
              shadowColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          print("go back");
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        "Notifications",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}

class FollowRequests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/profilefollowers2");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      child: Stack(
                        children: <Widget>[
                          CircleUser(
                            withBorder: false,
                            size: 50,
                            url:
                                "https://pixinvent.com/demo/vuexy-vuejs-admin-dashboard-template/demo-3/img/user-13.005c80e1.jpg",
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: 20,
                              width: 20,
                              child: Center(
                                  child: Text(
                                "1",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              )),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepOrange,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Follow Requests",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Approve or ignore requests",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Divider(
            color: Colors.grey[100],
            thickness: 2,
          )
        ],
      ),
    );
  }
}

class JoinedEvent extends StatelessWidget {
  final String name;
  final String image;
  final String eventName;
  final String eventDate;
  final String time;

  const JoinedEvent(
      {this.name = "You Joined Event",
      this.image =
          "https://www.portanova.nl/wp-content/uploads/2018/12/PN-Sara-Crookston-rose-boutique-shoot-lowres-small-38.jpg",
      this.eventName = "Win 2 tickets to WWE @MSG",
      this.eventDate = "SUN, MAR. 25 - 4:30 PM EST",
      this.time = "5 min"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              Icons.star_border,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 200,
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(eventName),
                        Text(
                          eventDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class LikedPostComment extends StatelessWidget {
  final String name;
  final String howMany;
  final String action;
  final String postOrComment;
  final String content;

  const LikedPostComment(
      {@required this.name,
      this.howMany = "",
      @required this.action,
      @required this.postOrComment,
      this.content = ""});

  @override
  Widget build(BuildContext context) {
    return NotificationCard(
      name: name,
      content: <TextSpan>[
        TextSpan(
          text: (howMany != "") ? "and " : "",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        TextSpan(
          text: (howMany != "") ? "$howMany others " : "",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: "$action your ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        TextSpan(
          text: "$postOrComment ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: "$content",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
      time: "8 min",
    );
  }
}

class NotificationCard extends StatelessWidget {
  final bool withBorder;
  final double padding;
  final String name;
  final List<TextSpan> content;
  final String time;

  const NotificationCard(
      {@required this.name,
      @required this.content,
      @required this.time,
      this.withBorder = false,
      this.padding = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(padding, padding, padding, padding + 10),
      // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleUser(
                withBorder: withBorder,
                size: 50,
                url:
                    "https://pixinvent.com/demo/vuexy-vuejs-admin-dashboard-template/demo-3/img/user-13.005c80e1.jpg",
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - padding * 2 - 70,
                    child: RichText(
                      text: TextSpan(
                          text: "$name ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: content),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationCardWithBtn extends StatelessWidget {
  final Widget trailing;
  final bool withBorder;
  final double padding;
  final String name;
  final String content;
  final String time;

  const NotificationCardWithBtn(
      {@required this.name,
      @required this.content,
      @required this.time,
      @required this.trailing,
      this.withBorder = false,
      this.padding = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(padding, padding, padding, padding),
      // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleUser(
                withBorder: withBorder,
                size: 50,
                url:
                    "https://pixinvent.com/demo/vuexy-vuejs-admin-dashboard-template/demo-3/img/user-13.005c80e1.jpg",
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width:
                        MediaQuery.of(context).size.width - padding * 2 - 170,
                    child: RichText(
                      text: TextSpan(
                          text: "$name ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: content,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing,
        ],
      ),
    );
  }
}
