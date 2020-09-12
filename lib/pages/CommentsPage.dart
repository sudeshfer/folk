//created by Suthura



import 'dart:async';
import 'dart:io';


import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/CommentsModel.dart';
import 'package:folk/models/PostModel.dart';
import 'package:folk/models/UserModel.dart';

import 'package:folk/providers/AuthProvider.dart';
import 'package:http/http.dart' as http;
import 'package:folk/providers/PostProvider.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'dart:convert' as convert;

import 'package:folk/utils/Constants.dart';
import 'package:folk/widgets/CommentItem.dart';
import 'package:folk/widgets/PostsPageItem.dart';

// ignore: must_be_immutable
class CommentsPage extends StatefulWidget {
  // if come from any screen except Notification click so don't make new request to get data
  PostModel _postModel;
  bool isFromHomePage = false;

  CommentsPage(this._postModel,{this.isFromHomePage=false});

  @override
  _CommentsPageState createState() => _CommentsPageState(_postModel);
}

class _CommentsPageState extends State<CommentsPage> {
  PostModel _postModel;
  UserModel _myModel;
  // if come from Notification click so make new request to get data
  PostModel postData;
  final double minValue = 8.0;
  AdmobInterstitial interstitialAd;
  _CommentsPageState(this._postModel);

  ScrollController _scrollController;
  final double iconSize = 28.0;
  FocusNode _focusNode = FocusNode();
  TextEditingController _txtController = TextEditingController();
  List<CommentsModel> _listComments = [];


  @override
  void initState() {
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
    _txtController.dispose();

  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.getThemeData.backgroundColor,
      appBar: AppBar(
        title: Text(
          'comments',
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: postData == null
          ? Container()
          : Column(
              children: <Widget>[
                Expanded(

                  child: ListView(
                    shrinkWrap: true,
                    controller: _scrollController,
                    children: <Widget>[
                      PostsPageItem(
                          widget.isFromHomePage?_postModel:postData, _myModel.id, _myModel.name, _myModel.img,_myModel.imagesource,_myModel.fb_url,isFromHomePage: widget.isFromHomePage, ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          var comment = _listComments[i];
                          return InkWell(
                              onLongPress: () {
                                if (comment.userId == _myModel.id || _myModel.email == Constants.ADMIN_EMAIL) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: InkWell(
                                              onTap: () {
                                                startDeleteComment(comment, i);
                                              },
                                              child: Text('delete comment')),
                                        );
                                      });
                                }
                              },
                              child: CommentItem(comment));
                        },
                        itemCount: _listComments.length,
                      ),
                    ],
                  ),
                ),
                Container(

                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildBottomSection(themeProvider),
                  ),
                ),
              ],
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

  _buildBottomSection(themeProvider) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 52,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: themeProvider.getThemeData.dividerColor,
                borderRadius: BorderRadius.all(Radius.circular(8.0 * 4))),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    maxLines: null,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.multiline,
                    controller: _txtController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type your comment"),
                    autofocus: false,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: minValue, top: 5, bottom: 5),
          child: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              if(_txtController.text.isEmpty){
               Fluttertoast.showToast(msg: 'cant send empty comment');
              }else{
                startAddComment();
              }

            },
            child: Icon(
              Icons.send,
              color: Colors.black,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  void startAddComment() async {
    String comment = '${_txtController.text}';
    String postId = _postModel.id;
    String userName = _myModel.name;
    String userId = _myModel.id;
    String userImg = _myModel.img;
    String postOwnerId = _postModel.postOwnerId;

    _txtController.clear();
    try {
      var req = await http.post('${Constants.SERVER_URL}comment/create', body: {
        'comment': comment,
        'post_id': postId,
        'user_name': userName,
        'user_id': userId,
        'user_img': userImg,
        'post_owner_id': postOwnerId,
      });

      var res = convert.jsonDecode(req.body);
      if (!res['error']) {
        setState(() {
          _listComments.add(CommentsModel(
              id: res['data']['_id'],
              comment: comment,
              postId: postId,
              userName: userName,
              userId: userId,
              userImg: userImg,
              postOwnerId: postOwnerId));
        });

        Provider.of<PostProvider>(context, listen: false)
            .startGetPostsData(_myModel.id);
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent + _listComments.length * 100,
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


  }

  void getComments() async {
    var req = await http.post('${Constants.SERVER_URL}comment/fetch_all',
        body: {'post_id': _postModel.id});
    var res = convert.jsonDecode(req.body);
    if (!res['error']) {
      var listComments = res['data'];
      List<CommentsModel> _temp = [];
      for (int i = 0; i < listComments.length; i++) {
        _temp.add(CommentsModel(
            comment: listComments[i]['comment'],
            id: listComments[i]['_id'],
            postId: listComments[i]['post_id'],
            userName: listComments[i]['user_name'],
            userId: listComments[i]['user_id'],
            userImg: listComments[i]['user_img'],
            postOwnerId: listComments[i]['post_owner_id']));
      }
      setState(() {
        _listComments = _temp;
        _temp = null;
      });
     Future.delayed(Duration(seconds: 1),(){
       _scrollController.animateTo(
         _scrollController.position.minScrollExtent + _listComments.length * 100,
         curve: Curves.easeOut,
         duration: const Duration(milliseconds: 300),
       );
     });
    } else {}

    interstitialAd.show();
  }

  void getPostData() async {
    try{
      var req = await http.post('${Constants.SERVER_URL}post/getPostById',
          body: {'post_id': _postModel.id, 'peer_id': _postModel.postOwnerId});

      var res = convert.jsonDecode(req.body);

      if (!res['error']) {
        setState(() {
          postData = PostModel.fromJson(res['data']);
        });
      }else{
        print('deleted !');
      }
    }catch(err){
      print('error !');
    }

  }
}
