import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/utils/HelperWidgets/buttons.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';
import 'package:folk/utils/HelperWidgets/read_more_text.dart';
import 'package:folk/utils/MainWigets/bottomAppBar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:dio/dio.dart';
import 'package:folk/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:folk/models/UserModel.dart';
import 'package:folk/models/peerProfileModel.dart';
import 'package:folk/models/EventModel.dart';
import 'package:folk/models/PostModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/PeerProfileProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:folk/pages/Events/events_content.dart';
import 'package:folk/pages/FullScreenImg.dart';
import 'package:folk/utils/HelperWidgets/tag.dart';
import 'package:folk/utils/HelperWidgets/noResponse_msg.dart';
import 'package:folk/widgets/PostsPageItem.dart';
import '../MessagesPage.dart';
import 'package:folk/pages/ProfileFollowersPage/profile_followers_page.dart';

class LandlordProfile extends StatefulWidget {
  final postOwnerId;
  LandlordProfile({this.postOwnerId});

  @override
  _LandlordProfileState createState() => _LandlordProfileState();
}

class _LandlordProfileState extends State<LandlordProfile> {
  UserModel _userModel;
  List<PeerProfileModel> profileDetails = List();
  bool isfetching = true;
  bool isEmpty = false;
  List<String> imgurls = [];

  List<PostModel> _listPosts = [];
  List<EventModel> _listEvents = [];
  bool isfetched = true;
  String state = "Posts";
  bool isToggle = false;

  @override
  void initState() {
    // TODO: implement initState
    print("owner id isssssssssssssssssss ${widget.postOwnerId}");
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    // Provider.of<PeerProfileProvider>(context, listen: false).startGetPeerProfile(_userModel.id,widget.postOwnerId);
    super.initState();
    getPeerProfileDetails();
    getUserPosts();
    getUserEvents();
  }

  getPeerProfileDetails() {
    Provider.of<PeerProfileProvider>(context, listen: false)
        .startGetPeerProfile(_userModel.id, widget.postOwnerId)
        .then((profileFromServer) {
      print(profileFromServer.length);
      if (profileFromServer.isNotEmpty) {
        setState(() {
          print("*************************************");
          print("followed" + profileFromServer[0].isUserFollowed.toString());
          print("reuested" + profileFromServer[0].isUserRequested.toString());
          print("*************************************");

          profileDetails = profileFromServer;
          isfetching = false;
          isEmpty = false;
        });
        returnimgurls();
      } else {
        setState(() {
          isfetching = false;
          isEmpty = true;
        });
      }
    });
  }

  returnimgurls() {
    if (profileDetails[0].imagesource == "userimage") {
      imgurls
          .add("${Constants.USERS_PROFILES_URL}" + "${profileDetails[0].img}");
    }
    if (profileDetails[0].imagesource == "fb") {
      imgurls.add("${profileDetails[0].fb_url}");
    }
    if (profileDetails[0].img2 != "default-user-profile-image.png") {
      imgurls
          .add("${Constants.USERS_PROFILES_URL}" + "${profileDetails[0].img2}");
    }
    if (profileDetails[0].img3 != "default-user-profile-image.png") {
      imgurls
          .add("${Constants.USERS_PROFILES_URL}" + "${profileDetails[0].img3}");
    }
    if (profileDetails[0].img4 != "default-user-profile-image.png") {
      imgurls
          .add("${Constants.USERS_PROFILES_URL}" + "${profileDetails[0].img4}");
    }
    if (profileDetails[0].img5 != "default-user-profile-image.png") {
      imgurls
          .add("${Constants.USERS_PROFILES_URL}" + "${profileDetails[0].img5}");
    }
    if (profileDetails[0].img6 != "default-user-profile-image.png") {
      imgurls
          .add("${Constants.USERS_PROFILES_URL}" + "${profileDetails[0].img6}");
    }
  }

