import 'dart:io';
import 'dart:async';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:folk/Screens/Home_page/homeWidgets/bottomBar.dart';
import 'package:folk/Screens/Home_page/homeWidgets/header.dart';
import 'package:folk/Screens/Home_page/homeWidgets/post_content.dart';
import 'package:folk/Screens/Login/location.dart';
import 'package:folk/Screens/Login/login_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  final String phone;
  final int newotp;
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  final loginType;
  final loginStatus;
  Homepage(
      {Key key,
      this.phone,
      this.newotp,
      this.fbId,
      this.fbName,
      this.fbEmail,
      this.fbPicUrl,
      this.loginType,
      this.loginStatus})
      : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  PermissionStatus _status;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    //  print(widget.fbName);
    tabController = TabController(vsync: this, length: 3);
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_updateStatus);

    TimerFunction();
  }

  TimerFunction() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
        oneSec,
        (Timer t) => {
              print("timer running"),
              PermissionHandler()
                  .checkPermissionStatus(PermissionGroup.locationWhenInUse)
                  .then(_updateStatus),
              if (_status == PermissionStatus.denied)
                {
                  t.cancel(),
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => GetLocation()))
                }
              else
                {
                  print("location permission already enabled !"),
                  t.cancel(),
                }
            });
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      _status = status;
      print(_status);
    }
  }

  Future<bool> _onBackPressed() {
    return AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            // customHeader: Image.asset("assets/images/macha.gif"),
            animType: AnimType.TOPSLIDE,
            btnOkText: "yes",
            btnCancelText: "Hell No..",
            tittle: 'Are you sure ?',
            desc: 'Do you want to exit an App',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              exit(0);
            }).show() ??
        false;
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext ctx) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: _buildHeader(context),
        body: Stack(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.transparent),
                child: _buildTabBar(context),
              ),
              Flexible(
                child: _buildTabView(context),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:Container(
              margin: const EdgeInsets.only(bottom:20),
          height: 100.0,
          width: 90.0,
          decoration: BoxDecoration(
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage('assets/images/Circle_Border.png')),
          ),
        ), 
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomStack(context))
        ]),
        // bottomNavigationBar:
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(120.0),
      child: Container(
        color: Colors.transparent,
        height: 110.0,
        alignment: Alignment.center,
        child: Header(),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: tabController,
      indicatorColor: Colors.transparent,
      labelColor: Color(0xFFFF6038),
      unselectedLabelColor: Color(0xFF020433),
      isScrollable: true,
      tabs: <Widget>[
        getTabs('Posts'),
        getTabs('Events'),
        getTabs('Joined'),
      ],
    );
  }

  getTabs(String title) {
    return Tab(
      child: Text(
        title,
        style: TextStyle(
            fontSize: 25.0,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTabView(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        PostsContent(),
        PostsContent(),
        PostsContent(),
      ],
    );
  }

  Widget _buildBottomStack(BuildContext context) {
    return Stack(children: <Widget>[
      _buildBottomBar(context),
      Positioned(child: _buildPostImg(context)),
      Positioned(child: _buildPostBtnIcon(context))
    ]);
  }

  Widget _buildBottomBar(BuildContext context) {
    return new Container(
        height: 120.0, alignment: Alignment.center, child: BottomBar());
  }

  Widget _buildPostImg(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 100.0,
          width: 100.0,
          decoration: BoxDecoration(
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new AssetImage('assets/images/PostImg.png')),
          ),
        ),
      ],
    );
  }

  Widget _buildPostBtnIcon(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      // color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _logOut(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome to home page"),
            GestureDetector(
              onTap: () {
                logOut();
                log("logged Out");
              },
              child: Container(
                height: 51,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6038), Color(0xFFFF9006)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Center(
                  child: Text(
                    'Logout'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
