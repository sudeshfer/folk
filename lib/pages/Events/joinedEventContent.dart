import 'dart:async';
import 'dart:io';
import 'package:folk/pages/Events/full_joinedevent_screen.dart';
import 'package:intl/intl.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:folk/models/joinedEventModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/EventProvider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';
import 'package:folk/utils/HelperWidgets/noResponse_msg.dart';
import 'package:folk/utils/HelperWidgets/tag.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:folk/pages/Events/Widgets/eventParticipantswidget.dart';

Position _currentPosition;

class JoinedEventContent extends StatefulWidget {
  @override
  _JoinedEventContentState createState() => _JoinedEventContentState();
}

class _JoinedEventContentState extends State<JoinedEventContent> {
  AdmobBannerSize bannerSize;

  UserModel _userModel;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ScrollController _controller;
  bool isLoading = true;

  @override
  void initState() {
    startTimer();
    bannerSize = AdmobBannerSize.MEDIUM_RECTANGLE;

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    Provider.of<EventProvider>(context, listen: false)
        .startGetJoinedEventsData(_userModel.id);
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 3), (t) {
      setState(() {
        isLoading = false;
      });
      t.cancel();
    });
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          // Trending(),
          Expanded(
            child: PageView(
              scrollDirection: Axis.vertical,
              controller: PageController(viewportFraction: 1),
              pageSnapping: true,
              children: <Widget>[
                Consumer<EventProvider>(
                    builder: (context, joinedEventProvider, child) {
                  List<JoinedEventModel> _listJoinedEvents = joinedEventProvider.listJoinedEvents;

                  return SmartRefresher(
                      enablePullUp: true,
                      onRefresh: _onEventRefresh,
                      header: WaterDropMaterialHeader(
                        backgroundColor: Color(0xFFFF5E3A),
                      ),
                      controller: _refreshController,
                      child: _listJoinedEvents.isNotEmpty
                          ? ListView.builder(
                              controller: _controller,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                // if (i != 0 && i % 6 == 0) {
                                //   return Column(
                                //     children: <Widget>[
                                //       Container(
                                //         margin: EdgeInsets.only(bottom: 20.0),
                                //         child: AdmobBanner(
                                //           adUnitId: getBannerAdUnitId(),
                                //           adSize: bannerSize,
                                //           listener: (AdmobAdEvent event,
                                //               Map<String, dynamic> args) {},
                                //         ),
                                //       ),
                                //     ],
                                //   );
                                // }

                                JoinedEventModel _event = _listJoinedEvents[i];

                                return EventCard(
                                  EventImage(
                                    "${Constants.USERS_POSTS_IMAGES}" +
                                        "${_listJoinedEvents[i].postImg}",
                                    "${_listJoinedEvents[i].eventDate}",
                                    "Jan",
                                    Tag(
                                      initParticipateStatus(
                                          _listJoinedEvents[i].joinedCount,
                                          _listJoinedEvents[i].maxParticipantCount),
                                      Colors.white,
                                      Colors.deepOrange,
                                      Colors.transparent,
                                      fontSize: 8,
                                    ),
                                  ),
                                  _event,
                                  displayTimeBar: initCountdown(
                                      "${_listJoinedEvents[i].eventDate}"),
                                );
                              },
                              itemCount: _listJoinedEvents.length,
                            )
                          : isLoading
                              ? CardListSkeleton(
                                  style: SkeletonStyle(
                                    theme: SkeletonTheme.Light,
                                    isShowAvatar: true,
                                    isCircleAvatar: true,
                                    barCount: 3,
                                  ),
                                )
                              : Noresponse());
                }),
              ],
            ),
          ),
          SizedBox(height: 100),
        ],
      ),

      // ListView(
      //   children: <Widget>[
      //     EventCard(
      //       EventImage(
      //         "https://i.pinimg.com/originals/dd/2a/eb/dd2aebeb17b09ff7c9c89307d7a98de8.jpg",
      //         "25",
      //         "Jan",
      //         Tag(
      //           "Running Out",
      //           Colors.white,
      //           Colors.deepOrange,
      //           Colors.transparent,
      //           fontSize: 8,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  _scrollListener() async {
    //start LoadMore when maxScrollExtent
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      int x = await Provider.of<EventProvider>(context, listen: false)
          .loadMore(_userModel.id);

      if (x == 0) {
        _refreshController.loadNoData();
      }
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {}
  }

  void _onEventRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    Provider.of<EventProvider>(context, listen: false)
        .startGetJoinedEventsData(_userModel.id);
    _refreshController.refreshCompleted();
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return Constants.BannerAdUnitIdAndroid;
    } else if (Platform.isAndroid) {
      return Constants.BannerAdUnitIdIOS;
    }
    return null;
  }
}

// ignore: must_be_immutable
class EventCard extends StatefulWidget {
  JoinedEventModel eventModel;
  final Widget eventImage;
  final bool displayTimeBar;
  EventCard(this.eventImage, this.eventModel, {this.displayTimeBar = false});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Provider.of<EventProvider>(context, listen: false).joinEventModel = _joinEventModel;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FullJoinedEventScreen(widget.eventModel)),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
        padding: EdgeInsets.only(
          bottom: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: new Offset(5.0, 6.0),
              spreadRadius: 2.0,
              blurRadius: 12.0,
            )
          ],
        ),
        child: Column(
          children: <Widget>[
            (widget.displayTimeBar) ? TimeBar(widget.eventModel) : Container(),
            EventDetailRow(widget.eventImage, widget.eventModel),
          ],
        ),
      ),
    );
  }
}