  getUserPosts() {
    //start get Posts !
    print("getUserPosts running.............................");

    String _url = "${Constants.SERVER_URL}post/fetch_posts_by_user_id";
    return http.post(_url, body: {
      'user_id': '${_userModel.id}',
      'peer_id': '${widget.postOwnerId}',
    }).then((res) async {
      var convertedData = convert.jsonDecode(res.body);
      if (!convertedData['error']) {
        List data = convertedData['data'];
        if (data.isNotEmpty) {
          setState(() {
            _listPosts = data.map((data) => PostModel.fromJson(data)).toList();
            isfetched = false;
          });
          // print(data);
        } else {
          print("empty response");
          setState(() {
            isfetched = false;
            isEmpty = true;
          });
        }
      }
    }).catchError((err) {
      print('init Data error is $err');
    });
  }

  getUserEvents() {
    //start get Posts !
    print("getUserPosts running.............................");

    String _url = "${Constants.SERVER_URL}event/getuserevents";
    return http.post(_url, body: {
      'user_id': '${_userModel.id}',
      'page': '1',
      'peer_id': '${widget.postOwnerId}',
    }).then((res) async {
      var convertedData = convert.jsonDecode(res.body);
      if (!convertedData['error']) {
        List data = convertedData['data'];
        print(data);
        if (data.isNotEmpty) {
          setState(() {
            _listEvents =
                data.map((data) => EventModel.fromJson(data)).toList();
            isfetched = false;
          });
          // print(data);
        } else {
          print("empty response");
          setState(() {
            isfetched = false;
            isEmpty = true;
          });
        }
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

  ScrollController _mycontroller1 = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: _buildHeader(context),
      body: isfetching
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Getting Profile Info"),
              ],
            ))
          : Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Carousel(imgList: imgurls,profile: profileDetails),
                    ProfileDetailContainer(
                        postOwnerId: widget.postOwnerId,
                        profile: profileDetails),
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
                            ? _listPosts.isNotEmpty
                                ? ListView.builder(
                                    controller: _mycontroller1,
                                    shrinkWrap: true,
                                    itemCount: _listPosts.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      PostModel _post = _listPosts[index];

                                      return PostsPageItem(
                                        _post,
                                        _userModel.id,
                                        _userModel.name,
                                        _userModel.img,
                                        _userModel.imagesource,
                                        _userModel.fb_url,
                                        isFromCommentPage: false,
                                      );
                                    },
                                  )
                                : Noresponse()
                            : _listEvents.isNotEmpty
                                ? ListView.builder(
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
                                  )
                                : Noresponse(),
                  ],
                ),
                // BottomBarWithFloatingBtn(),
              ],
            ),
      bottomNavigationBar: BottomBar(
        selected: 'none',
      ),
    );
  }
}

class Carousel extends StatefulWidget {
  const Carousel({
    Key key,
    @required this.imgList,
    @required this.profile,
  }) : super(key: key);

  final List<String> imgList;
  final profile;

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
              return InkWell(
                onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => FullScreenImg(
                                       widget.profile[0].imagesource == 'fb'
                                ? "${widget.profile[0].fb_url}"
                                : "${Constants.USERS_PROFILES_URL}" +
                                    "${widget.profile[0].img}")));
                        },
                              child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: 1000.0,
                    ),
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

class ProfileDetailContainer extends StatefulWidget {
  final postOwnerId;
  final profile;
  ProfileDetailContainer({this.postOwnerId, this.profile});
  @override
  _ProfileDetailContainerState createState() => _ProfileDetailContainerState();
}

