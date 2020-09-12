import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/pages/Profile_Page/landlord_profile.dart';
import 'package:folk/utils/SearchAppBar/search_app_bar.dart';
import 'package:folk/utils/UserWidgets/user_card.dart';
import 'package:folk/utils/notification_icon.dart';

import 'utils/HelperWidgets/buttons.dart';
import 'utils/MainWigets/bottomAppBar.dart';

class EvezPeopleExplorerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SearchAppBar(
        color1: Colors.white,
        color2: Colors.grey[100],
        // leading: Container(
        //   margin: EdgeInsets.only(left:10),
        //   child: buildNotificationBtn(context),
        // ),
      ),
      bottomNavigationBar: BottomBar(
        selected: 'evezpeopleexplorer',
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
        // color: Colors.yellow[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TopFolks(width: width),
            Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Text(
                "Maybe you like",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildUserCard(context),
                  _buildUserCard(context),
                  _buildUserCard(context),
                  _buildUserCard(context),
                  _buildUserCard(context),
                  _buildUserCard(context),
                  _buildUserCard(context),
                  _buildUserCard(context),
                  _buildUserCard(context),
                  _buildUserCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildUserCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new LandlordProfile()));
      },
      child: UserCard(
        RoundedBorderButton(
          "FOLLOW",
          color1: Color.fromRGBO(255, 94, 58, 1),
          color2: Color.fromRGBO(255, 149, 0, 1),
          textColor: Colors.white,
          width: 100,
          shadowColor: Colors.transparent,
        ),
        withBorder: true,
        padding: 10,
      ),
    );
  }
}

class TopFolks extends StatelessWidget {
  const TopFolks({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Top Folks",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  "View more",
                  style: TextStyle(
                    color: Colors.deepOrange,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                )
              ],
            ),
          ],
        ),
        Container(
          height: width * 0.4 + 85,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              FolkCard(width,
                  'https://ae01.alicdn.com/kf/HTB1FwSGLpXXXXb5XVXXq6xXFXXXT/Kids-Outwear-Jacket-2017-Hot-Sale-Boys-clothes-Blazers-Kids-Long-Sleeved-Sing-breasted-Small-Boy.jpg'),
              FolkCard(width,
                  'https://ae01.alicdn.com/kf/HTB1FwSGLpXXXXb5XVXXq6xXFXXXT/Kids-Outwear-Jacket-2017-Hot-Sale-Boys-clothes-Blazers-Kids-Long-Sleeved-Sing-breasted-Small-Boy.jpg'),
              FolkCard(width,
                  'https://ae01.alicdn.com/kf/HTB1FwSGLpXXXXb5XVXXq6xXFXXXT/Kids-Outwear-Jacket-2017-Hot-Sale-Boys-clothes-Blazers-Kids-Long-Sleeved-Sing-breasted-Small-Boy.jpg'),
            ],
          ),
        )
      ],
    );
  }
}

class FolkCard extends StatelessWidget {
  final double width;
  final String url;
  const FolkCard(
    this.width,
    this.url, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new LandlordProfile()));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
        // color: Colors.yellow[100],
        width: width * 0.4 + 10,
        height: width * 0.4 + 65,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(5),
              height: width * 0.4,
              width: width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[200],
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(
                    url,
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Charlotte",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.venus,
                        size: 15,
                        color: Colors.grey[700],
                      ),
                      SizedBox(width: 5),
                      Text(
                        "25",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    "500 Followers",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
