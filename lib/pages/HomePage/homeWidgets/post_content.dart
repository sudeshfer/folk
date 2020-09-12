import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:folk/models/PostModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/PostProvider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:folk/widgets/PostsPageItem.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/pages/HomePage/homeWidgets/trending.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:folk/utils/HelperWidgets/noResponse_msg.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';

class PostsContent extends StatefulWidget {
  @override
  _PostsContentState createState() => _PostsContentState();
}

class _PostsContentState extends State<PostsContent> {
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
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 3), (t) {
      setState(() {
        isLoading = false;
      });
      t.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Trending(),
        Expanded(
          child: PageView(
            scrollDirection: Axis.vertical,
            controller: PageController(viewportFraction: 1),
            pageSnapping: true,
            children: <Widget>[
              Consumer<PostProvider>(builder: (context, postProvider, child) {
                List<PostModel> _listPosts = postProvider.listPosts;

                return SmartRefresher(
                    enablePullUp: true,
                    onRefresh: _onRefresh,
                    header: WaterDropMaterialHeader(
                      backgroundColor: Color(0xFFFF5E3A),
                    ),
                    controller: _refreshController,
                    child: _listPosts.isNotEmpty
                        ? ListView.builder(
                            controller: _controller,
                            scrollDirection: Axis.vertical,
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
                            : Noresponse()
                    // CardListSkeleton(
                    //     style: SkeletonStyle(
                    //       theme: SkeletonTheme.Light,
                    //       isShowAvatar: true,
                    //       isCircleAvatar: true,
                    //       barCount: 2,
                    //     ),
                    //   ),
                    );
              }),
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: 1,
              //   itemBuilder: (BuildContext context, int index) {
              //     return buildPost(context);
              //   },
              // ),
            ],
          ),
        ),
        SizedBox(height: 100),
      ],
    );
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

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    Provider.of<PostProvider>(context, listen: false)
        .startGetPostsData(_userModel.id);
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
