import 'dart:io';
import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:folk/pages/ConversionPage.dart';
import 'package:folk/pages/chatGroupListPage.dart';
import 'package:folk/utils/MainWigets/bottomAppBar.dart';
import 'package:folk/utils/SearchAppBar/search_app_bar.dart';
import 'package:folk/utils/notification_icon.dart';

import 'message_content_tab.dart';

class ProfileInboxScreen extends StatefulWidget {
  @override
  _ProfileInboxScreenState createState() => _ProfileInboxScreenState();
}

class _ProfileInboxScreenState extends State<ProfileInboxScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: SearchAppBar(
          color1: Colors.white,
          color2: Colors.grey[100],
          leading: Container(
            margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: buildNotificationBtn(context),
          ),
          blackSearchIcon: true,
        ),
        body: Stack(
          children: <Widget>[
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
            SizedBox(height: 120),
            BottomBarWithFloatingBtn(selected: 'message'),
          ],
        ),
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
        getTabs('Messages'),
        getTabs('Online'),
        getTabs('Groups'),
      ],
    );
  }

  getTabs(String title) {
    return Tab(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTabView(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        ConversionPage(),
        MessagesContent(),
        ChatGroupList(),
      ],
    );
  }
}