class EventDetailRow extends StatefulWidget {
  final Widget eventImage;
  JoinedEventModel _eventModel;

  EventDetailRow(this.eventImage, this._eventModel);

  @override
  _EventDetailRowState createState() => _EventDetailRowState();
}

class _EventDetailRowState extends State<EventDetailRow> {
  UserModel _userModel;

  @override
  void initState() {
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    _currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.eventImage,
          Container(
            width: MediaQuery.of(context).size.width - 125,
            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  // color: Colors.red[100],
                  // width: MediaQuery.of(context).size.width - 135,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Tag(
                        "${widget._eventModel.typology}",
                        Color.fromRGBO(255, 112, 67, 1),
                        Color.fromRGBO(255, 112, 67, 0.15),
                        Colors.transparent,
                      ),
                      // Spacer(),
                      Tag(
                        "age: ${widget._eventModel.minage}-${widget._eventModel.maxage}",
                        Colors.black,
                        Colors.white,
                        Colors.grey[200],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                          child: Text(
                            "${widget._eventModel.title}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            FaIcon(
                              FontAwesomeIcons.mapMarkerAlt,
                              size: 12,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "${widget._eventModel.joinedCount}/${widget._eventModel.maxParticipantCount} Partecipants",
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
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                "${widget._eventModel.address}",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget._eventModel.isUserLiked
                          ? GestureDetector(
                              onTap: () {
                                print(widget._eventModel.isUserLiked);
                                if (widget._eventModel.eventOwnerId ==
                                    _userModel.id) {
                                  Fluttertoast.showToast(
                              msg: 'Its your own event');
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
                                if (widget._eventModel.eventOwnerId ==
                                    _userModel.id) {
                                  Fluttertoast.showToast(
                              msg: 'Its your own event');
                                } else {
                                  startAddLike();
                                }
                              },
                              child: new Image.asset(
                                'assets/images/ic_wishlist.png',
                                width: 25,
                                height: 25,
                              ),
                            ),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    EventParticipantList(widget._eventModel.id, _userModel.id),
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
          )
        ],
      ),
    );
  }

  void startAddLike() async {
    String userImg = (_userModel.imagesource == 'userimage')
        ? _userModel.img
        :_userModel.fb_url;
    String imagesource = _userModel.imagesource;
    // setState(() {
    //   isBasy = true;
    // });

    try {
      if (!widget._eventModel.isUserLiked) {
        setState(() {
          widget._eventModel.isUserLiked = true;
          ++widget._eventModel.postLikes;
          // isBasy = false;
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
         Fluttertoast.showToast(
                              msg: 'Event Saved');
          print("like successs ---${widget._eventModel.isUserLiked}");
        }
      } else {
        setState(() {
          widget._eventModel.isUserLiked = false;
          --widget._eventModel.postLikes;
          // isBasy = false;
        });
        var req = await http.post('${Constants.SERVER_URL}like/eventunlike',
            body: {
              'user_id': '${_userModel.id}',
              'event_id': '${widget._eventModel.id}'
            });
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          // setState(() {
          //   widget._eventModel.isUserLiked = false;
          //   --widget._eventModel.postLikes;
          //   // isBasy = false;
          // });
          print("unlike successs ---${widget._eventModel.isUserLiked}");
        }
      }
    } catch (err) {} finally {}
  }
}

class EventImage extends StatefulWidget {
  final String url;
  final String date;
  final String month;
  final Widget tag;

  EventImage(this.url, this.date, this.month, this.tag);

  @override
  _EventImageState createState() => _EventImageState();
}

class _EventImageState extends State<EventImage> {
  String justDate = "";
  String justMonth = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    justDate = DateTime.parse(widget.date).day.toString();
    final DateTime now = DateTime.parse(widget.date);
    final DateFormat formatter = DateFormat('MMM');
    final String formatted = formatter.format(now);
    justMonth = formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.deepOrange[100],
        image:
            DecorationImage(fit: BoxFit.cover, image: NetworkImage(widget.url)),
      ),
      height: 130,
      width: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Text(
              justDate,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Text(
              justMonth,
              style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 20,
              ),
            ),
          ),
          Spacer(),
          widget.tag,
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

class TimeBar extends StatelessWidget {
  JoinedEventModel _eventModel;
  TimeBar(this._eventModel);

  @override
  Widget build(BuildContext context) {
    returnTimebarSeconds() {
      DateTime exp = DateTime.parse(_eventModel.eventDate);
      final datenow = DateTime.now();
      final expdate = exp.difference(datenow).inSeconds;

      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(expdate);
      return expdate;
    }

    return Container(
        margin: const EdgeInsets.only(top: 0),
        height: 30,
        decoration: BoxDecoration(color: Color(0xFFFF5E3A)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 28.0),
              child: new Icon(
                FontAwesomeIcons.hourglass,
                color: Colors.white,
                size: 15,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12.0),
              child: SlideCountdownClock(
                duration: Duration(seconds: returnTimebarSeconds()),
                slideDirection: SlideDirection.Up,
                separator: ":",
                textStyle: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontSize: 13,
                ),
                shouldShowDays: true,
                onDone: () {},
              ),
            )
          ],
        ));
  }
}