class _ProfileDetailContainerState extends State<ProfileDetailContainer> {
  Map _userData;
  String _errorMsg;
  int length = 0;
  double compatibility = 0.0;
  UserModel userModel;
  ScrollController _scrollController;
  String country = "";
  String city = "";
  bool isMessageCLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    _getTokenAndInitInsta();
    cityAndCountry();
    super.initState();
  }

  Future<void> _getTokenAndInitInsta() async {
    try {
      var response = await http.post(
        '${Constants.SERVER_URL}instaAuth/getInstaToken',
        body: {'user_id': widget.postOwnerId},
      );
      var jsonResponse = await convert.jsonDecode(response.body);

      if (response.statusCode == 500) {
        print("isssss ${jsonResponse['data']}");
      } else if (response.statusCode == 200) {
        print("isssss ${jsonResponse['user_token']}");

        var igUserResponse =
            await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
          '/me/media',
          queryParameters: {
            // Get the fields you need.
            // https://developers.facebook.com/docs/instagram-basic-display-api/reference/user
            "fields": "id,caption,media_url",
            "access_token": "${jsonResponse['user_token']}",
          },
        );
        setState(() {
          _userData = igUserResponse.data;
          if (_userData['data'].length > 24) {
            length = 24;
          } else {
            length = _userData['data'].length;
          }
          _errorMsg = null;
        });
        print("userdata length is ${_userData['data'].length}");
      } else {
        print("something went wropng");
      }
    } catch (e) {
      print(e);
    }
  }

  getAge(bday) {
    final birthday = DateTime.parse(bday);
    final dtnow = DateTime.now();
    final difference = dtnow.difference(birthday).inDays;
    final age = difference / 365;
    return age.toStringAsFixed(0);
  }

  cityAndCountry() async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        widget.profile[0].longitute, widget.profile[0].latitude);
    Placemark place = placemark[0];
    print(" City is " + place.locality);
    print(" COuntry is " + place.country);
    setState(() {
      city = place.locality;
      country = place.country;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
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
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => FullScreenImg(widget
                                                .profile[0].imagesource ==
                                            'fb'
                                        ? "${widget.profile[0].fb_url}"
                                        : "${Constants.USERS_PROFILES_URL}" +
                                            "${widget.profile[0].img}")));
                          },
                          child: CircleUser(
                            size: 80,
                            url: widget.profile[0].imagesource == 'fb'
                                ? "${widget.profile[0].fb_url}"
                                : "${Constants.USERS_PROFILES_URL}" +
                                    "${widget.profile[0].img}",
                            withBorder: true,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 20),
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
                              "${widget.profile[0].userName}, ${getAge(widget.profile[0].bday)}",
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
                            "$city,$country",
                            style: TextStyle(
                              fontSize: 15,
                              // color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                    ],
                  )
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              ProfileFollowersPage(widget.profile[0].id)));
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
                          "${widget.profile[0].followercount}",
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
                        "${widget.profile[0].followercount}",
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
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
                      if (widget.profile[0].isUserFollowed) {
                        String _url =
                            '${Constants.SERVER_URL}conversions/create';

                        http.post(_url, body: {
                          'lastMessage': 'hi i am using folk',
                          'user_one': userModel.id,
                          'user_two': widget.profile[0].id
                        }).then((res) async {
                          var data = convert.jsonDecode(res.body);
                          if (!data['error']) {
                            String chatId = data['data']['_id'];
                            String peerId = widget.profile[0].id;
                            String peerImg = widget.profile[0].img;
                            String peerName = widget.profile[0].userName;
                            String peerToken = widget.profile[0].token;
                            String myId = userModel.id;

                            setState(() {
                              isMessageCLiked = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MessagesPage(
                                        chatId,
                                        peerId,
                                        peerToken,
                                        myId,
                                        true,
                                        peerImg,
                                        true,
                                        peerName,
                                        widget.profile[0])));
                          }
                        });
                      } else {
                        print("${userModel.name}");
                        Fluttertoast.showToast(
                            msg: widget.profile[0].isUserRequested
                                ? 'You have to Wait for ${widget.profile[0].userName} to accept the req'
                                : 'You have to follow ${widget.profile[0].userName} first');
                      }
                    },
                    child: RoundedBorderButton(
                      "MESSAGE",
                      color1: Colors.grey[100],
                      color2: Colors.grey[100],
                      width: MediaQuery.of(context).size.width * .35,
                    ),
                  ),
            widget.profile[0].isUserFollowed
                ? GestureDetector(
                    onTap: () {
                      startUnfollowUser();
                    },
                    child: RoundedBorderButton(
                      "UNFOLLOW",
                      color1: Color.fromRGBO(255, 94, 58, 1),
                      color2: Color.fromRGBO(255, 149, 0, 1),
                      textColor: Colors.white,
                      width: MediaQuery.of(context).size.width * .35,
                    ),
                  )
                : !widget.profile[0].isUserRequested
                    ? GestureDetector(
                        onTap: () {
                          startFollowUser();
                        },
                        child: RoundedBorderButton(
                          "FOLLOW",
                          color1: Color.fromRGBO(255, 94, 58, 1),
                          color2: Color.fromRGBO(255, 149, 0, 1),
                          textColor: Colors.white,
                          width: MediaQuery.of(context).size.width * .35,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          cancelFollowReq();
                          print(widget.profile[0].isUserFollowed);
                        },
                        child: RoundedBorderButton(
                          "CANCEL REQUEST",
                          color1: Color.fromRGBO(255, 94, 58, 1),
                          color2: Color.fromRGBO(255, 149, 0, 1),
                          textColor: Colors.white,
                          width: MediaQuery.of(context).size.width * .35,
                        ),
                      ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "About me",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              ReadMoreText(
                "${widget.profile[0].bio}",
                expandingButtonColor: Colors.deepOrange,
              ),
              _userData != null
                  ? Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          "Recent Instagram Photos",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        _userData != null
            ? Visibility(
                visible: _userData != null,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    controller: _scrollController,
                    itemCount: length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => FullScreenImg("${_userData['data'][index]['media_url']}")));
                        },
                                              child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      "${_userData['data'][index]['media_url']}",
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      );
                    }),
                replacement:
                    Text("Click the button below to get Instagram Login."),
              )
            : Container(),
        Divider(),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Interrested in",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Text(
                          "${widget.profile[0].userInterests[index].interestname} - ...",
                          style: TextStyle(
                            color: returnsColor(index)
                                ? Colors.deepOrange
                                : Colors.black,
                          ),
                        );
                      },
                      itemCount: widget.profile[0].userInterests.length,
                    ),
                  ),
                ],
              ),
              CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 5.0,
                animation: true,
                animationDuration: 1000,
                percent: 0.1,
                center: new Text(
                  "50%",
                  // "${(compatibility*100).toStringAsFixed(0)}%",
                  style: new TextStyle(
                    fontSize: 12.0,
                    color: Colors.deepOrange,
                  ),
                ),
                footer: new Text(
                  "Compatibility",
                  style: new TextStyle(fontSize: 12.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.deepOrange,
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  bool returnsColor(index) {
    int counter = 0;

    if (userModel.userInterests.any((element) =>
        element.interestname ==
        widget.profile[0].userInterests[index].interestname)) {
      // print("cat isssssssssssssssssssssssssssssssss ${widget._postModel.postCats[i].catName}");
      compatibility = compatibility + 0.1;
      return true; //common interest
    } else {
      return false; //not common interest
    }
  }

  void startFollowUser() async {
    try {
      if (!widget.profile[0].isUserRequested) {
        setState(() {
          widget.profile[0].isUserRequested = true;
        });
        var req =
            await http.post('${Constants.SERVER_URL}user/followrequest', body: {
          'user_id': '${userModel.id}',
          'peer_id': '${widget.profile[0].id}',
          'user_name': '${userModel.name}'
        });

        print("ssssssssssssssssss ${userModel.name}");
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          Fluttertoast.showToast(
              msg: 'You requested follow ${widget.profile[0].userName}');
          print("follow user success ---${widget.profile[0].isUserRequested}");
        }
      }
    } catch (err) {} finally {}
  }

  void startUnfollowUser() async {
    try {
      if (widget.profile[0].isUserFollowed) {
        setState(() {
          widget.profile[0].isUserFollowed = false;
          widget.profile[0].followercount--;
        });
        var req = await http.post('${Constants.SERVER_URL}user/unfollowuser',
            body: {
              'user_id': '${userModel.id}',
              'peer_id': '${widget.profile[0].id}'
            });
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          Fluttertoast.showToast(
              msg: 'You Unfollowed ${widget.profile[0].userName}');
          print("Unfollow user success ---${widget.profile[0].isUserFollowed}");
        }
      }
    } catch (err) {} finally {}
  }

  void cancelFollowReq() async {
    try {
      if (widget.profile[0].isUserRequested) {
        setState(() {
          widget.profile[0].isUserRequested = false;
        });
        var req = await http
            .post('${Constants.SERVER_URL}user/cancelfollowrequest', body: {
          'user_id': '${userModel.id}',
          'peer_id': '${widget.profile[0].id}'
        });
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          Fluttertoast.showToast(msg: 'You cancelled follow Reuqest!');
          print("cancel req success ---${widget.profile[0].isUserRequested}");
        }
      }
    } catch (err) {} finally {}
  }
}
