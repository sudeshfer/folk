import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folk/models/EventModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/models/PublicChatMessageModel.dart';
import 'package:folk/pages/Messaging/chat_screen.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/pages/Events/events_content.dart';
import 'package:folk/utils/HelperWidgets/buttons.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';
import 'package:folk/utils/HelperWidgets/map.dart';
import 'package:folk/utils/HelperWidgets/ratings_bar.dart';
import 'package:folk/utils/HelperWidgets/read_more_text.dart';
import 'package:folk/utils/HelperWidgets/tag.dart';
import 'package:folk/pages/Profile_Page/landlord_profile.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:folk/utils/HelperWidgets/cantLeaveEventMsg.dart';
import 'package:folk/pages/publicChatRooms/PublicChatRoomMessagesPage.dart';
import 'package:folk/providers/EventProvider.dart';
import 'package:folk/pages/Profile_Page/Profile.dart';
import 'package:folk/pages/Events/Widgets/eventParticipantswidget.dart';


Position _currentPosition;

class FullEventScreen extends StatefulWidget {
  @override
  _FullEventScreenState createState() => _FullEventScreenState();
}

class _FullEventScreenState extends State<FullEventScreen> {
  UserModel _userModel;
  EventModel _eventModel;

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
    // TODO: implement initState
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    _eventModel = Provider.of<EventProvider>(context, listen: false).eventModel;
  }

  @override
  Widget build(BuildContext context) {
    bool initCountdown(eventdate) {
      DateTime temp = DateTime.parse(eventdate);
      int diff = (temp.difference(DateTime.now()).inHours);
      if (diff <= 8) {
        //  print("date difference issssssssssss $diff");
        return true;
      } else {
        //  print("date difference issssssssssss $diff");
        return false;
      }
    }

    void startJoinEvent() async {
      String userImg = (_userModel.imagesource == 'userimage')
          ? _userModel.img
          : _userModel.fb_url;
      String imagesource = _userModel.imagesource;

      try {
        if (!_eventModel.isUserJoined) {
          setState(() {
            Provider.of<EventProvider>(context, listen: false)
                .updateUserJoinedStatusAndcount(
                    true, _eventModel.joinedCount + 1);
            _eventModel.joinedCount++;
          });

          var req =
              await http.post('${Constants.SERVER_URL}event/joinevent', body: {
            'user_id': '${_userModel.id}',
            'user_img': userImg,
            'imagesource': imagesource,
            'user_name': '${_userModel.name}',
            'event_id': '${_eventModel.id}',
            'peer_id': '${_eventModel.eventOwnerId}'
          });
          var res = convert.jsonDecode(req.body);
          print("workinggggggg");
          if (!res['error']) {
            Fluttertoast.showToast(
                msg: 'Successfully joined, You can start chatting !');
            print("join successs ---${_eventModel.isUserJoined}");
          }
        }
      } catch (err) {} finally {}
    }

    void leaveEvent() async {
      try {
        if (_eventModel.isUserJoined) {
          setState(() {
            Provider.of<EventProvider>(context, listen: false)
                .updateUserJoinedStatusAndcount(
                    false, _eventModel.joinedCount - 1);
            _eventModel.joinedCount--;
          });
          var req = await http.post('${Constants.SERVER_URL}event/leaveevent',
              body: {
                'user_id': '${_userModel.id}',
                'event_id': '${_eventModel.id}'
              });
          var res = convert.jsonDecode(req.body);
          if (!res['error']) {
            Fluttertoast.showToast(msg: 'you leave from the event');
            print("leave event successs ---${_eventModel.isUserLiked}");
          }
        }
      } catch (err) {} finally {}
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: _buildHeader(context),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              // Carousel(imgList: imgList),
              Container(
                height: MediaQuery.of(context).size.height / 3.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepOrange[100],
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("${Constants.USERS_POSTS_IMAGES}" +
                          "${_eventModel.postImg}")),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 12.0, top: 15, bottom: 15),
                  child: Row(
                    children: <Widget>[
                      Tag(
                        "${_eventModel.typology}",
                        Colors.deepOrange,
                        Colors.deepOrange.withOpacity(0.1),
                        Colors.transparent,
                      ),
                      // Tag(
                      //   "historical",
                      //   Colors.deepOrange,
                      //   Colors.deepOrange.withOpacity(0.1),
                      //   Colors.transparent,
                      // ),
                    ],
                  ),
                ),
              ),
              initCountdown(_eventModel.eventDate)
                  ? TimeBar(_eventModel)
                  : Container(),
              DetailCard(_eventModel),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Details",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Reviews",
                      style: TextStyle(
                        // color: Colors.deepOrange,
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    RatingsBar(
                      4,
                      size: 15,
                      padding: 3,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Description(_eventModel),
                    User(_eventModel),
                    _eventModel.eventOwnerId == _userModel.id ||
                            _eventModel.isUserJoined
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Text(
                                  "Chatroom",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                color: Colors.grey[100],
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        "Join the private chatroom with all the partecipents.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blueGrey[700],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // initSocket();
                                        // Navigator.of(context).push(MaterialPageRoute(
                                        //     builder: (context) => ChatScreen(
                                        //     )));
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PublicChatRoomMessagesPage(
                                                        _eventModel.roomId,
                                                        _eventModel.title)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: RoundedBorderButton(
                                            "JOIN CHAT",
                                            textColor: Colors.white,
                                            color1:
                                                Color.fromRGBO(255, 94, 58, 1),
                                            color2:
                                                Color.fromRGBO(255, 149, 0, 1),
                                            // width: MediaQuery.of(context).size.width * .7,
                                            height: 45,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        : Container(),
                    Divider(),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Text(
                        "Location",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    MapBox(_eventModel),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(8),
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Free!",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                      Text(
                        "${_eventModel.joinedCount} Attending",
                        style: TextStyle(
                          fontSize: 12,
                          // color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  _eventModel.joinedCount == _eventModel.maxParticipantCount
                      ? RoundedBorderButton(
                          "IT's FULL!",
                          textColor: Colors.white,
                          color1: Color.fromRGBO(255, 94, 58, 1),
                          color2: Color.fromRGBO(255, 149, 0, 1),
                          width: 140,
                          height: 50,
                          shadowColor: Colors.transparent,
                        )
                      : _eventModel.isUserJoined
                          ? GestureDetector(
                              onTap: () {
                                if (initCountdown(_eventModel.eventDate)) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Sorry !"),
                                          content: CantLeaveEvent(),
                                        );
                                      });
                                } else {
                                  leaveEvent();
                                  print("leaving event");
                                }
                              },
                              child: RoundedBorderButton(
                                "Leave IT!",
                                textColor: Colors.white,
                                color1: Color.fromRGBO(255, 94, 58, 1),
                                color2: Color.fromRGBO(255, 149, 0, 1),
                                width: 140,
                                height: 50,
                                shadowColor: Colors.transparent,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                if (_eventModel.eventOwnerId == _userModel.id) {
                                  print("own event");
                                  Fluttertoast.showToast(
                                      msg:
                                          'This is your own event, start chatting !');
                                } else {
                                  print("joining event");
                                  startJoinEvent();
                                }
                              },
                              child: RoundedBorderButton(
                                "JOIN IT!",
                                textColor: Colors.white,
                                color1: Color.fromRGBO(255, 94, 58, 1),
                                color2: Color.fromRGBO(255, 149, 0, 1),
                                width: 140,
                                height: 50,
                                shadowColor: Colors.transparent,
                              ),
                            ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class User extends StatefulWidget {
  EventModel _eventModel;

  User(this._eventModel, {Key key}) : super(key: key);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  UserModel _userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
  }

  @override
  Widget build(BuildContext context) {
    getAge(bday) {
      final birthday = DateTime.parse(bday);
      final dtnow = DateTime.now();
      final difference = dtnow.difference(birthday).inDays;
      final age = difference / 365;
      return age.toStringAsFixed(0);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleUser(
                size: 50,
                url: widget._eventModel.imagesource == 'fb'
                    ? "${widget._eventModel.fb_url}"
                    : "${Constants.USERS_PROFILES_URL}" + "${widget._eventModel.img}",
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  if(widget._eventModel.eventOwnerId == _userModel.id){
                   Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Profile()));
                  }else{
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LandlordProfile(
                          postOwnerId: widget._eventModel.eventOwnerId)));
                  }
                  
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${widget._eventModel.userName}"),
                    Row(
                      children: <Widget>[
                        FaIcon(
                          FontAwesomeIcons.venus,
                          size: 15,
                          color: Colors.grey[700],
                        ),
                        SizedBox(width: 5),
                        Text(
                          getAge(widget._eventModel.userbday),
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "${widget._eventModel.ownerfollowercount} Followers",
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
          FaIcon(FontAwesomeIcons.ellipsisH)
        ],
      ),
    );
  }
}

