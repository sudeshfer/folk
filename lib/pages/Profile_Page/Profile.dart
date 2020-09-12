import 'package:flutter/material.dart';
import 'package:folk/models/PostModel.dart';
import 'package:folk/models/EventModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/pages/DiscoverPages/vip_page.dart';
import 'package:folk/pages/ProfileFollowersPage/profile_followers_page.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:folk/utils/HelperWidgets/noResponse_msg.dart';
import 'package:folk/widgets/PostsPageItem.dart';
// import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/Utils/MainWigets/bottomAppBar.dart';
import 'package:folk/Utils/MainWigets/profileAppBar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:folk/pages/Events/events_content.dart';
import 'package:folk/utils/HelperWidgets/tag.dart';
import 'package:folk/utils/HelperWidgets/emptyResponse.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<PostModel> _listPosts = [];
  List<EventModel> _listEvents = [];
  UserModel _myModel;
  bool isfetched = true;
  bool isPostEmpty = false;
  bool isEventEmpty = false;
  String state = "Posts";
  bool isToggle = false;

  getUserPosts() {
    //start get Posts !
    print("getUserPosts running.............................");

    String _url = "${Constants.SERVER_URL}post/fetch_posts_by_user_id";
    return http.post(_url, body: {
      'user_id': '${_myModel.id}',
      'peer_id': '${_myModel.id}',
    }).then((res) async {
      var convertedData = convert.jsonDecode(res.body);
      if (!convertedData['error']) {
        List data = convertedData['data'];
        setState(() {
          _listPosts = data.map((data) => PostModel.fromJson(data)).toList();
          isfetched = false;
        });
        // print(data);
      } else {
        print("empty response");
        setState(() {
          isfetched = false;
          isPostEmpty = true;
        });
      }
    }).catchError((err) {
      print('init Data error is $err');
    });
  }

  getUserEvents() {
    //start get Posts !
    print("getUser Events running.............................");

    String _url = "${Constants.SERVER_URL}event/getuserevents";
    return http.post(_url, body: {
      'user_id': '${_myModel.id}',
      'page': '1',
      'peer_id': '${_myModel.id}',
    }).then((res) async {
      var convertedData = convert.jsonDecode(res.body);
      // print(convertedData);
      if (!convertedData['error']) {
        List data = convertedData['data'];
        setState(() {
          _listEvents = data.map((data) => EventModel.fromJson(data)).toList();
          isfetched = false;
        });
        print(data);
      } else {
        print("empty response");
        setState(() {
          isfetched = false;
          isEventEmpty = true;
        });
      }
    }).catchError((err) {
      print('init Data error is $err');
    });
  }

  initParticipateStatus(joinedCount, maxCount) {
    double temp = maxCount * 0.7;
    String msg = "";

    if (joinedCount < temp) {
      msg = "Available";
    }
    if (joinedCount >= temp) {
      msg = "Running Out";
    }
    if (joinedCount == maxCount) {
      msg = "Sold Out";
    }

    return msg;
  }

  bool initCountdown(eventdate) {
    DateTime temp = DateTime.parse(eventdate);
    int diff = (temp.difference(DateTime.now()).inHours);
    if (diff <= 24) {
      //  print("date difference issssssssssss $diff");
      return true;
    } else {
      //  print("date difference issssssssssss $diff");
      return false;
    }
  }

  @override
  void initState() {
    print("inits running.............................");
    _myModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    getUserPosts();
    getUserEvents();
    super.initState();
  }

  ScrollController _mycontroller1 = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(context),
      body: Stack(
        children: <Widget>[
          PageView(
            children: <Widget>[
              SingleChildScrollView(
                controller: _mycontroller1,
                child: Column(
                  children: <Widget>[
                    ProfileDetailContainer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Spacer(),
                              // CustomToggleButton(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    (state == "Posts")
                                        ? state = "Events"
                                        : state = "Posts";
                                    isToggle = !isToggle;
                                  });
                                  print("$isToggle");
                                },
                                child: Stack(
                                  alignment: (state == "Posts")
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  children: <Widget>[
                                    Container(
                                      height: 40,
                                      width: 200,
                                      margin: EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(255, 94, 58, 1),
                                            Color.fromRGBO(255, 149, 0, 1)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      child: Container(
                                        height: 50,
                                        width: 110,
                                        margin: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 200,
                                      margin: EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.transparent),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            "Posts",
                                            style: TextStyle(
                                              color: (state == "Posts")
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "Events",
                                            style: TextStyle(
                                              color: (state == "Events")
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    isfetched
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            child: CardListSkeleton(
                              style: SkeletonStyle(
                                theme: SkeletonTheme.Light,
                                isShowAvatar: true,
                                isCircleAvatar: true,
                                barCount: 3,
                              ),
                            ),
                          )
                        : !isToggle
                            ? isPostEmpty
                                ? EmptyResponse(
                                    'assets/images/no.png', "No Posts Yet")
                                : ListView.builder(
                                    controller: _mycontroller1,
                                    shrinkWrap: true,
                                    itemCount: _listPosts.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      PostModel _post = _listPosts[index];

                                      return PostsPageItem(
                                        _post,
                                        _myModel.id,
                                        _myModel.name,
                                        _myModel.img,
                                        _myModel.imagesource,
                                        _myModel.fb_url,
                                        isFromCommentPage: false,
                                      );
                                    },
                                  )
                            : isEventEmpty
                                ? EmptyResponse(
                                    'assets/images/no.png', "No Events Yet")
                                : ListView.builder(
                                    controller: _mycontroller1,
                                    shrinkWrap: true,
                                    itemCount: _listEvents.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      EventModel _event = _listEvents[index];

                                      return EventCard(
                                        EventImage(
                                          "${Constants.USERS_POSTS_IMAGES}" +
                                              "${_listEvents[index].postImg}",
                                          "${_listEvents[index].eventDate}",
                                          "Jan",
                                          Tag(
                                            initParticipateStatus(
                                                _listEvents[index].joinedCount,
                                                _listEvents[index]
                                                    .maxParticipantCount),
                                            Colors.white,
                                            Colors.deepOrange,
                                            Colors.transparent,
                                            fontSize: 8,
                                          ),
                                        ),
                                        _event,
                                        displayTimeBar: initCountdown(
                                            "${_listEvents[index].eventDate}"),
                                      );
                                    },
                                  ),
                    SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
          BottomBarWithFloatingBtn(
            selected: 'profile',
          ),
        ],
      ),
      // bottomNavigationBar:
    );
  }

  Widget _buildHeader(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.0),
      child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(top: 40),
          height: MediaQuery.of(context).size.height / 10,
          alignment: Alignment.center,
          child: ProfileAppBar(context)),
    );
  }
}

