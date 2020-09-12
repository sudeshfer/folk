import 'package:flutter/material.dart';
import 'package:folk/Utils/HelperWidgets/buttons.dart';
import 'package:folk/Utils/SearchAppBar/search_app_bar.dart';
import 'package:folk/models/followerModel.dart';
import 'package:folk/pages/Profile_Page/Profile.dart';
import 'package:folk/pages/Profile_Page/landlord_profile.dart';
import 'package:folk/utils/Util_Functions/functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:folk/models/UserModel.dart';
import 'package:folk/models/UserRequestModel.dart';
import 'package:folk/utils/Constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/Utils/HelperWidgets/circle_user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:folk/providers/AuthProvider.dart';

class EventParticipantListFull extends StatefulWidget {
  final participantList;
  EventParticipantListFull(this.participantList);
  @override
  _EventParticipantListFullState createState() =>
      _EventParticipantListFullState();
}

class _EventParticipantListFullState extends State<EventParticipantListFull> {
  bool isfetching = true;
  bool isEmpty = false;
  UserModel _userModel;
  List<UserRequestsModel> followReqs = List();

  @override
  void initState() {
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: SearchAppBar(
        color1: Colors.grey[100],
        color2: Colors.white,
        searchIconBackgroundColor: Colors.grey[100],
        leading: Container(
          margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.participantList.length,
          itemBuilder: (BuildContext context, int index) {
            FollowerModel _post = widget.participantList[index];

            return ConfirmationCard(_post);
          },
        ),
      ),
    );
  }
}

class ConfirmationCard extends StatefulWidget {
  final bool withBorder;
  final double padding;
  final double width;
  final FollowerModel participantList;
  const ConfirmationCard(this.participantList,
      {Key key, this.withBorder = false, this.padding = 20, this.width})
      : super(key: key);

  @override
  _ConfirmationCardState createState() => _ConfirmationCardState();
}

class _ConfirmationCardState extends State<ConfirmationCard> {
  UserModel _userModel;

  Functions functions;

  getAge(bday) {
    final birthday = DateTime.parse(bday);
    final dtnow = DateTime.now();
    final difference = dtnow.difference(birthday).inDays;
    final age = difference / 365;
    return age.toStringAsFixed(0);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     functions = Functions();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
  }

  void startFollowUser() async {
    try {
      if (!widget.participantList.isUserRequested) {
        setState(() {
          widget.participantList.isUserRequested = true;
        });
        var req =
            await http.post('${Constants.SERVER_URL}user/followrequest', body: {
          'user_id': '${_userModel.id}',
          'peer_id': '${widget.participantList.followerUserId}',
          'user_name': '${_userModel.name}'
        });

        print("ssssssssssssssssss ${_userModel.name}");
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          Fluttertoast.showToast(
              msg: 'You requested follow ${widget.participantList.name}');
          print(
              "follow user success ---${widget.participantList.isUserRequested}");
        }
      }
    } catch (err) {} finally {}
  }

  void startUnfollowUser() async {
    try {
      if (widget.participantList.isUserFollowed) {
        setState(() {
          widget.participantList.isUserFollowed = false;
        });
        var req =
            await http.post('${Constants.SERVER_URL}user/unfollowuser', body: {
          'user_id': '${_userModel.id}',
          'peer_id': '${widget.participantList.followerUserId}'
        });
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          Fluttertoast.showToast(
              msg: 'You Unfollowed ${widget.participantList.name}');
          print(
              "Unfollow user success ---${widget.participantList.isUserFollowed}");
        }
      }
    } catch (err) {} finally {}
  }

  void cancelFollowReq() async {
    try {
      if (widget.participantList.isUserRequested) {
        setState(() {
          widget.participantList.isUserRequested = false;
        });
        var req = await http
            .post('${Constants.SERVER_URL}user/cancelfollowrequest', body: {
          'user_id': '${_userModel.id}',
          'peer_id': '${widget.participantList.followerUserId}'
        });
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          Fluttertoast.showToast(msg: 'You cancelled follow Reuqest!');
          print(
              "cancel req success ---${widget.participantList.isUserRequested}");
        }
      }
    } catch (err) {} finally {}
  }

  navigateToProfile() {
    if (_userModel.id == widget.participantList.followerUserId) {
       Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => Profile()));

    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => LandlordProfile(
              postOwnerId: widget.participantList.followerUserId)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(widget.padding, widget.padding / 2,
          widget.padding, widget.padding / 2),
      // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  navigateToProfile();
                },
                child: CircleUser(
                  withBorder: widget.withBorder,
                  size: 60,
                  url: Functions.initPorfileImge(widget.participantList.imagesource, "${widget.participantList.fb_url}", "${widget.participantList.img}")
                  
                  // widget.participantList.imagesource == "userimage"
                  //     ? "${Constants.USERS_PROFILES_URL}" +
                  //         "${widget.participantList.img}"
                  //     : "${widget.participantList.fb_url}",
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: widget.width,
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        navigateToProfile();
                      },
                      child: Text(
                        "${widget.participantList.name}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              "${getAge(widget.participantList.userbday)}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        Text(
                          "${widget.participantList.userfollowercount} " +
                              'Followers',
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
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              children: <Widget>[
                widget.participantList.followerUserId == _userModel.id
                    ? Container()
                    : Container(
                        child: widget.participantList.isUserFollowed
                            ? GestureDetector(
                                onTap: () {
                                  startUnfollowUser();
                                },
                                child: RoundedBorderButton(
                                  "UNFOLLOW",
                                  color1: Color.fromRGBO(255, 94, 58, 1),
                                  color2: Color.fromRGBO(255, 149, 0, 1),
                                  textColor: Colors.white,
                                  width:
                                      MediaQuery.of(context).size.width * .35,
                                ),
                              )
                            : !widget.participantList.isUserRequested
                                ? GestureDetector(
                                    onTap: () {
                                      startFollowUser();
                                    },
                                    child: RoundedBorderButton(
                                      "FOLLOW",
                                      color1: Color.fromRGBO(255, 94, 58, 1),
                                      color2: Color.fromRGBO(255, 149, 0, 1),
                                      textColor: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          .35,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      cancelFollowReq();
                                      print(widget
                                          .participantList.isUserFollowed);
                                    },
                                    child: RoundedBorderButton(
                                      "CANCEL REQUEST",
                                      color1: Color.fromRGBO(255, 94, 58, 1),
                                      color2: Color.fromRGBO(255, 149, 0, 1),
                                      textColor: Colors.white,
                                      width: MediaQuery.of(context).size.width *
                                          .35,
                                    ),
                                  ),
                      )
                // SizedBox(width: 5),
                // GestureDetector(
                //   onTap: () {
                //     startDeqReq();
                //   },
                //   child: RoundedBorderButton(
                //     "DELETE",
                //     color1: Colors.grey[200],
                //     color2: Colors.grey[200],
                //     textColor: Colors.blueGrey[700],
                //     width: 80,
                //     fontSize: 10,
                //     shadowColor: Colors.transparent,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