class Description extends StatelessWidget {
  EventModel _eventModel;

  Description(this._eventModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            "Description",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5),
          ReadMoreText(
            "${_eventModel.eventData}",
            expandingButtonColor: Colors.deepOrange,
          ),
          Divider(),
        ],
      ),
    );
  }
}

class DetailCard extends StatefulWidget {
  EventModel _eventModel;

  DetailCard(this._eventModel, {Key key}) : super(key: key);

  @override
  _DetailCardState createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  UserModel _userModel;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
  }

  _getCurrentLocation() async {
    _currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    getDateString() {
      String justDate =
          DateTime.parse(widget._eventModel.eventDate).day.toString();
      final DateTime now = DateTime.parse(widget._eventModel.eventDate);
      final DateFormat formatter = DateFormat('MMM');
      final DateFormat weekday = DateFormat('EEE');
      final DateFormat formattedTime = DateFormat().add_jm();
      final String formattedMonth = formatter.format(now);
      String justMonth = formattedMonth;

      return "${weekday.format(now)}, $justDate $justMonth at ${formattedTime.format(now)}";
    }

    getDistance(shopLat, shopLong) {
      final Distance distance = new Distance();
      if (_currentPosition != null) {
        // km = 423
        final double km = distance.as(
            LengthUnit.Kilometer,
            new LatLng(_currentPosition.longitude, _currentPosition.latitude),
            new LatLng(shopLat, shopLong));

        if (km < 1) {
          print("less than 1 Km");

          return "Less than 1";
        } else {
          print(km.toString());

          return (km.toStringAsFixed(0));
        }
      } else
        return "";
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

    return Container(
      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Text(
                  "${widget._eventModel.title}",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              widget._eventModel.isUserLiked
                  ? GestureDetector(
                      onTap: () {
                        print(widget._eventModel.isUserLiked);
                        if (widget._eventModel.eventOwnerId == _userModel.id) {
                          Fluttertoast.showToast(msg: 'Its your own event');
                        } else {
                          startAddLike();
                        }
                      },
                      child: FaIcon(
                        FontAwesomeIcons.solidHeart,
                        color: Colors.red,
                        size: 15,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        if (widget._eventModel.eventOwnerId == _userModel.id) {
                          Fluttertoast.showToast(msg: 'Its your own event');
                        } else {
                          startAddLike();
                        }
                      },
                      child: FaIcon(
                        FontAwesomeIcons.heart,
                        size: 20,
                      ),
                    )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.mapMarkerAlt,
                        size: 12,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        getDateString(),
                        // "Sun, 10 Mar at 21",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.mapMarkerAlt,
                        size: 12,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "${widget._eventModel.joinedCount}/${widget._eventModel.maxParticipantCount} Partecipents",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.mapMarkerAlt,
                        size: 12,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "${widget._eventModel.address}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                initParticipateStatus(widget._eventModel.joinedCount,
                    widget._eventModel.maxParticipantCount),
                style: TextStyle(
                  color: Colors.deepOrange,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              EventParticipantList( widget._eventModel.id, _userModel.id),
              // Container(
              //   alignment: Alignment.centerLeft,
              //   // color: Colors.red[100],
              //   width: 90,
              //   child: Stack(
              //     children: <Widget>[
              //       AlignedCircleUser(
              //         Alignment(0.33, 0),
              //         CircleUser(
              //           url:
              //               "https://linustechtips.com/main/uploads/monthly_2017_04/cool-cat.thumb.jpg.cae04ebfb8304d3e1592f0d04c24f85d.jpg",
              //         ),
              //       ),
              //       AlignedCircleUser(
              //         Alignment(-0.33, 0),
              //         CircleUser(
              //           url:
              //               "https://hips.hearstapps.com/ell.h-cdn.co/assets/16/41/980x980/square-1476463747-coconut-oil-final-lowres.jpeg?resize=480:*",
              //         ),
              //       ),
              //       AlignedCircleUser(
              //         Alignment(-1, 0),
              //         CircleUser(
              //           url:
              //               "https://i.pinimg.com/236x/00/f0/85/00f0854dc796254312890d7df2b02f9c.jpg",
              //         ),
              //       ),
              //       AlignedCircleUser(
              //         Alignment(1, 0),
              //         CircleUser(
              //           val: 4,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Spacer(),
              Text(
                getDistance(widget._eventModel.latitude,
                        widget._eventModel.longitute) +
                    " Km",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void startAddLike() async {
    String userImg = (widget._eventModel.imagesource == 'userimage')
        ? widget._eventModel.img
        : widget._eventModel.fb_url;
    String imagesource = widget._eventModel.imagesource;

    try {
      if (!widget._eventModel.isUserLiked) {
        setState(() {
          widget._eventModel.isUserLiked = true;
          ++widget._eventModel.postLikes;
        });

        var req =
            await http.post('${Constants.SERVER_URL}like/eventlike', body: {
          'user_id': '${_userModel.id}',
          'user_img': userImg,
          'imagesource': imagesource,
          'user_name': '${_userModel.name}',
          'event_id': '${widget._eventModel.id}',
          'peer_id': '${widget._eventModel.eventOwnerId}'
        });
        var res = convert.jsonDecode(req.body);
        print("workinggggggg");
        if (!res['error']) {
          Fluttertoast.showToast(msg: 'Event Saved');
          print("like successs ---${widget._eventModel.isUserLiked}");
        }
      } else {
        setState(() {
          widget._eventModel.isUserLiked = false;
          --widget._eventModel.postLikes;
        });
        var req = await http.post('${Constants.SERVER_URL}like/eventunlike',
            body: {
              'user_id': '${_userModel.id}',
              'event_id': '${widget._eventModel.id}'
            });
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          Fluttertoast.showToast(msg: 'Event UnSaved');
          print("unlike successs ---${widget._eventModel.isUserLiked}");
        }
      }
    } catch (err) {} finally {}
  }
}

class Carousel extends StatefulWidget {
  const Carousel({
    Key key,
    @required this.imgList,
  }) : super(key: key);

  final List<String> imgList;

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        CarouselSlider(
          onPageChanged: (index) {
            setState(() {
              _current = index;
            });
          },
          autoPlay: true,
          viewportFraction: 1.0,
          height: MediaQuery.of(context).size.height * .3,
          // aspectRatio: MediaQuery.of(context).size.aspectRatio,
          items: widget.imgList.map(
            (url) {
              return Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    width: 1000.0,
                  ),
                ),
              );
            },
          ).toList(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imgList.map(
              (element) {
                int index = widget.imgList.indexOf(element);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(255, 255, 255, 0.5)),
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }
}

class AccInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 45.0,
          width: 45.0,
          margin: EdgeInsets.all(10),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                  "https://i.pinimg.com/originals/be/ac/96/beac96b8e13d2198fd4bb1d5ef56cdcf.jpg"),
            ),
          ),
        ),
        new SizedBox(
          width: 10.0,
        ),
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 5.0, bottom: 5),
                child: new Text(
                  "Allie Hall",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 17,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 5.0, bottom: 5),
                          child: new Text(
                            "5 hours ago",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          child: Icon(Icons.location_on,
                              color: Colors.grey, size: 17),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 2),
                          child: new Text(
                            "10 Km away",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class CustomToggleButton extends StatefulWidget {
  @override
  _CustomToggleButtonState createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  String state = "Events";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          (state == "Posts") ? state = "Events" : state = "Posts";
        });
      },
      child: Stack(
        alignment:
            (state == "Posts") ? Alignment.centerLeft : Alignment.centerRight,
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
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 40,
            width: 200,
            margin: EdgeInsets.all(25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "Posts",
                  style: TextStyle(
                    color: (state == "Posts") ? Colors.black : Colors.white,
                  ),
                ),
                Text(
                  "Events",
                  style: TextStyle(
                    color: (state == "Events") ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final String name;
  final Color color1;
  final Color color2;
  final Color textColor;
  ProfileButton(this.name,
      {this.color1 = Colors.grey,
      this.color2 = Colors.grey,
      this.textColor = Colors.black});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width * .35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            offset: new Offset(5.0, 6.0),
            spreadRadius: 2.0,
            blurRadius: 12.0,
          )
        ],
        gradient: LinearGradient(
          colors: [
            color1,
            color2,
          ],
        ),
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