// class CustomToggleButton extends StatefulWidget {
//   @override
//   _CustomToggleButtonState createState() => _CustomToggleButtonState();
// }

// class _CustomToggleButtonState extends State<CustomToggleButton> {
//   String state = "Events";

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           (state == "Posts") ? state = "Events" : state = "Posts";
//           isToggle = !isToggle;
//         });
//         print("$isToggle");
//       },
//       child: Stack(
//         alignment:
//             (state == "Posts") ? Alignment.centerLeft : Alignment.centerRight,
//         children: <Widget>[
//           Container(
//             height: 40,
//             width: 200,
//             margin: EdgeInsets.all(25),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               gradient: LinearGradient(
//                 colors: [
//                   Color.fromRGBO(255, 94, 58, 1),
//                   Color.fromRGBO(255, 149, 0, 1)
//                 ],
//               ),
//             ),
//           ),
//           Align(
//             child: Container(
//               height: 50,
//               width: 110,
//               margin: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           Container(
//             height: 40,
//             width: 200,
//             margin: EdgeInsets.all(25),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.transparent),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 Text(
//                   "Posts",
//                   style: TextStyle(
//                     color: (state == "Posts") ? Colors.black : Colors.white,
//                   ),
//                 ),
//                 Text(
//                   "Events",
//                   style: TextStyle(
//                     color: (state == "Events") ? Colors.black : Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ProfileDetailContainer extends StatefulWidget {
  @override
  _ProfileDetailContainerState createState() => _ProfileDetailContainerState();
}

class _ProfileDetailContainerState extends State<ProfileDetailContainer> {
  UserModel userModel;
  String city;
  String country;
  String name;
  String age;

  @override
  void initState() {
    // TODO: implement initState
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    initDetails();
    age = getAge(userModel.bday);
    super.initState();
  }

  getAge(bday) {
    final birthday = DateTime.parse(bday);
    final dtnow = DateTime.now();
    final difference = dtnow.difference(birthday).inDays;
    final age = difference / 365;
    return age.toStringAsFixed(0);
  }

  initDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      city = prefs.getString("city");
      country = prefs.getString("country");
      name = userModel.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 10),
                  Container(
                    // color: Colors.red[200],
                    height: 100,
                    width: 120,
                    child: Stack(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed("/profilesettings2");
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[200],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ClipOval(
                                child: Image.network(
                                    userModel.imagesource == 'fb'
                                        ? userModel.fb_url
                                        : Constants.USERS_PROFILES_URL +
                                            userModel.img,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            height: 25,
                            width: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey[200]),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                height: 25,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color.fromRGBO(255, 94, 58, 1),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "50%",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              "$name, $age",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          SizedBox(width: 5),
                          Image(
                            image: AssetImage("assets/images/ic_verified.png"),
                            width: 30,
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: <Widget>[
                          FaIcon(
                            FontAwesomeIcons.mapMarkerAlt,
                            size: 16,
                            color: Color.fromRGBO(255, 94, 58, 1),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "$city, $country",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      // Row(
                      //   children: <Widget>[
                      //     FaIcon(
                      //       FontAwesomeIcons.mapMarkerAlt,
                      //       size: 16,
                      //       color: Color.fromRGBO(255, 94, 58, 1),
                      //     ),
                      //     SizedBox(width: 5),
                      //     Text(
                      //       "Riga, Latvia",
                      //       style: TextStyle(
                      //         fontSize: 15,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ProfileFollowersPage(userModel.id)));
                    },
                    child: Column(
                      children: <Widget>[
                        Text(
                          "FOLLOWERS",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${userModel.followercount}",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "PARTECIPATIONS",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "368",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "ABSENCES",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "1689",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => VIPPage()));
          },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width * .75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              // color: Color.fromRGBO(255, 94, 58, 1),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 94, 58, 1),
                  Color.fromRGBO(255, 149, 0, 1)
                ],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 3),
                  child: Image(
                    image: AssetImage("assets/images/ic_boot.png"),
                    width: 50,
                  ),
                ),
                Spacer(),
                Text(
                  "Upgrade your profile",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
