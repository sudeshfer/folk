import 'package:flutter/material.dart';
import 'package:folk/utils/HelperWidgets/noCommentsMsg.dart';
import 'package:folk/utils/HelperWidgets/noResponse_msg.dart';
import 'package:folk/widgets/postLikesWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/models/PostModel.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:folk/providers/PostProvider.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/models/CommentsModel.dart';
// import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'dart:io';
import 'package:folk/utils/Constants.dart';
import 'package:folk/widgets/PostsPageItem.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:folk/models/SubCommentModel.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostSection extends StatefulWidget {
  PostModel _postModel;
  bool isFromHomePage = false;
  PostSection(this._postModel, {this.isFromHomePage = false});

  @override
  _PostSectionState createState() => _PostSectionState(_postModel);
}

UserModel _userModel;
List<CommentsModel> _listComments = [];
List<SubCommentsModel> _listSubComments = [];
ScrollController _scrollController;
bool isReplyClicked = false;
String comId = "";

class _PostSectionState extends State<PostSection> {
  // GlobalKey<ScaffoldState> _key;
  PostModel _postModel;
  UserModel _myModel;
  // if come from Notification click so make new request to get data
  PostModel postData;
  final double minValue = 8.0;
  AdmobInterstitial interstitialAd;
  _PostSectionState(this._postModel);

  bool liked = false;
  bool isSubliked = false;
  int noOfLikes;
  int noOfSubComLikes;
  bool debug = false;

  final double iconSize = 28.0;

  TextEditingController _txtController = TextEditingController();
  bool isSendBtn = false;
  FocusNode myFocusNode;

  bool isfetched = true;
  bool isEmpty = false;
  int subcomLength = 0;

