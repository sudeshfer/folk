import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folk/utils/HelperWidgets/circle_user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:folk/models/NotificationModel.dart';
import 'package:folk/models/PostModel.dart';
import 'package:folk/pages/CommentsPage.dart';
import 'package:folk/utils/Constants.dart';
import 'package:timeago/timeago.dart' as timeAgo;

// ignore: must_be_immutable
class NotificationItem extends StatefulWidget {
  NotificationModel _notificationModel;

  NotificationItem(this._notificationModel);

  @override
  _NotificationItemState createState() =>
      _NotificationItemState(_notificationModel);
}

class _NotificationItemState extends State<NotificationItem> {
  NotificationModel _notificationModel;
  var date;

  _NotificationItemState(this._notificationModel);

  @override
  void initState() {
    date = new DateTime.fromMillisecondsSinceEpoch(
        widget._notificationModel.timeStamp);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(_notificationModel.imagesourse);
        //  Navigator.of(context).push(MaterialPageRoute(
        //           builder: (_) => CommentsPage(PostModel(
        //               id: _notificationModel.postId,
        //               postOwnerId: _notificationModel.peerId))));
      },
          child: Column(
        children: <Widget>[
          LikedPostComment(
            name: "${_notificationModel.name}",
            action: "${_notificationModel.title}",
            timeStamp: '${timeAgo.format(date)}',
            notificationModel: _notificationModel,
            // postOrComment: "post",
            content:_notificationModel.notifContent != null? "<< ${_notificationModel.notifContent} >>": "",
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (_) => CommentsPage(PostModel(
          //             id: _notificationModel.postId,
          //             postOwnerId: _notificationModel.peerId))));
          //   },
          //   title: Row(
          //     children: <Widget>[
          //       Flexible(
          //         child: Text(
          //           '${_notificationModel.name} ',
          //           maxLines: 1,
          //           style: GoogleFonts.roboto(fontWeight: FontWeight.w400),
          //         ),
          //       ),
          //       Text(
          //         '${_notificationModel.title}',
          //         style: GoogleFonts.roboto(fontWeight: FontWeight.w300),
          //       ),
          //     ],
          //   ),
          //   leading: CachedNetworkImage(
          //     imageUrl: Constants.USERS_PROFILES_URL + _notificationModel.userImg,
          //     width: 60,
          //     height: 80,
          //     fit: BoxFit.cover,
          //   ),
          //   subtitle: Container(
          //     padding: EdgeInsets.only(top: 25),
          //     child: Row(
          //       children: <Widget>[
          //         Icon(
          //           _notificationModel.title == 'Liked your post'
          //               ? LineIcons.thumbs_up
          //               : LineIcons.comment,
          //           size: 16,
          //           color: Colors.blue,
          //         ),
          //         SizedBox(
          //           width: 5,
          //         ),
          //         Text(
          //           '${timeAgo.format(date)}',
          //           style: TextStyle(fontSize: 14, color: Colors.grey),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}

class LikedPostComment extends StatelessWidget {
  final String name;
  final String howMany;
  final String action;
  final String timeStamp;
  NotificationModel notificationModel;
  final String content;

   LikedPostComment(
      {@required this.name,
      this.howMany = "",
      @required this.action,
      this.timeStamp,
      this.notificationModel,
      // @required this.postOrComment,
      this.content = ""
      });

  @override
  Widget build(BuildContext context) {
    return NotificationCard(
      name: name,
      content: <TextSpan>[
        // TextSpan(
        //   text: (howMany != "") ? "and " : "",
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.normal,
        //   ),
        // ),
        // TextSpan(
        //   text: (howMany != "") ? "$howMany others " : "",
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        TextSpan(
          text: "$action",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        // TextSpan(
        //   text: "$postOrComment ",
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        TextSpan(
          text: " $content",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
      time: timeStamp,
      imgUrl: notificationModel.imagesourse == 'userimage'?
              Constants.USERS_PROFILES_URL + notificationModel.userImg
              : notificationModel.userImg,
      notificationModel: notificationModel,
    );
  }
}

class NotificationCard extends StatelessWidget {
  final bool withBorder;
  final double padding;
  final String name;
  final List<TextSpan> content;
  final String time;
  final String imgUrl;
  NotificationModel notificationModel;

  NotificationCard(
      {@required this.name,
      @required this.content,
      @required this.time,
      this.withBorder = false,
      this.padding = 10,
      this.imgUrl,
      this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(padding, padding, padding, padding + 10),
      // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      color: notificationModel.isread? Colors.white : Colors.orange[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl:imgUrl,
                imageBuilder: (context, imageProvider) => Container(
                  width: 45.0,
                  height: 45.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - padding * 2 - 60,
                    child: RichText(
                      text: TextSpan(
                          text: "$name ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: content),
                          overflow: TextOverflow.clip ,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                  notificationModel.title == 'Liked your post'?
                  Image.asset(
                                'assets/images/LikePressed.png',
                                width: 20,
                                height: 20,
                              ):
                   Image.asset(
                                'assets/images/Comments.png',
                                width: 25,
                                height: 25,
                              )           ,
                  SizedBox(
                    width: 5,
                  ),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationCardWithBtn extends StatelessWidget {
  final Widget trailing;
  final bool withBorder;
  final double padding;
  final String name;
  final String content;
  final String time;

  const NotificationCardWithBtn(
      {@required this.name,
      @required this.content,
      @required this.time,
      @required this.trailing,
      this.withBorder = false,
      this.padding = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(padding, padding, padding, padding),
      // margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleUser(
                withBorder: withBorder,
                size: 50,
                url:
                    "https://pixinvent.com/demo/vuexy-vuejs-admin-dashboard-template/demo-3/img/user-13.005c80e1.jpg",
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width:
                        MediaQuery.of(context).size.width - padding * 2 - 170,
                    child: RichText(
                      text: TextSpan(
                          text: "$name ",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: content,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing,
        ],
      ),
    );
  }
}

class JoinedEvent extends StatelessWidget {
  final String name;
  final String image;
  final String eventName;
  final String eventDate;
  final String time;

  const JoinedEvent(
      {this.name = "You Joined Event",
      this.image =
          "https://www.portanova.nl/wp-content/uploads/2018/12/PN-Sara-Crookston-rose-boutique-shoot-lowres-small-38.jpg",
      this.eventName = "Win 2 tickets to WWE @MSG",
      this.eventDate = "SUN, MAR. 25 - 4:30 PM EST",
      this.time = "5 min"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              Icons.star_border,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Montserrat",
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 200,
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(eventName),
                        Text(
                          eventDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
