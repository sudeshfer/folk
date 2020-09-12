//created by Suthura

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folk/pages/Messaging/message_content_tab.dart';
import 'package:folk/pages/Profile_Page/landlord_profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/PostModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/widgets/postPage.dart';
import 'package:folk/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:geolocator/geolocator.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:latlong/latlong.dart';
import 'package:folk/Utils/HelperWidgets/buttons.dart';
import 'package:folk/pages/Profile_Page/Profile.dart';
import 'package:folk/providers/PostProvider.dart';
import 'package:folk/utils/Util_Functions/functions.dart';

Position _currentPosition;

// ignore: must_be_immutable
class PostsPageItem extends StatefulWidget {
  PostModel _postModel;
  String _myId;
  String _myName;
  String _myImg;
  String imagesource;
  String fb_url;
  bool isFromHomePage = false;
  bool isFromCommentPage = true;

  PostsPageItem(this._postModel, this._myId, this._myName, this._myImg,
      this.imagesource, this.fb_url,
      {this.isFromHomePage = false, this.isFromCommentPage = true});

  @override
  _PostsPageItemState createState() => _PostsPageItemState();
}

class _PostsPageItemState extends State<PostsPageItem> {
  var hasLikedIcon = Image.asset(
    'assets/images/icon_wishlisted.png',
    width: 32,
    height: 32,
  );
  var hasNoLikedIcon = Image.asset(
    'assets/images/ic_wishlist.png',
    width: 32,
    height: 32,
  );
  var liking = Icon(
    Icons.more_horiz,
    size: 20,
  );

  var date;
  UserModel userModel;

