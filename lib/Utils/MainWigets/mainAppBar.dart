import 'package:flutter/material.dart';
import 'package:folk/pages/NotificationPage/Notifictionpage.dart';
import 'package:folk/pages/Settings_page/setting_screen.dart';
import 'package:folk/pages/Filter_Page/FilterPage.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/NotificationProvider.dart';

class MainAppBar extends StatefulWidget {
  final BuildContext context;
  MainAppBar(this.context);

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height / 16.5,
      alignment: Alignment.center,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildNotificationBtn(context),
                _buildLogo(context),
                _buildFilterBtn(context),
              ]),
        ),
      ),
    );
  }
}

Widget _buildLogo(BuildContext context) {
  return Image.asset(
    'assets/images/logo.png',
    width: MediaQuery.of(context).size.width / 5,
    height: MediaQuery.of(context).size.height / 15,
  );
}

Widget buildSettingsButton(BuildContext context) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: [Color(0xFF020433), Color(0xFF020433)],
      ),
      // borderRadius: BorderRadius.all(Radius.circular(45))
    ),
    child: Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SettingScreen()));
        },
        child: Container(
          height: 20.0,
          width: 20.0,
          decoration: BoxDecoration(
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage('assets/images/cog.png')),
          ),
        ),
      ),
    ),
  );
}

Widget buildNotificationBtn(BuildContext context) {
  return Stack(children: <Widget>[
    Padding(
        padding: const EdgeInsets.only(top: 4.0, right: 8.0),
        child: buildNotificationIcon(context)),
    Positioned(bottom: 32, left: 32, child: buildNotificationCount(context))
  ]);
}

Widget buildNotificationIcon(BuildContext context) {
  return GestureDetector(
      onTap: () {
        // Navigator.of(context).pushNamed('/notifications');4
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NotificationPage()));
      },
      child: Container(
        height: 50,
        width: 50,
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
      ));
}

Widget buildNotificationCount(BuildContext context) {
  int notificationCount = 0;
  UserModel _userModel;
   _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    Provider.of<NotificationProvider>(context, listen: false)
        .startGetNotificationsCount(_userModel.id);

   notificationCount = Provider.of<NotificationProvider>(context).notificationCount;

        print("count isssssssssssssssssssssssssssssssssssss $notificationCount");
  // String notificationCount = "0";

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

Widget _buildFilterBtn(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilterPage(),
        ),
      );
      // Navigator.of(context).pushNamed('/filter');
    },
    child: Container(
      height: MediaQuery.of(context).size.height / 16,
      width: MediaQuery.of(context).size.width / 8.5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF020433), Color(0xFF020433)],
        ),
        // borderRadius: BorderRadius.all(Radius.circular(45))
      ),
      child: Center(
        child: Container(
          height: 20.0,
          width: 20.0,
          decoration: BoxDecoration(
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage('assets/images/Filters.png')),
          ),
        ),
      ),
    ),
  );
}
