//created by Suthura


import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:folk/pages/UpdateUserInfo.dart';
import 'package:folk/pages/UserChangePasswordPage.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/pages/PeerProfile.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:folk/pages/WelcomePage.dart';
import 'package:folk/utils/Constants.dart';
// import 'UserChangePasswordPage.dart';
// import 'UpdateUserInfo.dart';

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  UserModel userModel;

  String likes = "";

  String posts = "";

  String comments = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    startGetCommentLikesPostsCount();
  }

  startGetCommentLikesPostsCount() async {
    var req = await http.post(
        '${Constants.SERVER_URL}user/get_likes_posts_comments_counts',
        body: {'user_id': userModel.id});
    var res = convert.jsonDecode(req.body);
    if (!res['error']) {
      setState(() {
        likes = res['likes'];
        posts = res['posts'];
        comments = res['comments'];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    const Color gradientStart = const Color(0xFFfbab66);
    const Color gradientEnd = const Color(0xFFf7418c);

    Widget _buildIconTile(
        IconData icon, Color color, String title, var trailing) {
      return ListTile(

        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Container(
          height: 30.0,
          width: 30.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
        trailing: trailing,
      );
    }

    final userImage = Container(
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(Constants.USERS_PROFILES_URL + userModel.img),
          fit: BoxFit.cover,
        ),
        shape: BoxShape.circle,
      ),
    );
    final hr = Divider();
    Widget _buildUserStats(String name, String value) {
      return Column(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
              color: Colors.grey.withOpacity(0.6),
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20.0,
            ),
          ),
        ],
      );
    }

    final userStats = Positioned(
      bottom: 10.0,
      left: 40.0,
      right: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildUserStats('COMMENTS', comments),
          _buildUserStats('LIKED',likes),
          _buildUserStats('POSTS', posts),
        ],
      ),
    );
    final userNameLocation = Container(
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              userModel.name,
              maxLines: 1,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '${userModel.bio}',
              maxLines: 2,
              style: TextStyle(
                color: Colors.grey.withOpacity(0.6),
                fontSize: 15,

                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
    final userInfo = Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              height: 220.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    userImage,
                    SizedBox(width: 10.0),
                    userNameLocation
                  ],
                ),
              ),
            ),
          ),
        ),
        userStats
      ],
    );
    final _switchTheme = Container(
      child: Switch(
        value: themeProvider.isLightTheme,
        onChanged: (val) {
          saveToShared(val);
          themeProvider.setThemeData = val;
        },
      ),
    );
    final secondCard = Padding(
      padding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 30.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => PeerProfile(userModel.id)));
                },
                child: _buildIconTile(LineIcons.user, Colors.red, 'Profile',
                    Icon(LineIcons.chevron_circle_right)),
              ),
              hr,
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => UpdateUserInfo()));
                },
                child: _buildIconTile(LineIcons.upload, Colors.green, 'Update Info',
                    Icon(LineIcons.chevron_circle_right)),
              ),
              hr,
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => UserChangePasswordPage()));
                },
                child: _buildIconTile(LineIcons.eye, Colors.purpleAccent,
                    'Change Password', Icon(LineIcons.chevron_circle_right)),
              ),
              hr,
              _buildIconTile(Icons.brightness_6, Colors.purpleAccent,
                  'Change Theme', _switchTheme),
              hr,
              InkWell(
                onTap: (){
                  startLogOut();
                },
                child: _buildIconTile(Icons.exit_to_app, Colors.purpleAccent, 'Log out',
                    Icon(LineIcons.chevron_circle_right)),
              ),
            ],
          ),
        ),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 350.0,
                    ),
                    Container(
                      height: 250.0,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: const [gradientStart, gradientEnd],
                        stops: const [0.0, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                    ),
                    Positioned(top: 100, right: 0, left: 0, child: userInfo)
                  ],
                ),
                secondCard,
              ],
            ),
          )

        ],
      ),
    );
  }

  void startLogOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString('_id', null);
    sharedPreferences.setString('name', null);
    sharedPreferences.setString('email', null);
    sharedPreferences.setString('password', null);
    // Provider.of<AuthProvider>(context, listen: false).socket.disconnect();
    FirebaseMessaging _fcm = FirebaseMessaging();
     await _fcm.deleteInstanceID();
     exit(0);
    //  RestartWidget.restartApp(context);

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => WelcomePage()));
  }

  void saveToShared(bool v) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setBool('theme', v);
  }


}
