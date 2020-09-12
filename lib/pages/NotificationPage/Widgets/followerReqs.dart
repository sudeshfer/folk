import 'package:flutter/material.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';
import 'package:folk/pages/NotificationPage/profile_followers_2_page.dart';

class FollowRequests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ProfileFollowers2Page()));
            },
          child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
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
            SizedBox(height: 10),
            Divider(
              color: Colors.grey[100],
              thickness: 2,
            )
          ],
        ),
      ),
    );
  }
}