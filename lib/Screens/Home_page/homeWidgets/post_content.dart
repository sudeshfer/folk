import 'package:flutter/material.dart';
import 'package:folk/Screens/Home_page/homeWidgets/trending.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostsContent extends StatefulWidget {
  PostsContent({Key key}) : super(key: key);

  @override
  _PostsContentState createState() => _PostsContentState();
}

class _PostsContentState extends State<PostsContent> {
  bool isWishBtnClicked = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Trending(),
        _buildPost(context),
        _buildPost(context),
        _buildPost(context),
        ]
      );
  }

  Widget _buildPost(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 8.0, 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  children: <Widget>[
                     _buildAvatar(context),
                    new SizedBox(
                      width: 10.0,
                    ),
                    _buildNameContent(context)
                  ],
                ),
              ),
              new IconButton(
                icon: Icon(Icons.more_horiz, size: 35),
                onPressed: null,
              )
            ],
          ),
        ),
        _buildTimeBar(context),
        _buildWishListBar(context),
        _buildPostText(context),
       _devider(context),
       Container(
         decoration: BoxDecoration(
        boxShadow:[BoxShadow(
           color: Colors.grey[200],
           offset: new Offset(5.0, 18.0),
           spreadRadius: 2.0,
            blurRadius: 8.0,
        )]
      ),
         child:_buildLikeCommentBar(context),
       )
       
      //  _devider(context),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context){
     return Container(
                      height: 45.0,
                      width: 45.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage('assets/images/Avatar.png')),
                      ),
                    );
  }

  Widget _buildNameContent(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color:Colors.white
      ),
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
                                      margin: const EdgeInsets.only(
                                          left: 5.0, bottom: 5),
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
    );
  }

  Widget _buildTimeBar(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
          margin: const EdgeInsets.only(top: 0),
          height: 25,
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
                child: new Text(
                  "7 Days 06 Hrs 27 Mins 44 Secs",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 13),
                ),
              )
            ],
          )),
    );
  }

  Widget _buildWishListBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(right: 7),
                height: 30,
                width: MediaQuery.of(context).size.width / 5.5,
                decoration: BoxDecoration(
                    color: Color(0xFFffebee),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0),
                        bottomLeft: Radius.circular(0.0))),
                child: Center(
                  child: Text(
                    "culture",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color.fromRGBO(255, 112, 67, 1),
                        fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
          _buildWishlistBtn(context)
        ],
      ),
    );
  }

  Widget _buildWishlistBtn(BuildContext context) {
    return Container(
      child: isWishBtnClicked
          ? GestureDetector(
              onTap: () {
                setState(() {
                  isWishBtnClicked = false;
                });
              },
              child: Image.asset(
                'assets/images/icon_wishlisted.png',
                width: 32,
                height: 32,
              ),
            )
          : GestureDetector(
              onTap: () {
                setState(() {
                  isWishBtnClicked = true;
                });
              },
              child: new Image.asset(
                'assets/images/ic_wishlist.png',
                width: 32,
                height: 32,
              ),
            ),
    );
  }

  Widget _buildPostText(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 20, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                // margin: const EdgeInsets.only(bottom: 5),
                child: Text(
              "Just visited this awesome place first time in my life. Check out the photos!",
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

  Widget _devider(BuildContext context){
    return  Divider(
      color: Colors.grey,
    );
  }

  Widget _buildLikeCommentBar(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color:Colors.white
      ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 20,top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Image.asset(
                                    'assets/images/LikePressed.png',
                                    width: 32,
                                    height: 32),
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "2105 likes",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 14),
                                ),
                                new SizedBox(
                                  width: 10.0,
                                ),
                                new Image.asset('assets/images/Comments.png',
                                    width: 32, height: 32),
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "12 comments",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
  }
}
