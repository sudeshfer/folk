import 'package:flutter/material.dart';
import 'package:folk/pages/DiscoverPages/hi_folks_page.dart';
import 'package:folk/pages/Profile_Page/activities_screen.dart';
import 'package:folk/utils/HelperWidgets/buttons.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';

class VIPPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromRGBO(255, 97, 163, 1),
        title: Text("VIP Center"),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Color.fromRGBO(255, 97, 163, 1),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                height: height - 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(255, 97, 163, 1),
                      Color.fromRGBO(90, 82, 242, 1),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // SizedBox(height: 2),
                    VIPArt(),
                    Column(
                      children: <Widget>[
                        Text(
                          "Congratulations",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Expiration Date: April 31, 2019 ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ActivitiesScreen()),
                        );
                      },
                      child: RoundedBorderButton(
                        "RENEWAL",
                        color1: Color.fromRGBO(255, 94, 58, 1),
                        color2: Color.fromRGBO(255, 149, 0, 1),
                        shadowColor: Colors.transparent,
                        width: width * 0.7,
                        height: 50,
                        textColor: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(120, 10, 120, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        height: 8,
                      ),
                    ),
                  ],
                ),
              ),
              buildVIPPrivilege(),
            ],
          ),
        ],
      ),
    );
  }

  Container buildVIPPrivilege() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/images/ic_crown.png"),
                  height: 20,
                ),
                SizedBox(width: 10),
                Text(
                  "VIP PRIVILEGE",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          PrivilegeRow(
            title: "See who liked you",
            subTitle: "You'll see everyone who liked you",
            assetPath: "assets/images/ic_vip_heart.png",
          ),
          PrivilegeRow(
            title: "See who visited you",
            subTitle: "You'll see everyone who liked you",
            assetPath: "assets/images/ic_vip_eye.png",
          ),
          PrivilegeRow(
            title: "Unlimited rewinds",
            subTitle: "You'll can rewind and reswipe the last persons",
            assetPath: "assets/images/ic_vip_refresh.png",
          ),
          PrivilegeRow(
            title: "Incognito mode",
            subTitle: "You can browse others anonymously",
            assetPath: "assets/images/ic_vip_incognito.png",
          ),
          PrivilegeRow(
            title: "Extra superlikes",
            subTitle: "You can superlike up to 5 times a day",
            assetPath: "assets/images/ic_vip_star.png",
          ),
          PrivilegeRow(
            title: "Spotlight",
            subTitle: "You'll see everyone who liked you",
            assetPath: "assets/images/ic_vip_flame.png",
          ),
        ],
      ),
    );
  }
}

class PrivilegeRow extends StatelessWidget {
  final String title;
  final String subTitle;
  final String assetPath;

  PrivilegeRow({
    @required this.title,
    @required this.subTitle,
    @required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 15, 10),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Image(
                  image: AssetImage(assetPath),
                ),
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(64, 75, 105, 1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class VIPArt extends StatelessWidget {
  const VIPArt({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 150),
          child: Image(
            image: AssetImage("assets/images/decoration_vip.png"),
            height: 200,
          ),
        ),
        ShadowCircle(
          size: 200,
          color: Colors.white.withOpacity(0.05),
        ),
        ShadowCircle(
          size: 170,
          color: Colors.white.withOpacity(0.1),
        ),
        ShadowCircle(
          size: 140,
          color: Colors.white.withOpacity(0.15),
        ),
        CircleUser(
          size: 120,
          url:
              "https://hips.hearstapps.com/ell.h-cdn.co/assets/16/41/980x980/square-1476463747-coconut-oil-final-lowres.jpeg?resize=480:*",
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 140, 0, 0),
          child: Image(
            image: AssetImage("assets/images/vip_member_bannar.png"),
            width: 240,
          ),
        )
      ],
    );
  }
}
