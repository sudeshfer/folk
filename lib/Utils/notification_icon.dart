import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/NotificationProvider.dart';

Widget buildNotificationBtn(BuildContext context) {
  return Stack(children: <Widget>[
    Padding(
        padding: const EdgeInsets.only(top: 4.0, right: 8.0),
        child: buildNotificationIcon(context)),
    Positioned(bottom: 32, left: 30, child: buildNotificationCount(context))
  ]);
}

Widget buildNotificationIcon(BuildContext context) {
  return Container(
    height: 44,
    width: 44,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
      ),
      // borderRadius: BorderRadius.all(Radius.circular(45))
    ),
    child: Center(
      child: Container(
        height: 25.0,
        width: 25.0,
        decoration: BoxDecoration(
          image: new DecorationImage(
              fit: BoxFit.fill,
              image: new AssetImage('assets/images/ic_notification.png')),
        ),
      ),
    ),
  );
}

Widget buildNotificationCount(BuildContext context) {
  int notificationCount = 0;
  UserModel _userModel;
   _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    Provider.of<NotificationProvider>(context, listen: false)
        .startGetNotificationsCount(_userModel.id);

   notificationCount = Provider.of<NotificationProvider>(context).notificationCount;

        print("count isssssssssssssssssssssssssssssssssssss $notificationCount");

  return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        gradient: LinearGradient(
          colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
        ),
        // borderRadius: BorderRadius.all(Radius.circular(25))
      ),
      child: Center(
          child: Text(
        "$notificationCount",
        style: TextStyle(
            fontSize: 12, color: Colors.white, fontWeight: FontWeight.w900),
      )));
}
