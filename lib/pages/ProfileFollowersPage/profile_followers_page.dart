import 'package:flutter/material.dart';
import 'package:folk/Utils/HelperWidgets/buttons.dart';
import 'package:folk/Utils/SearchAppBar/search_app_bar.dart';
import 'package:folk/utils/HelperWidgets/emptyResponse.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/Utils/HelperWidgets/circle_user.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/models/followerModel.dart';
import 'package:folk/models/followingModel.dart';
import 'package:folk/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:provider/provider.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folk/pages/Profile_Page/landlord_profile.dart';
import 'package:folk/pages/Profile_Page/Profile.dart';
import '../MessagesPage.dart';

class ProfileFollowersPage extends StatefulWidget {
  final peerid;
  ProfileFollowersPage(this.peerid);
  @override
  _ProfileFollowersPageState createState() => _ProfileFollowersPageState();
}

class _ProfileFollowersPageState extends State<ProfileFollowersPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  String state = "Followers";

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: SearchAppBar(
        color1: Colors.grey[100],
        color2: Colors.white,
      ),
      body: Column(
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
    );
  }

  Widget _buildTabView(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        FollowersContent(widget.peerid),
        FollowingContent(widget.peerid),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: tabController,
      indicatorColor: Colors.transparent,
      labelColor: Color(0xFFFF6038),
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      unselectedLabelColor: Color(0xFF020433),
      isScrollable: true,
      tabs: <Widget>[
        getTabs('Followers'),
        getTabs('Following'),
      ],
    );
  }

  getTabs(String title) {
    return Tab(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22.0,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }
}

class FollowersContent extends StatefulWidget {
  final peerid;
  FollowersContent(this.peerid);
  @override
  _FollowersContentState createState() => _FollowersContentState();
}

class _FollowersContentState extends State<FollowersContent> {
  UserModel _userModel;
  List<FollowerModel> _listFollowers = [];
  bool isfetched = true;
  bool isEmpty = false;

  @override
  void initState() {
    // TODO: implement initState
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    super.initState();
    getFollowers();
  }

  getFollowers() {
    //start get Posts !
    print("getFollowers running.............................");

    String _url = "${Constants.SERVER_URL}user/getfollowers";
    return http.post(_url, body: {
      'user_id': '${_userModel.id}',
      'peer_id': '${widget.peerid}',
    }).then((res) async {
      var convertedData = convert.jsonDecode(res.body);
      if (!convertedData['error']) {
        List data = convertedData['data'];
        // print(data);
        setState(() {
          _listFollowers =
              data.map((data) => FollowerModel.fromJson(data)).toList();
          isfetched = false;
        });
        print("foloowers arrayyyyyyyyyyyyyy length ${_listFollowers.length}");
      } else {
        print("empty response");
        setState(() {
          isfetched = false;
          isEmpty = true;
        });
      }
    }).catchError((err) {
      print('init Data error is $err');
    });
  }

