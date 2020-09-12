import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/Utils/HelperWidgets/circle_user.dart';

class UserCard extends StatelessWidget {
  final Widget trailing;
  final bool withBorder;
  final double padding;
  final double width;

  const UserCard(this.trailing,
      {this.withBorder = false, this.padding = 20, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(padding, padding / 2, padding, padding / 2),
      // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleUser(
                withBorder: withBorder,
                size: 60,
                url:
                    "https://pixinvent.com/demo/vuexy-vuejs-admin-dashboard-template/demo-3/img/user-13.005c80e1.jpg",
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: width,
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Susie Jenkins",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
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
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
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
                    )
                  ],
                ),
              ),
            ],
          ),
          trailing,
        ],
      ),
    );
  }
}
