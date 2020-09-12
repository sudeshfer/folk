//created by Suthura

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folk/pages/NotificationPage/profile_followers_2_page.dart';
import 'package:folk/pages/ProfileFollowersPage/profile_followers_page.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/NotificationModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/NotificationProvider.dart';
import 'package:folk/widgets/NotificationItem.dart';
import 'package:folk/pages/NotificationPage/Widgets/followerReqs.dart';
import 'package:folk/utils/HelperWidgets/noNotificationsMsg.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:folk/utils/Constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> _listNotification = [];
  UserModel _userModel;
  bool isfetched = true;

  @override
  void initState() {
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    Provider.of<NotificationProvider>(context, listen: false)
        .startGetNotificationsData(_userModel.id)
        .then((profileFromServer) {
      print(profileFromServer.length);
      if (profileFromServer.isNotEmpty) {
        setState(() {
          _listNotification = profileFromServer;
          isfetched = false;
          // isEmpty = false;
        });
      } else {
        setState(() {
          isfetched = false;
          // isEmpty = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // _listNotification = [];
    // _listNotification =
    //     Provider.of<NotificationProvider>(context).listNotification;
    // if (_listNotification.isNotEmpty) {
    //   setState(() {
    //     isfetched = false;
    //   });
    // }

    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          FollowRequests(),
          Expanded(
            child: isfetched
                ? CardListSkeleton(
                    style: SkeletonStyle(
                      theme: SkeletonTheme.Light,
                      isShowAvatar: true,
                      isCircleAvatar: true,
                      barCount: 3,
                    ),
                  )
                : _listNotification.length == 0
                    ? NoNotificationsMsg()
                    : Column(
                        children: [
                          Expanded(
                              child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, i) {
                              return NotificationItem(_listNotification[i]);
                            },
                            shrinkWrap: true,
                            itemCount: _listNotification.length,
                          )),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
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