  getAge(bday) {
    final birthday = DateTime.parse(bday);
    final dtnow = DateTime.now();
    final difference = dtnow.difference(birthday).inDays;
    final age = difference / 365;
    return age.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: isfetched
            ? Center(
                child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      backgroundColor: Color.fromRGBO(255, 149, 0, 1),
                    )))
            : isEmpty
                ? EmptyResponse('assets/images/no.png', "No Followers Yet")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _listFollowers.length,
                    itemBuilder: (BuildContext context, int index) {
                      FollowerModel _post = _listFollowers[index];
                      int followcount = _post.userfollowercount;
                      String followerText = followcount == 1? "Follower":"Followers";

                      return Container(
                        padding:
                            EdgeInsets.fromLTRB(20.0, 20.0 / 2, 20.0, 20.0 / 2),
                        // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => LandlordProfile(
                                                postOwnerId:
                                                    _post.followerUserId)));
                                  },
                                  child: CircleUser(
                                    withBorder: false,
                                    size: 60,
                                    url: _post.imagesource == 'fb'
                                        ? "${_post.fb_url}"
                                        : "${Constants.USERS_PROFILES_URL}" +
                                            "${_post.img}",
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          if (_post.followerUserId ==
                                              _userModel.id) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) => Profile()));
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        LandlordProfile(
                                                            postOwnerId: _post
                                                                .followerUserId)));
                                          }
                                        },
                                        child: Text(
                                          "${_post.name}",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                "${getAge(_post.userbday)}",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "${_post.userfollowercount} $followerText",
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
                            _post.followerUserId == _userModel.id
                                ? Container()
                                : Container(
                                    child: _post.isUserFollowed
                                        ? GestureDetector(
                                            onTap: () {
                                              startUnfollowUser(index);
                                            },
                                            child: RoundedBorderButton(
                                              "UNFOLLOW",
                                              color1: Color.fromRGBO(
                                                  255, 94, 58, 1),
                                              color2: Color.fromRGBO(
                                                  255, 149, 0, 1),
                                              textColor: Colors.white,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .35,
                                            ),
                                          )
                                        : !_post.isUserRequested
                                            ? GestureDetector(
                                                onTap: () {
                                                  startFollowUser(index);
                                                },
                                                child: RoundedBorderButton(
                                                  "FOLLOW",
                                                  color1: Color.fromRGBO(
                                                      255, 94, 58, 1),
                                                  color2: Color.fromRGBO(
                                                      255, 149, 0, 1),
                                                  textColor: Colors.white,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .35,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  cancelFollowReq(index);
                                                  print(_post.isUserFollowed);
                                                },
                                                child: RoundedBorderButton(
                                                  "CANCEL REQUEST",
                                                  color1: Color.fromRGBO(
                                                      255, 94, 58, 1),
                                                  color2: Color.fromRGBO(
                                                      255, 149, 0, 1),
                                                  textColor: Colors.white,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .35,
                                                ),
                                              ),
                                  )
                          ],
                        ),
                      );
                    },
                  ));
  }

  void startFollowUser(index) async {
    try {
      if (!_listFollowers[index].isUserRequested) {
        setState(() {
          _listFollowers[index].isUserRequested = true;
        });
        var req =
            await http.post('${Constants.SERVER_URL}user/followrequest', body: {
          'user_id': '${_userModel.id}',
          'peer_id': '${_listFollowers[index].followerUserId}',
          'user_name': '${_userModel.name}'
        });

        print("ssssssssssssssssss ${_userModel.name}");
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          Fluttertoast.showToast(
              msg: 'You requested follow ${_listFollowers[index].name}');
          print(
              "follow user success ---${_listFollowers[index].isUserRequested}");
        }
      }
    } catch (err) {} finally {}
  }

  void startUnfollowUser(index) async {
    try {
      if (_listFollowers[index].isUserFollowed) {
        setState(() {
          _listFollowers[index].isUserFollowed = false;
        });
        var req =
            await http.post('${Constants.SERVER_URL}user/unfollowuser', body: {
          'user_id': '${_userModel.id}',
          'peer_id': '${_listFollowers[index].followerUserId}'
        });
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          Fluttertoast.showToast(
              msg: 'You Unfollowed ${_listFollowers[index].name}');
          print(
              "Unfollow user success ---${_listFollowers[index].isUserFollowed}");
        }
      }
    } catch (err) {} finally {}
  }

  void cancelFollowReq(index) async {
    try {
      if (_listFollowers[index].isUserRequested) {
        setState(() {
          _listFollowers[index].isUserRequested = false;
        });
        var req = await http
            .post('${Constants.SERVER_URL}user/cancelfollowrequest', body: {
          'user_id': '${_userModel.id}',
          'peer_id': '${_listFollowers[index].followerUserId}'
        });
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          Fluttertoast.showToast(msg: 'You cancelled follow Reuqest!');
          print(
              "cancel req success ---${_listFollowers[index].isUserRequested}");
        }
      }
    } catch (err) {} finally {}
  }
}