  @override
  void initState() {
    _listComments.clear();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    interstitialAd.load();

    _scrollController = ScrollController();
    _myModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    super.initState();
    getPostData();
    getComments();

    myFocusNode = FocusNode();
  }

  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return Constants.InterstitialAdUnitIdIOS;
    } else if (Platform.isAndroid) {
      return Constants.InterstitialAdUnitIdAndroid;
    }
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myFocusNode.dispose();
    _txtController.dispose();
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

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: new Text("${_postModel.userName}'s Post"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);

            //  print(_postModel.id);
            //  print(_userModel.id);
          },
        ),
        actions: <Widget>[
          IconButton(icon: FaIcon(FontAwesomeIcons.ellipsisH), onPressed: () {})
        ],
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        textTheme: TextTheme(
            title: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        )),
        centerTitle: true,
        elevation: 0.0,
      ),
      // key: _key,
      body: GestureDetector(
        onTap: () {
          myFocusNode.unfocus();
          setState(() {
            isReplyClicked = false;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
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
              // color: Colors.white,
              child: Expanded(
                child: SingleChildScrollView(
                  child: PostsPageItem(
                    _postModel,
                    _userModel.id,
                    _userModel.name,
                    _userModel.img,
                    _userModel.imagesource,
                    _userModel.fb_url,
                    isFromCommentPage: true,
                  ),
                ),
              ),
            ),
            // CommentSection(width),
             Padding(
                                  padding: const EdgeInsets.only(left:15.0,bottom: 10),
                                  child: PostLikesWIdget(_postModel.id, _userModel.id),
                                ),
            Expanded(
                child: isfetched
                    ? CardListSkeleton(
                        style: SkeletonStyle(
                          theme: SkeletonTheme.Light,
                          isShowAvatar: true,
                          isCircleAvatar: true,
                          barCount: 3,
                        ),
                      )
                    : isEmpty
                        ? NoCommentsMsg()
                        : ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: _listComments.length,
                          itemBuilder: (context, i) {
                            var comment = _listComments[i];
                            // print("*>*>*>*>*>*>*>*>*>*>*>*");
                            // print(comment.bday);
                            // print("*>*>*>*>*>*>*>*>*>*>*>*");
                            var date;
                            date =
                                new DateTime.fromMillisecondsSinceEpoch(
                                    comment.timeStamp);
                            noOfLikes = comment.commentLikes;
                            liked = comment.isUserLiked;

                            return Padding(
                              padding:
                                  EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Container(
                                color: (debug)
                                    ? Colors.grey[200]
                                    : Colors.white,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        Container(
                                            alignment:
                                                Alignment.topCenter,
                                            color: (debug)
                                                ? Colors.green[100]
                                                : Colors.white,
                                            padding:
                                                const EdgeInsets.all(
                                                    5.0),
                                            child: CachedNetworkImage(
                                              imageUrl: comment
                                                          .imagesource ==
                                                      'userimage'
                                                  ? Constants
                                                          .USERS_PROFILES_URL +
                                                      comment.userImg
                                                  : comment.userImg,
                                              imageBuilder: (context,
                                                      imageProvider) =>
                                                  Container(
                                                width: 45.0,
                                                height: 45.0,
                                                decoration:
                                                    BoxDecoration(
                                                  shape:
                                                      BoxShape.circle,
                                                  image: DecorationImage(
                                                      image:
                                                          imageProvider,
                                                      fit:
                                                          BoxFit.cover),
                                                ),
                                              ),
                                              placeholder: (context,
                                                      url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget: (context,
                                                      url, error) =>
                                                  Icon(Icons.error),
                                            )),
                                        Expanded(
                                          child: GestureDetector(
                                            onLongPress: () {
                                              if (comment.userId ==
                                                      _userModel.id ||
                                                  _myModel.email ==
                                                      Constants
                                                          .ADMIN_EMAIL) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Delete ?"),
                                                        content:
                                                            Container(
                                                          constraints:
                                                              BoxConstraints(
                                                            maxHeight: MediaQuery.of(context)
                                                                    .size
                                                                    .height /
                                                                8,
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  "Are you sure you want to delete this comment ?"),
                                                              SizedBox(
                                                                height:
                                                                    MediaQuery.of(context).size.height /
                                                                        35,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  InkWell(
                                                                      onTap: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                      child: Text('No')),
                                                                  InkWell(
                                                                      onTap: () {
                                                                        startDeleteComment(comment, i);
                                                                      },
                                                                      child: Text('Yes')),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color:
                                                      Colors.grey[100],
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                              20)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: <Widget>[
                                                  Text(
                                                    '${comment.userName}' +
                                                        ', ' +
                                                        getAge(comment
                                                            .bday),
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Montserrat',
                                                      fontWeight:
                                                          FontWeight
                                                              .w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child:
                                                            Container(
                                                          child: Text(
                                                            "${comment.comment}",
                                                            style:
                                                                TextStyle(
                                                              fontSize:
                                                                  14,
                                                              fontFamily:
                                                                  'Montserrat',
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets
                                                        .fromLTRB(
                                                            0, 5, 0, 0),
                                                    child: Row(
                                                      children: <
                                                          Widget>[
                                                        Text(
                                                          '${timeAgo.format(date)}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  10,
                                                                  0,
                                                                  0,
                                                                  0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              if (isReplyClicked ==
                                                                  true) {
                                                                print(
                                                                    "unfocusssssssssss");
                                                                myFocusNode
                                                                    .unfocus();
                                                              }
                                                              print(
                                                                  "unfocussssssssssssssssssssssssssssssssssssssssssss");
                                                              myFocusNode
                                                                  .requestFocus();
                                                              setState(
                                                                  () {
                                                                isReplyClicked =
                                                                    true;
                                                                comId =
                                                                    comment.id;
                                                              });
                                                              print(
                                                                  comId);
                                                            },
                                                            child: Text(
                                                              "Reply",
                                                              style:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .grey,
                                                                fontWeight:
                                                                    FontWeight.w700,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets
                                                  .fromLTRB(5, 0, 5, 0),
                                              child: Text(
                                                  noOfLikes.toString()),
                                            ),
                                            _listComments[i].isUserLiked
                                                ? GestureDetector(
                                                    onTap: () {
                                                      if (comment
                                                              .userId ==
                                                          _userModel
                                                              .id) {
                                                        Fluttertoast
                                                            .showToast(
                                                                msg:
                                                                    'can\'t like your own comment ');
                                                      } else {
                                                        print(
                                                            "comment like issssssssssssssssssssssssssssss $liked");
                                                        startAddLike(
                                                            comment.id,
                                                            comment
                                                                .userId,
                                                            i);
                                                      }
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/LikePressed.png',
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      if (comment
                                                              .userId ==
                                                          _userModel
                                                              .id) {
                                                        Fluttertoast
                                                            .showToast(
                                                                msg:
                                                                    'can\'t like your own comment ');
                                                      } else {
                                                        print(
                                                            "comment like issssssssssssssssssssssssssssss $liked");
                                                        startAddLike(
                                                            comment.id,
                                                            comment
                                                                .userId,
                                                            i);
                                                      }
                                                    },
                                                    child:
                                                        new Image.asset(
                                                      'assets/images/ic_wishlist.png',
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ],
                                    ),
                                    comment.subcomments.isEmpty
                                        ? Container()
                                        : ListView.builder(
                                            controller:
                                                _scrollController,
                                            shrinkWrap: true,
                                            itemCount: comment
                                                .subcomments.length,
                                            itemBuilder: (context, i2) {
                                              var subComment = comment
                                                  .subcomments[i2];
                                              var subComdate = new DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                  subComment.timeStamp);
                                              noOfSubComLikes =
                                                  subComment
                                                      .commentLikes;
                                              isSubliked = subComment
                                                  .isUserLiked;
                                              // final timeStamp = comment.subcomments[i2].timeStamp;

                                              return Padding(
                                                padding:
                                                    EdgeInsets.fromLTRB(
                                                        60, 10, 0, 0),
                                                child: Container(
                                                  color: (debug)
                                                      ? Colors.grey[200]
                                                      : Colors.white,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                          alignment:
                                                              Alignment
                                                                  .topCenter,
                                                          color: (debug)
                                                              ? Colors.green[
                                                                  100]
                                                              : Colors
                                                                  .white,
                                                          padding:
                                                              const EdgeInsets
                                                                      .all(
                                                                  5.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: subComment.imagesource ==
                                                                    'userimage'
                                                                ? Constants.USERS_PROFILES_URL +
                                                                    subComment
                                                                        .userImg
                                                                : subComment
                                                                    .userImg,
                                                            imageBuilder:
                                                                (context,
                                                                        imageProvider) =>
                                                                    Container(
                                                              width:
                                                                  45.0,
                                                              height:
                                                                  45.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit:
                                                                        BoxFit.cover),
                                                              ),
                                                            ),
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    CircularProgressIndicator(),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                Icon(Icons
                                                                    .error),
                                                          )),
                                                      Expanded(
                                                        child:
                                                            GestureDetector(
                                                          onLongPress:
                                                              () {
                                                            if (subComment.userId ==
                                                                    _userModel
                                                                        .id ||
                                                                _myModel.email ==
                                                                    Constants.ADMIN_EMAIL) {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title: Text("Delete ?"),
                                                                      content: Container(
                                                                        constraints: BoxConstraints(
                                                                          maxHeight: MediaQuery.of(context).size.height / 8,
                                                                        ),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Text("Are you sure you want to delete this comment ?"),
                                                                            SizedBox(
                                                                              height: MediaQuery.of(context).size.height / 35,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: Text('No')),
                                                                                InkWell(
                                                                                    onTap: () {
                                                                                      startDeleteSubComment(subComment, i, i2);
                                                                                    },
                                                                                    child: Text('Yes')),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            }
                                                          },
                                                          child:
                                                              Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            decoration: BoxDecoration(
                                                                color: Colors.grey[
                                                                    100],
                                                                borderRadius:
                                                                    BorderRadius.circular(20)),
                                                            child:
                                                                Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "${subComment.userName}" +
                                                                      ', ' +
                                                                      getAge(subComment.bday),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Montserrat',
                                                                    fontWeight:
                                                                        FontWeight.w600,
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child: Container(
                                                                        child: Text(
                                                                          "${subComment.comment}",
                                                                          style: TextStyle(
                                                                            fontSize: 14,
                                                                            fontFamily: 'Montserrat',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets.fromLTRB(
                                                                      0,
                                                                      5,
                                                                      0,
                                                                      0),
                                                                  child:
                                                                      Row(
                                                                    children: <Widget>[
                                                                      Text(
                                                                        '${timeAgo.format(subComdate)}',
                                                                        style: TextStyle(color: Colors.grey),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                                        child: GestureDetector(
                                                                          onTap: () {
                                                                            if (isReplyClicked == true) {
                                                                              print("unfocusssssssssss");
                                                                              myFocusNode.unfocus();
                                                                            }

                                                                            myFocusNode.requestFocus();
                                                                            setState(() {
                                                                              isReplyClicked = true;
                                                                              comId = comment.id;
                                                                            });
                                                                            print(comId);
                                                                          },
                                                                          child: Text(
                                                                            "Reply",
                                                                            style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: <
                                                            Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.fromLTRB(
                                                                    5,
                                                                    0,
                                                                    5,
                                                                    0),
                                                            child: Text(
                                                                noOfSubComLikes
                                                                    .toString()),
                                                          ),
                                                          subComment
                                                                  .isUserLiked
                                                              ? GestureDetector(
                                                                  onTap:
                                                                      () {
                                                                    if (subComment.userId ==
                                                                        _userModel.id) {
                                                                      Fluttertoast.showToast(msg: 'can\'t like your own comment ');
                                                                    } else {
                                                                      startAddSubComLike(subComment.id, subComment.userId, i, i2);
                                                                      print(subComment.id);
                                                                      print(subComment.isUserLiked);
                                                                    }
                                                                  },
                                                                  child:
                                                                      Image.asset(
                                                                    'assets/images/LikePressed.png',
                                                                    width:
                                                                        20,
                                                                    height:
                                                                        20,
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap:
                                                                      () {
                                                                    if (subComment.userId ==
                                                                        _userModel.id) {
                                                                      Fluttertoast.showToast(msg: 'can\'t like your own comment ');
                                                                    } else {
                                                                      startAddSubComLike(subComment.id, subComment.userId, i, i2);
                                                                    }
                                                                  },
                                                                  child:
                                                                      new Image.asset(
                                                                    'assets/images/ic_wishlist.png',
                                                                    width:
                                                                        20,
                                                                    height:
                                                                        20,
                                                                  ),
                                                                )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                              // SubComment(
                                              //   user:
                                              //       "${subComment.userName}",
                                              //   msg: "${subComment.comment}",
                                              //   debug: false,
                                              //   noOfLikes:
                                              //       subComment.commentLikes,
                                              //   pic: comment.userImg,
                                              //   imagesource:
                                              //       comment.imagesource,
                                              //   timeStamp: timeStamp,
                                              //   comment: comment,
                                              //   myfocus: myFocusNode,
                                              // );
                                            })
                                    // comment.subcomments.isNotEmpty? Text(comment.subcomments[0].comment):Container()
                                  ],
                                ),
                              ),
                            );
                          },
                        )),
            Divider(
              color: Colors.grey[300],
              thickness: 2,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    focusNode: myFocusNode,
                    controller: _txtController,
                    minLines: 1,
                    maxLines: 3,
                    onTap: () {
                      if (isReplyClicked == true) {
                        setState(() {
                          isReplyClicked = false;
                        });
                      }
                    },
                    onChanged: (value) {
                      if (value != "") {
                        setState(() {
                          isSendBtn = true;
                        });
                      } else {
                        myFocusNode.unfocus();
                        setState(() {
                          isSendBtn = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        hintStyle: new TextStyle(
                            color: Colors.grey[800], fontFamily: 'Montserrat'),
                        hintText: "Write a message",
                        fillColor: Colors.white70),
                  ),
                ),
                isSendBtn
                    ? GestureDetector(
                        onTap: () {
                          // startAddComment();

                          print(
                              "reply clicked is ssssssssssssssssssssssssssssss $isReplyClicked");
                          if (isReplyClicked != true) {
                            print("normal comment ");
                            myFocusNode.unfocus();
                            startAddComment();
                          } else {
                            print("sub comment ");
                            myFocusNode.unfocus();
                            startAddSubComment();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                            alignment: Alignment.centerRight,
                            height: 30,
                            image: AssetImage(
                              "assets/images/ic_send.png",
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          alignment: Alignment.centerRight,
                          height: 30,
                          image: AssetImage(
                            "assets/images/send.png",
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void startDeleteComment(CommentsModel commentsModel, int index) async {
    await http.post('${Constants.SERVER_URL}comment/delete',
        body: {'comment_id': '${commentsModel.id}', 'post_id': _postModel.id});
    Navigator.of(context).pop();
    setState(() {
      _listComments.removeAt(index);
    });
    Provider.of<PostProvider>(context, listen: false)
        .startGetPostsData(_myModel.id);
  }

  void startDeleteSubComment(
      SubCommentsModel subommentsModel, int index, int index2) async {
    await http.post('${Constants.SERVER_URL}comment/deletesub', body: {
      'comment_id': '${subommentsModel.id}',
      'post_id': _postModel.id
    });
    Navigator.of(context).pop();
    setState(() {
      _listComments[index].subcomments.removeAt(index2);
    });
    Provider.of<PostProvider>(context, listen: false)
        .startGetPostsData(_myModel.id);
  }

  void startAddLike(String commentId, String userId, int index) async {
    String userImg =
        (_myModel.imagesource == 'userimage') ? _myModel.img : _myModel.fb_url;
    String imagesource = _myModel.imagesource;
    try {
      if (!_listComments[index].isUserLiked) {
        var req =
            await http.post('${Constants.SERVER_URL}like/commentlike', body: {
          'user_id': '${_userModel.id}',
          'user_img': userImg,
          'imagesource': imagesource,
          'user_name': '${_userModel.name}',
          'comment_id': '$commentId',
          'peer_id': '$userId'
        });
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          setState(() {
            _listComments[index].isUserLiked = true;
            liked = true;
            ++_listComments[index].commentLikes;
          });
          print("comment like issssssssssssssssssssssssssssss $liked");
        } else {
          print(res['data']);
        }
      } else {
        var req = await http.post('${Constants.SERVER_URL}like/commentunlike',
            body: {'user_id': '${_userModel.id}', 'comment_id': '$commentId'});
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          setState(() {
            _listComments[index].isUserLiked = false;
            liked = false;
            --_listComments[index].commentLikes;
          });
        } else {
          print(res['data']);
        }
      }
    } catch (err) {} finally {}
  }

  void startAddSubComLike(
      String subCommentId, String userId, int index, int index2) async {
    String userImg =
        (_myModel.imagesource == 'userimage') ? _myModel.img : _myModel.fb_url;
    String imagesource = _myModel.imagesource;
    try {
      if (!_listComments[index].subcomments[index2].isUserLiked) {
        var req = await http
            .post('${Constants.SERVER_URL}like/subcommentlike', body: {
          'user_id': '${_userModel.id}',
          'user_img': userImg,
          'imagesource': imagesource,
          'user_name': '${_userModel.name}',
          'comment_id': '$subCommentId',
          'peer_id': '$userId'
        });
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          setState(() {
            _listComments[index].subcomments[index2].isUserLiked = true;
            isSubliked = true;
            ++_listComments[index].subcomments[index2].commentLikes;
          });
          print("comment like issssssssssssssssssssssssssssss $liked");
        } else {
          print(res['data']);
        }
      } else {
        print('ssssssssssssss $subCommentId');
        var req = await http
            .post('${Constants.SERVER_URL}like/subcommentunlike', body: {
          'user_id': '${_userModel.id}',
          'comment_id': '$subCommentId'
        });
        var res = convert.jsonDecode(req.body);

        if (!res['error']) {
          print("response isssssss  ${res['error']}");
          setState(() {
            _listComments[index].subcomments[index2].isUserLiked = false;
            isSubliked = false;
            --_listComments[index].subcomments[index2].commentLikes;
          });
        } else {
          print(res['data']);
        }
      }
    } catch (err) {} finally {}
  }

  void startAddComment() async {
    if (_txtController.text.isNotEmpty) {
      String comment = '${_txtController.text}';
      String postId = _postModel.id;
      String userName = _myModel.name;
      String userId = _myModel.id;
      String userImg = (_myModel.imagesource == 'userimage')
          ? _myModel.img
          : _myModel.fb_url;
      String imagesource = _myModel.imagesource;
      String postOwnerId = _postModel.postOwnerId;
      // bool isUserLiked = _postModel.isUserLiked;
      // int commentLikes = _postModel.commentsCount;

      _txtController.clear();
      try {
        var req =
            await http.post('${Constants.SERVER_URL}comment/create', body: {
          'comment': comment,
          'post_id': postId,
          'user_name': userName,
          'user_id': userId,
          'user_img': userImg,
          'imagesource': imagesource,
          'post_owner_id': postOwnerId,
          'bday': _myModel.bday
        });

        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          print(res['data']['_id']);
          print(comment);
          print(postId);
          print(userName);
          print(userId);
          print(userImg);
          print(postOwnerId);
          print(DateTime.now().millisecondsSinceEpoch.toString());
          setState(() {
            _listComments.add(CommentsModel(
                id: res['data']['_id'],
                comment: comment,
                postId: postId,
                userName: userName,
                userId: userId,
                userImg: userImg,
                imagesource: imagesource,
                postOwnerId: postOwnerId,
                timeStamp: DateTime.now().millisecondsSinceEpoch,
                isUserLiked: false,
                commentLikes: 0,
                bday: _myModel.bday,
                subcomments: []));

            isEmpty = false;
          });

          Provider.of<PostProvider>(context, listen: false)
              .startGetPostsData(_myModel.id);
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent +
                (_listComments.length + subcomLength) * 100,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
          // Navigator.pop(context);
          //  Navigator.of(context).push(MaterialPageRoute(
          //                 builder: (_) => PostSection(
          //                       widget._postModel,
          //                       isFromHomePage: true,
          //                     )));
        } else {
          Fluttertoast.showToast(
              msg: 'error ${res['error']}', toastLength: Toast.LENGTH_LONG);
        }
      } catch (err) {
        print(err);
      }
    } else {
      print("controller is empty");
    }
  }

  void startAddSubComment() async {
    if (_txtController.text.isNotEmpty) {
      String comment = '${_txtController.text}';
      String postId = _postModel.id;
      String userName = _myModel.name;
      String userId = _myModel.id;
      String userImg = (_myModel.imagesource == 'userimage')
          ? _myModel.img
          : _myModel.fb_url;
      String imagesource = _myModel.imagesource;
      String postOwnerId = _postModel.postOwnerId;
      // bool isUserLiked = _postModel.isUserLiked;
      // int commentLikes = _postModel.commentsCount;
      print("comment id issssssssssssssssssssssssssss $comId");

      _txtController.clear();
      try {
        var req =
            await http.post('${Constants.SERVER_URL}comment/createsub', body: {
          'comment': comment,
          'post_id': postId,
          'comment_id': comId,
          'user_name': userName,
          'user_id': userId,
          'user_img': userImg,
          'imagesource': imagesource,
          'post_owner_id': postOwnerId,
          'bday': _myModel.bday
        });

        var res = convert.jsonDecode(req.body);
        int comlength = 0;
        int normalComlength = 0;
        List _temp = [];
        List _temp2 = [];

        if (!res['error']) {
          print(comId);
          print(comment);
          print(postId);
          print(userName);
          print(userId);
          print(userImg);
          print(postOwnerId);
          print(DateTime.now().millisecondsSinceEpoch.toString());

          for (var i = 0; i < _listComments.length; i++) {
            if (_listComments[i].id != comId) {
              _temp.add(_listComments[i].id);
            } else {
              setState(() {
                _listComments[i].subcomments.add(SubCommentsModel(
                    id: res['data']['_id'],
                    comment: res['data']['comment'],
                    userName: res['data']['user_name'],
                    userId: res['data']['user_id'],
                    userImg: res['data']['user_img'],
                    postOwnerId: postOwnerId,
                    timeStamp: res['data']['created'],
                    isUserLiked: res['data']['isUserLiked'],
                    commentLikes: res['data']['likes'],
                    bday: _myModel.bday));

                comlength = _temp.length + _listComments[i].subcomments.length;
                print(
                    "com lengthe issssssssssssssssssssssssssssssssssssss $comlength");
              });
            }
          }

          Provider.of<PostProvider>(context, listen: false)
              .startGetPostsData(_myModel.id);
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent + (comlength - 2) * 100,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        } else {
          Fluttertoast.showToast(
              msg: 'error ${res['error']}', toastLength: Toast.LENGTH_LONG);
        }
      } catch (err) {
        print(err);
      }
    } else {
      print("controller is empty");
    }
  }

  void getComments() async {
    var req = await http.post('${Constants.SERVER_URL}comment/fetch_all',
        body: {'post_id': _postModel.id, 'user_id': _userModel.id});
    var res = convert.jsonDecode(req.body);
    if (!res['error']) {
      List listComments = res['data'];

      if (listComments.isNotEmpty) {
        List<CommentsModel> _temp = [];

        for (int i = 0; i < listComments.length; i++) {
          _temp.add(CommentsModel(
              comment: listComments[i]['comment'],
              id: listComments[i]['_id'],
              postId: listComments[i]['post_id'],
              userName: listComments[i]['user_name'],
              userId: listComments[i]['user_id'],
              userImg: listComments[i]['user_img'],
              imagesource: listComments[i]['imagesource'],
              bday: listComments[i]['bday'],
              postOwnerId: listComments[i]['post_owner_id'],
              timeStamp: listComments[i]['created'],
              commentLikes: listComments[i]['likes'],
              isUserLiked: listComments[i]['isUserLiked'],
              subcomments: (listComments[i]['subcoms'] as List)
                  ?.map((i) => SubCommentsModel.fromJson(i))
                  ?.toList()));
        }
        for (var i = 0; i < _temp.length; i++) {
          if (_temp[i].subcomments.length != 0) {
            subcomLength = subcomLength + _temp[i].subcomments.length;
          }
        }

        print(
            "subcom count isssssssssssssssssssssssssssssssssssssssss $subcomLength");
        setState(() {
          _listComments = _temp;
          isfetched = false;
          _temp = null;
          // print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
          // print(_listComments[0].subcomments);
          // print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        });

        Future.delayed(Duration(seconds: 1), () {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent +
                (_listComments.length + subcomLength) * 100,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        });
      }
    } else {
      print("empty response");
      setState(() {
        isfetched = false;
        isEmpty = true;
      });
    }

    interstitialAd.show();
  }

  void getPostData() async {
    try {
      var req = await http.post('${Constants.SERVER_URL}post/getPostById',
          body: {'post_id': _postModel.id, 'peer_id': _postModel.postOwnerId});

      var res = convert.jsonDecode(req.body);

      if (!res['error']) {
        setState(() {
          postData = PostModel.fromJson(res['data']);
        });
      } else {
        print('deleted !');
      }
    } catch (err) {
      print('error !');
    }
  }
}

// class SubComment extends StatefulWidget {
//   final String pic;
//   final String imagesource;
//   final String user;
//   final String msg;
//   final bool debug;
//   final int noOfLikes;
//   final timeStamp;
//   final comment;
//   final FocusNode myfocus;
//   SubComment(
//       {this.pic,
//       this.imagesource,
//       this.user,
//       this.msg,
//       this.debug,
//       this.noOfLikes,
//       this.timeStamp,
//       this.comment,
//       this.myfocus});

//   @override
//   _SubCommentState createState() => _SubCommentState(noOfLikes);
// }

// class _SubCommentState extends State<SubComment> {
//   bool liked = false;
//   int noOfLikes;
//   _SubCommentState(this.noOfLikes);

//   @override
//   Widget build(BuildContext context) {
//     var date;
//     date = new DateTime.fromMillisecondsSinceEpoch(widget.timeStamp);

//     return Padding(
//       padding: EdgeInsets.fromLTRB(60, 10, 0, 0),
//       child: Container(
//         color: (widget.debug) ? Colors.grey[200] : Colors.white,
//         child: Row(
//           children: <Widget>[
//             Container(
//                 alignment: Alignment.topCenter,
//                 color: (widget.debug) ? Colors.green[100] : Colors.white,
//                 padding: const EdgeInsets.all(5.0),
//                 child: CachedNetworkImage(
//                   imageUrl: widget.imagesource == 'userimage'
//                       ? Constants.USERS_PROFILES_URL + widget.pic
//                       : widget.pic,
//                   imageBuilder: (context, imageProvider) => Container(
//                     width: 45.0,
//                     height: 45.0,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       image: DecorationImage(
//                           image: imageProvider, fit: BoxFit.cover),
//                     ),
//                   ),
//                   placeholder: (context, url) => CircularProgressIndicator(),
//                   errorWidget: (context, url, error) => Icon(Icons.error),
//                 )),
//             Expanded(
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       widget.user,
//                       style: TextStyle(
//                         fontFamily: 'Montserrat',
//                         fontWeight: FontWeight.w600,
//                         fontSize: 13,
//                       ),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: Container(
//                             child: Text(
//                               widget.msg,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontFamily: 'Montserrat',
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
//                       child: Row(
//                         children: <Widget>[
//                           Text(
//                             '${timeAgo.format(date)}',
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
//                             child: GestureDetector(
//                               onTap: () {
//                                 if (isReplyClicked == true) {
//                                   print("unfocusssssssssss");
//                                   widget.myfocus.unfocus();
//                                 }
//                                 print(
//                                     "unfocussssssssssssssssssssssssssssssssssssssssssss");
//                                 widget.myfocus.requestFocus();
//                                 setState(() {
//                                   isReplyClicked = true;
//                                   comId = widget.comment.id;
//                                 });
//                                 print(comId);
//                               },
//                               child: Text(
//                                 "Reply",
//                                 style: TextStyle(
//                                   color: Colors.grey,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             Row(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//                   child: Text(noOfLikes.toString()),
//                 ),
//                 widget.comment.isUserLiked
//                     ? GestureDetector(
//                         onTap: () {
//                           if (widget.comment.userId == _userModel.id) {
//                             Fluttertoast.showToast(
//                                 msg: 'can\'t like your own comment ');
//                           } else {
//                             // startAddLike();
//                           }
//                         },
//                         child: Image.asset(
//                           'assets/images/LikePressed.png',
//                           width: 20,
//                           height: 20,
//                         ),
//                       )
//                     : GestureDetector(
//                         onTap: () {
//                           if (widget.comment.userId == _userModel.id) {
//                             Fluttertoast.showToast(
//                                 msg: 'can\'t like your own comment ');
//                           } else {
//                             // startAddLike();
//                           }
//                         },
//                         child: new Image.asset(
//                           'assets/images/ic_wishlist.png',
//                           width: 20,
//                           height: 20,
//                         ),
//                       )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
