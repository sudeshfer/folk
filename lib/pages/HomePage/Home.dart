import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folk/pages/ConversionPage.dart';
import 'package:folk/pages/chatGroupListPage.dart';
import 'package:folk/pages/publicChatRooms/PublicRoomsConverstions.dart';
import 'package:folk/providers/chatGroupProvider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/PostModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/pages/CommentsPage.dart';
import 'package:folk/pages/MessagesPage.dart';
import 'package:folk/providers/AppBarProvider.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:folk/providers/ConverstionProvider.dart';
import 'package:folk/providers/PostProvider.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:folk/pages/Events/events_content.dart';
import 'package:folk/pages/Events/joinedEventContent.dart';
import 'package:folk/utils/MainWigets/bottomAppBar.dart';
import 'package:folk/utils/MainWigets/mainAppBar.dart';
import 'HomeWidgets/post_content.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:folk/models/peerProfileModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String phone;
  final int newotp;
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  final loginType;
  final loginStatus;
  Home(
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
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  int index = 0;
  io.Socket socket;
  io.Socket roomSocket;
  static int i = 0;
  static int i2 = 0;
  static int i3 = 0;
  UserModel _userModel;
  List _profile;
  FirebaseMessaging _fcm = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  List<Widget> pages = [];

TabController tabController;
Position _currentPosition;

// _getCurrentLocation() async {
//     _currentPosition = await Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//         List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
//   Placemark place = placemark[0];
//   print(" City is "+ place.locality);

//   SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setDouble("lat", _currentPosition.latitude.toDouble());
//     prefs.setDouble("lng", _currentPosition.longitude.toDouble());
//     prefs.setString("city", place.locality.toString());
//     double lat = prefs.getDouble("lat");
//     print("latitude is " + lat.toString());  

//     print(_currentPosition.latitude.toString());
//     print(_currentPosition.longitude.toString());
//   }


  @override
  void initState() {
    tabController = TabController(vsync: this, length: 3);

    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;

    Provider.of<ConversionProvider>(context, listen: false)
        .initConversionSocketAndRequestChats(_userModel);

    Provider.of<ChatGroupProvider>(context, listen: false)
        .initChatGroupSocketAndRequestChats(_userModel);

    Provider.of<PostProvider>(context, listen: false)
        .startGetPostsData(_userModel.id);
    
    // _getCurrentLocation();

    // pages.add(PostsPage());
    // pages.add(NotificationPage());
    pages.add(PublicRoomsConverstions(_userModel));
    pages.add(ConversionPage());
    pages.add(ChatGroupList());
    // pages.add(Settings( ));

    super.initState();
    initSocket();
    registerNotification();
    configLocalNotification();
 

  }




  @override
  Widget build(BuildContext context) {
    index = Provider.of<AppBarProvider>(context, listen: true).getIndex();
    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: themeProvider.getThemeData.backgroundColor,
          appBar: _buildHeader(context),
          body: SafeArea(
            child: Stack(
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
            BottomBarWithFloatingBtn(),
          ],
        ),
          ),
          ),
    );
  }

   Widget _buildHeader(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.0),
      child: Container(
        margin: EdgeInsets.only(top:40),
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height/10,
        alignment: Alignment.center,
        child: MainAppBar(context),
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
            fontSize: 23.0,
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
        EventContent(),
        JoinedEventContent(),
      ],
    );
  }

  void registerNotification() async {
    await Future.delayed(Duration(seconds: 1));

    await _fcm.getToken().then((token) async {
      try {
        await http.post('${Constants.SERVER_URL}user/update_user_token',
            body: {'id': '${_userModel.id}', 'token': '$token'});
      } catch (err) {}
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });

    _fcm.requestNotificationPermissions();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (i2 % 2 == 0) {
          //update posts
          Provider.of<PostProvider>(context, listen: false)
              .startGetPostsData(_userModel.id);
        }
        i2++;
        //refresh posts and notifications when app open

        if (Platform.isIOS) {
          var fetchedMessage = message['notification'];
          //show overlay in foreground for ios only

          setState(() {
            showOverlayNotification((context) {
              return Material(
                child: InkWell(
                  onTap: () {
                    startNavigate(message);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
                    elevation: 3,
                    color: Theme.of(context).primaryColor,
                    child: SafeArea(
                      child: ListTile(
                        onTap: () {
                          startNavigate(message);
                        },
                        title: Text(fetchedMessage['title'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: Text(fetchedMessage['body'],
                            style: TextStyle(
                              fontSize: 14,
                            )),
                      ),
                    ),
                  ),
                ),
              );
            }, duration: Duration(seconds: 3));
          });
        }

        showNotification(message['notification'], message);

        return;
      },
      onResume: (Map<String, dynamic> data) {
        startNavigate(data);

        return;
      },
      onLaunch: (Map<String, dynamic> data) {
        startNavigate(data);

        return;
      },
    );
  }

  void configLocalNotification() {
    //get icon from android/manifest
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _startOnSelect);
  }

  @override
  void dispose() {
    super.dispose();

    if (roomSocket != null) {
      roomSocket.disconnect();
    }
  }

  Future<bool> _onWillPop() async {
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

  void initSocket() async {
    Provider.of<AuthProvider>(context, listen: false).sendOnline();
  }

  Future _startOnSelect(payload) {
    
    // for only one navigate
    if (i % 2 == 0) {
      var data = jsonDecode(payload);
      String screen = data['data']['screen'];
      if (screen == 'chat') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MessagesPage(
                data['data']['chatId'],
                data['data']['id'],
                data['data']['token'],
                _userModel.id,
                true,
                data['data']['img'],
                true,
                data['data']['name'],
                _profile
                )));
      } else if (screen == 'comment') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CommentsPage(PostModel(
                id: data['data']['id'],
                postOwnerId: data['data']['post_owner_id']))));
      } else if (screen == 'like') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CommentsPage(PostModel(
                id: data['data']['id'],
                postOwnerId: data['data']['post_owner_id']))));
      }
    }
    i++;
    // return Future<void>.value();
  }

  void showNotification(message, message2) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.hardcode.folk'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'], platformChannelSpecifics,
        payload: json.encode(message2));
  }

  void startNavigate(Map<String, dynamic> data) {
    if (i3 % 2 == 0) {
      var notificationData = Platform.isIOS ? data : data['data'];
      String screen = notificationData['screen'];

      if (screen == 'chat') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MessagesPage(
                notificationData['chatId'],
                notificationData['id'],
                notificationData['token'],
                _userModel.id,
                true,
                notificationData['img'],
                true,
                notificationData['name'],
                _profile)));
      } else if (screen == 'comment') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CommentsPage(PostModel(
                id: notificationData['id'],
                postOwnerId: notificationData['post_owner_id']))));
      } else if (screen == 'like') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CommentsPage(PostModel(
                id: notificationData['id'],
                postOwnerId: notificationData['post_owner_id']))));
      }
    }
    i3++;
  }
}