class FollowingContent extends StatefulWidget {
  final peerid;
  FollowingContent(this.peerid);

  @override
  _FollowingContentState createState() => _FollowingContentState();
}

class _FollowingContentState extends State<FollowingContent> {
  UserModel _userModel;
  List<FollowingModel> _listFollowing = [];
  bool isfetched = true;
  bool isEmpty = false;
  bool isMessageCLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    super.initState();
    getFollowingList();
  }

  getFollowingList() {
    print("getFollowing list running.............................");

    String _url = "${Constants.SERVER_URL}user/getfollowing";
    return http.post(_url, body: {
      'user_id': '${_userModel.id}',
      'peer_id': '${widget.peerid}',
    }).then((res) async {
      var convertedData = convert.jsonDecode(res.body);
      if (!convertedData['error']) {
        List data = convertedData['data'];
        setState(() {
          _listFollowing =
              data.map((data) => FollowingModel.fromJson(data)).toList();
          isfetched = false;
        });
        print("foloowing arrayyyyyyyyyyyyyy length ${_listFollowing.length}");
      } else {
        print("empty response");
        setState(() {
          isfetched = false;
          isEmpty = true;
        });
      }
    }).catchError((err) {
      print('init Data error is $err');
    });
  }

  getAge(bday) {
    final birthday = DateTime.parse(bday);
    final dtnow = DateTime.now();
    final difference = dtnow.difference(birthday).inDays;
    final age = difference / 365;
    return age.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: isfetched
            ? Center(
                child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      backgroundColor: Color.fromRGBO(255, 149, 0, 1),
                    )))
            : isEmpty
                ? EmptyResponse('assets/images/no.png', "Not Following Anyone, Yet")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _listFollowing.length,
                    itemBuilder: (BuildContext context, int index) {
                      FollowingModel _followings = _listFollowing[index];
                      int followcount = _followings.userfollowercount;
                      String followerText = followcount == 1? "Follower":"Followers";

                      return _followings.followerUserId == _userModel.id
                          ? Container()
                          : Container(
                              padding: EdgeInsets.fromLTRB(
                                  20.0, 20.0 / 2, 20.0, 20.0 / 2),
                              // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) => LandlordProfile(
                                                      postOwnerId: _followings
                                                          .followerUserId)));
                                        },
                                        child: CircleUser(
                                          withBorder: false,
                                          size: 60,
                                          url: _followings.imagesource == 'fb'
                                              ? "${_followings.fb_url}"
                                              : "${Constants.USERS_PROFILES_URL}" +
                                                  "${_followings.img}",
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3.5,
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                if (_followings
                                                        .followerUserId ==
                                                    _userModel.id) {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              Profile()));
                                                } else {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              LandlordProfile(
                                                                  postOwnerId:
                                                                      _followings
                                                                          .followerUserId)));
                                                }
                                              },
                                              child: Text(
                                                "${_followings.name}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      "${getAge(_followings.userbday)}",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  "${_followings.userfollowercount} $followerText",
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
                                  // _followings.followerUserId == _userModel.id ?
                                  isMessageCLiked
                                      ? SizedBox(
                                          child: CircularProgressIndicator(),
                                          height: 15.0,
                                          width: 15.0,
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              isMessageCLiked = true;
                                            });
                                            if (_followings.followerUserId !=
                                                _userModel.id) {
                                              String _url =
                                                  '${Constants.SERVER_URL}conversions/create';

                                              http.post(_url, body: {
                                                'lastMessage':
                                                    'hi i am using folk',
                                                'user_one': _userModel.id,
                                                'user_two':
                                                    _followings.followerUserId
                                              }).then((res) async {
                                                var data = convert
                                                    .jsonDecode(res.body);
                                                print(data);
                                                if (!data['error']) {
                                                  String chatId =
                                                      data['data']['_id'];
                                                  String peerId =
                                                      _followings.id;
                                                  String peerImg =
                                                      _followings.img;
                                                  String peerName =
                                                      _followings.name;
                                                  String peerToken =
                                                      _followings.token;
                                                  String myId = _userModel.id;

                                                  setState(() {
                                                    isMessageCLiked = false;
                                                  });
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              MessagesPage(
                                                                  chatId,
                                                                  peerId,
                                                                  peerToken,
                                                                  myId,
                                                                  true,
                                                                  peerImg,
                                                                  true,
                                                                  peerName,
                                                                  _followings)));
                                                } else {
                                                  print(['data']);
                                                }
                                              });
                                            } else {
                                              print(
                                                  "${_followings.isUserFollowed}");
                                              Fluttertoast.showToast(
                                                  msg: _followings
                                                          .isUserRequested
                                                      ? 'You have to Wait for ${_followings.name} to accept the req'
                                                      : 'You have to follow ${_followings.name} first');
                                            }
                                          },
                                          child: RoundedBorderButton(
                                            "MESSAGE",
                                            color1: Colors.grey[100],
                                            color2: Colors.grey[100],
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .35,
                                          ),
                                        )
                                  // : Container()
                                ],
                              ),
                            );
                    },
                  ));
  }
}

