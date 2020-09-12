//created by Suthura

import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:folk/models/PostModel.dart';
import 'package:folk/models/UserModel.dart';

import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/PostProvider.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:folk/widgets/PostsPageItem.dart';
import 'AddPost.dart';
import 'package:http/http.dart' as http;

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  AdmobBannerSize bannerSize;

  UserModel _userModel;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ScrollController _controller;

  @override
  void initState() {
    bannerSize = AdmobBannerSize.MEDIUM_RECTANGLE;

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<PostProvider>(context, listen: true).listPosts;
    Provider.of<ThemeProvider>(context);

    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 51,
                          height: 51,
                          margin: EdgeInsets.only(left: 5),
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: CachedNetworkImage(
                                  imageUrl: Constants.USERS_PROFILES_URL +
                                      _userModel.img,
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.brightness_1,
                                    color: Colors.green,
                                    size: 16,
                                  ))
                            ],
                          )),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => AddPost()));
                        },
                        child: Container(
                          padding:
                              EdgeInsets.only(top: 15, bottom: 15, right: 80),
                          margin: EdgeInsets.only(left: 6),
                          child: Text(
                            'What is on your mind?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) => AddPost()));
                      },
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.photo_library),
                          Text(
                            'photos',
                            style: TextStyle(fontSize: 11),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                thickness: .2,
              ),
              Divider(
                thickness: 5,
                height: 0,
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            child:
                Consumer<PostProvider>(builder: (context, postProvider, child) {
              List<PostModel> _listPosts = postProvider.listPosts;

              return SmartRefresher(
                enablePullUp: true,
                onRefresh: _onRefresh,
                header: WaterDropHeader(),
                controller: _refreshController,
                child: ListView.builder(
                  controller: _controller,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    if (i != 0 && i % 6 == 0) {
                      return Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            child: AdmobBanner(
                              adUnitId: getBannerAdUnitId(),
                              adSize: bannerSize,
                              listener: (AdmobAdEvent event,
                                  Map<String, dynamic> args) {},
                            ),
                          ),
                        ],
                      );
                    }

                    PostModel _post = _listPosts[i];

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
                  itemCount: _listPosts.length,
                ),
              );
            }),
          ),
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return Constants.BannerAdUnitIdAndroid;
    } else if (Platform.isAndroid) {
      return Constants.BannerAdUnitIdIOS;
    }
    return null;
  }

  _scrollListener() async {
    //start LoadMore when maxScrollExtent
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      int x = await Provider.of<PostProvider>(context, listen: false)
          .loadMore(_userModel.id);

      if (x == 0) {
        _refreshController.loadNoData();
      }
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {}
  }

  void startDeletePost(PostModel post, int i) async {
    // deletePost
    await http.post('${Constants.SERVER_URL}post/deletePost',
        body: {'post_id': post.id});
    Navigator.of(context).pop();
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    Provider.of<PostProvider>(context, listen: false)
        .startGetPostsData(_userModel.id);
    _refreshController.refreshCompleted();
  }
}