  bool isBasy = false;
  _getCurrentLocation() async {
    _currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    //       List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
    // Placemark place = placemark[0];
    // print(" City is "+ place.locality);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("lat", _currentPosition.latitude.toDouble());
    prefs.setDouble("lng", _currentPosition.longitude.toDouble());
    // prefs.setString("city", place.locality.toString());
    double lat = prefs.getDouble("lat");
    print("latitude is " + lat.toString());

    print(_currentPosition.latitude.toString());
    print(_currentPosition.longitude.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentLocation();
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    date = new DateTime.fromMillisecondsSinceEpoch(widget._postModel.timeStamp);
  }

  bool isWishBtnClicked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, widget.isFromCommentPage?0: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            offset: new Offset(0.0, 6.0),
            spreadRadius: 2.0,
            blurRadius: 12.0,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 8.0, 16.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.only(top: 5),
                    child: InkWell(
                      onTap: () {
                        print("${widget._postModel.imagesource}");
                        if (widget._postModel.postOwnerId == userModel.id) {
                            Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Profile()));
                          } else {
                            Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => LandlordProfile(postOwnerId:widget._postModel.postOwnerId)));
                          }
                        
                      },
                                          child: Row(
                        children: <Widget>[
                          CachedNetworkImage(
                            imageUrl: Functions.initPorfileImge(widget._postModel.imagesource, "${widget._postModel.fb_url}", "${widget._postModel.img}"),
                            imageBuilder: (context, imageProvider) => Container(
                              width: 45.0,
                              height: 45.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          new SizedBox(
                            width: 10.0,
                          ),
                          _buildNameContent(context, 'widget.passedItem')
                        ],
                      ),
                    ),
                  ),
                  PopupMenuButton<int>(
                      icon: Icon(Icons.more_horiz, size: 35),
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                child: InkWell(
                              onTap: () {
                                print("Report");
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => AddItemPage()));
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.report,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Report")
                                ],
                              ),
                            )),
                            PopupMenuItem(
                                child: InkWell(
                              onTap: () {
                                print("Copy Link");
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => ViewItemPage()));
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.content_copy,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Copy Link")
                                ],
                              ),
                            )),
                          widget._postModel.postOwnerId == userModel.id?  PopupMenuItem(
                                child: InkWell(
                              onTap: () {
                                print("Enable notification");
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => ViewItemPage()));
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.notifications_active,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Enable notification")
                                ],
                              ),
                            )):null,
                         widget._postModel.postOwnerId == userModel.id? PopupMenuItem(
                                child: InkWell(
                              onTap: () {
                                print("delete post");
                                 Provider.of<PostProvider>(context, listen: false)
                                 .deletePostRequest(widget._postModel.id);
                                 Provider.of<PostProvider>(context, listen: false)
                                 .startGetPostsData(userModel.id);
                                 Navigator.of(context).pop();
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => ViewItemPage()));
                              },
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.delete_forever,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Delete Post")
                                ],
                              ),
                            )):null
                          ]),
                ],
              ),
            ),
          ),

          widget._postModel.expDate != null
              ? _buildTimeBar(context)
              : Container(),
          _buildWishListBar(context),
          _buildPostText(context, 'widget.passedItem'),
          _devider(context),
          _buildLikeCommentBar(context, 'widget.passedItem'),
          SizedBox(height: 10),
          //  _devider(context),
        ],
      ),
    );
  }

  _showImg(passedItem) {
    return CachedNetworkImage(
      imageUrl: "${Constants.USERS_PROFILES_URL}" + "${widget._postModel.img}",
      fit: BoxFit.fill,
    );
    // if (passedItem.uImageSource == "userimage") {
    //   return DecorationImage(
    //     image: MemoryImage(convert.base64Decode(passedItem.base_64)),
    //     fit: BoxFit.fill,
    //   );
    // } else if (passedItem.uImageSource == "fb") {
    //   return DecorationImage(
    //       image: NetworkImage(passedItem.fbUrl), fit: BoxFit.fill);
    // } else {
    //   return DecorationImage(
    //       fit: BoxFit.fill, image: new AssetImage('assets/images/Avatar.png'));
    // }
  }

  Widget _buildAvatar(BuildContext context, passedItem) {
    return Container(
      height: 45.0,
      width: 45.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        image: _showImg(passedItem),
        // new DecorationImage(
        //     fit: BoxFit.fill,
        //     image: new AssetImage('assets/images/Avatar.png'))
        // ,
      ),
    );
  }

  Widget _buildNameContent(BuildContext context, passedItem) {
    getDistance(shopLat, shopLong) {
      final Distance distance = new Distance();
      if (_currentPosition != null) {
        // km = 423
        final double km = distance.as(
            LengthUnit.Kilometer,
            new LatLng(_currentPosition.longitude, _currentPosition.latitude),
            new LatLng(shopLat, shopLong));

        if (km < 1) {
          print("less than 1 km away");

          return "Less than 1";
        } else {
          print(km.toString());

          return (km.toStringAsFixed(0));
        }
      } else
        return "";
    }

    getAge(bday) {
      final birthday = DateTime.parse(bday);
      final dtnow = DateTime.now();
      final difference = dtnow.difference(birthday).inDays;
      final age = difference / 365;
      return age.toStringAsFixed(0);
    }

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 5.0, bottom: 5),
            child: new Text(
              '${widget._postModel.userName}' +
                  ', ' +
                  getAge(widget._postModel.userbday),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 5.0, bottom: 5),
                      child: InkWell(
                        onTap: () {
                          print(date);
                        },
                                              child: new Text(
                          '${timeAgo.format(date)}',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Container(
                      margin: const EdgeInsets.only(top: 1),
                      child:
                          Icon(Icons.location_on, color: Colors.grey, size: 15),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: new Text(
                          getDistance(widget._postModel.latitude,
                                  widget._postModel.longitute) +
                              " km away",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTimeBar(
    BuildContext context,
  ) {
    DateTime exp = DateTime.parse(widget._postModel.expDate);
    final datenow = DateTime.now();
    final expdate = exp.difference(datenow).inSeconds;
    // int endTime = int.parse(expdate.toString());
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print(expdate);

    return Flexible(
      fit: FlexFit.loose,
      child: Container(
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
                  duration: Duration(seconds: expdate),
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
          )),
    );
  }

  Widget _buildWishListBar(BuildContext context) {
    // print("*************************************************************");
    // print(userModel.userInterests[0].interestname);
    // print("*************************************************************");

    int returnsColor(index) {
      int colour = 0;
      if (userModel.userInterests.any((element) =>
          element.interestname == widget._postModel.postCats[index].catName)) {
        // print("cat isssssssssssssssssssssssssssssssss ${widget._postModel.postCats[i].catName}");
        colour = 0xFFFFEBE7; //common interest
      } else {
        colour = 0xFFFAFAFA; //not common interest
      }
      // for (var i = 0; i < widget._postModel.postCats.length; i++) {
      //   if (userModel.userInterests.any((element) => element.interestname == widget._postModel.postCats[i].catName)) {
      //     // print("cat isssssssssssssssssssssssssssssssss ${widget._postModel.postCats[i].catName}");
      //     colour = 0xFFFFEBE7; //common interest
      //   } else {
      //     colour = 0xFFFAFAFA; //not common interest
      //   }
      // }

      return colour;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.width / 12.5,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget._postModel.postCats.length,
                  itemBuilder: (context, i2) {
                    return Container(
                      margin: EdgeInsets.only(right: 7),
                      height: 30,
                      width: MediaQuery.of(context).size.width / 5.5,
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE0E0E0)),
                          color: Color(returnsColor(i2)),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50.0),
                              topRight: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0),
                              bottomLeft: Radius.circular(0.0))),
                      child: Center(
                        child: Text(
                          "${widget._postModel.postCats[i2].catName}",
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color.fromRGBO(255, 112, 67, 1),
                              fontSize: 13),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          _buildWishlistBtn(context)
        ],
      ),
    );
  }

  Widget _buildWishlistBtn(BuildContext context) {
    return Container(
      child: widget._postModel.isUserLiked
          ? GestureDetector(
              onTap: () {
                print(widget._postModel.isUserLiked);
                if (widget._postModel.postOwnerId == userModel.id) {
                  Fluttertoast.showToast(msg: 'can\'t like your post ');
                } else {
                  if (!isBasy) startAddLike();
                }
              },
              child: Image.asset(
                'assets/images/icon_wishlisted.png',
                width: 32,
                height: 32,
              ),
            )
          : GestureDetector(
              onTap: () {
                if (widget._postModel.postOwnerId == userModel.id) {
                  Fluttertoast.showToast(msg: 'can\'t like your post ');
                } else {
                  if (!isBasy) startAddLike();
                }
              },
              child: new Image.asset(
                'assets/images/ic_wishlist.png',
                width: 32,
                height: 32,
              ),
            ),
    );
  }

  Widget _buildPostText(BuildContext context, passedItem) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 20, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                // margin: const EdgeInsets.only(bottom: 5),
                child: Text(
              '${widget._postModel.postData}',
              style: TextStyle(
                  color: Color(0xFF020433),
                  fontFamily: 'Montserrat',
                  fontSize: 15),
            )),
          ],
        ),
      ),
    );
  }

  Widget _devider(BuildContext context) {
    return Divider(
      color: Colors.grey[200],
      thickness: 2,
    );
  }

  Widget _buildLikeCommentBar(BuildContext context, passedItem) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Image.asset('assets/images/LikePressed.png',
              width: 32, height: 32),
          new Text(
            '${widget._postModel.postLikes == 0 ? '0' : widget._postModel.postLikes.abs()}' +
                " Likes",
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 14),
          ),
          new SizedBox(
            width: 10.0,
          ),
          widget._postModel.typology == 'post'
              ? new Image.asset('assets/images/Comments.png',
                  width: 32, height: 32)
              : Container(),
          widget._postModel.typology == 'post'
              ? InkWell(
                  onTap: widget.isFromCommentPage
                      ? null
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PostSection(
                                    widget._postModel,
                                    isFromHomePage: true,
                                  )));
                        },
                  child: new Text(
                    '${widget._postModel.commentsCount == 0 ? '0' : widget._postModel.commentsCount.abs()}' +
                        " comments",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 14),
                  ),
                )
              : GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pushNamed('/notifications');4
                      
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => MessagesContent()));
                    },
                              child: RoundedBorderButton(
                    "JOIN CHAT",
                    textColor: Colors.white,
                    color1: Color.fromRGBO(255, 94, 58, 1),
                    color2: Color.fromRGBO(255, 149, 0, 1),
                    // width: MediaQuery.of(context).size.width * .7,
                    height: 45,
                    fontSize: 14,
                  ),
              ),
        ],
      ),
    );
  }

  void startAddLike() async {
    String userImg =
        (widget.imagesource == 'userimage') ? widget._myImg : widget.fb_url;
    String imagesource = widget.imagesource;
    setState(() {
      isBasy = true;
    });
    try {
      if (!widget._postModel.isUserLiked) {
        var req = await http.post('${Constants.SERVER_URL}like/create', body: {
          'user_id': '${widget._myId}',
          'user_img': userImg,
          'imagesource': imagesource,
          'user_name': '${widget._myName}',
          'post_id': '${widget._postModel.id}',
          'peer_id': '${widget._postModel.postOwnerId}'
        });
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          setState(() {
            widget._postModel.isUserLiked = true;
            ++widget._postModel.postLikes;
            isBasy = false;
          });
          print(widget._postModel.isUserLiked);
        }
      } else {
        var req = await http.post('${Constants.SERVER_URL}like/delete', body: {
          'user_id': '${widget._myId}',
          'post_id': '${widget._postModel.id}'
        });
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          setState(() {
            widget._postModel.isUserLiked = false;
            --widget._postModel.postLikes;
            isBasy = false;
          });
        }
      }
    } catch (err) {} finally {}
  }
}