// class UserCardItem extends StatefulWidget {
//   final FollowerModel _post;
//   final UserModel userModel;
//   UserCardItem({
//     this._post,
//     this.userModel
//   });

//   @override
//   _UserCardItemState createState() => _UserCardItemState();
// }

// class _UserCardItemState extends State<UserCardItem> {
//   bool isFollowed = false;

//   getAge(bday) {
//     final birthday = DateTime.parse(bday);
//     final dtnow = DateTime.now();
//     final difference = dtnow.difference(birthday).inDays;
//     final age = difference / 365;
//     return age.toStringAsFixed(0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(20.0, 20.0 / 2, 20.0, 20.0 / 2),
//       // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
//       color: Colors.white,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               CircleUser(
//                 withBorder: false,
//                 size: 60,
//                 url: widget._post.imagesource == 'fb'
//                               ? "${widget._post.fb_url}"
//                               : "${Constants.USERS_PROFILES_URL}" +
//                                   "${widget._post.img}",
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width / 3,
//                 padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "${widget._post.name}",
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Row(
//                           children: <Widget>[
//                             FaIcon(
//                               FontAwesomeIcons.venus,
//                               size: 15,
//                               color: Colors.grey[700],
//                             ),
//                             SizedBox(width: 5),
//                             Text(
//                               "${getAge(widget._post.userbday)}",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           "${widget._post.userfollowercount} Followers",
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//               widget._post.isUserFollowed
//                 ? GestureDetector(
//                     onTap: () {
//                       startUnfollowUser();
//                     },
//                     child: RoundedBorderButton(
//                       "UNFOLLOW",
//                       color1: Color.fromRGBO(255, 94, 58, 1),
//                       color2: Color.fromRGBO(255, 149, 0, 1),
//                       textColor: Colors.white,
//                       width: MediaQuery.of(context).size.width * .35,
//                     ),
//                   )
//                 : !widget._post.isUserRequested
//                     ? GestureDetector(
//                         onTap: () {
//                           startFollowUser();
//                         },
//                         child: RoundedBorderButton(
//                           "FOLLOW",
//                           color1: Color.fromRGBO(255, 94, 58, 1),
//                           color2: Color.fromRGBO(255, 149, 0, 1),
//                           textColor: Colors.white,
//                           width: MediaQuery.of(context).size.width * .35,
//                         ),
//                       )
//                     : GestureDetector(
//                         onTap: () {
//                           cancelFollowReq();
//                           print(widget._post.isUserFollowed);
//                         },
//                         child: RoundedBorderButton(
//                           "CANCEL REQUEST",
//                           color1: Color.fromRGBO(255, 94, 58, 1),
//                           color2: Color.fromRGBO(255, 149, 0, 1),
//                           textColor: Colors.white,
//                           width: MediaQuery.of(context).size.width * .35,
//                         ),
//                       ),
//         ],
//       ),
//     );
//   }

// }
