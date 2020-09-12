//created by Suthura
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:folk/utils/Util_Functions/functions.dart';
import 'package:folk/models/ConversionModel.dart';
import 'package:timeago/timeago.dart' as timeAgo;

// ignore: must_be_immutable
class ChatItem extends StatelessWidget {
  ConversionModel _chatRoomModel;
  String myId;


  ChatItem(this._chatRoomModel, this.myId);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 15, 15, 15),
      margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: (!_chatRoomModel.isLastMessageSeen)
            ? Colors.grey[100]
            : Colors.transparent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // CircleUserBundle(
          //   size: 60,
          //   urlList: imgList,
          // ),
          Container(
              width: 51,
              height: 51,
              margin: EdgeInsets.only(left: 5),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: CachedNetworkImage(
                      imageUrl: Functions.initPorfileImge(
                          _chatRoomModel.imagesource,
                          "${_chatRoomModel.fb_url}",
                          "${_chatRoomModel.userImg}"),
                      // Constants.USERS_PROFILES_URL +
                      //     _chatRoomModel.userImg,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  _chatRoomModel.isOnline == false
                      ? Container()
                      : Positioned(
                          bottom: 0,
                          right: 0,
                          child: Icon(
                            Icons.brightness_1,
                            color: Colors.green,
                            size: 16,
                          ))
                ],
              )),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "${_chatRoomModel.userName}",
                          style: TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "(4)",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        print(_chatRoomModel.timeStamp);
                      },
                                          child: Text(
                        "${timeAgo.format(DateTime.parse(_chatRoomModel.timeStamp))}",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  "${_chatRoomModel.lastMessage}",
                  style: _chatRoomModel.isLastMessageSeen
                      ? TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        )
                      : TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                )
              ],
            ),
          )
        ],
      ),
    );

    // Column(
    //   children: <Widget>[
    //     Container(
    //         margin: EdgeInsets.only(top: 10, bottom: 10),
    //         width: MediaQuery.of(context).size.width,
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             //user image
    //             Container(
    //                 width: 51,
    //                 height: 51,
    //                 margin: EdgeInsets.only(left: 5),
    //                 child: Stack(
    //                   children: <Widget>[
    //                     ClipRRect(
    //                       borderRadius: BorderRadius.circular(60),
    //                       child: CachedNetworkImage(
    //                         imageUrl: Functions.initPorfileImge(_chatRoomModel.imagesource, "${_chatRoomModel.fb_url}", "${_chatRoomModel.userImg}"),
    //                         // Constants.USERS_PROFILES_URL +
    //                         //     _chatRoomModel.userImg,
    //                         fit: BoxFit.cover,
    //                         width: 50,
    //                         height: 50,
    //                       ),
    //                     ),
    //                     _chatRoomModel.isOnline == false
    //                         ? Container()
    //                         : Positioned(
    //                             bottom: 0,
    //                             right: 0,
    //                             child: Icon(
    //                               Icons.brightness_1,
    //                               color: Colors.green,
    //                               size: 16,
    //                             ))
    //                   ],
    //                 )),
    //             SizedBox(
    //               width: 5,
    //             ),
    //             //user Name And last message
    //             Container(
    //               height: 51,
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: <Widget>[
    //                   Text(
    //                     _chatRoomModel.userName,
    //                     style: GoogleFonts.roboto(
    //                         fontWeight: FontWeight.w500, fontSize: 14.5),
    //                   ),
    //                   Container(
    //                     width: MediaQuery.of(context).size.width / 2 + 20,
    //                     child: Text(
    //                       _chatRoomModel.lastMessage,
    //                       style: _chatRoomModel.isLastMessageSeen
    //                           ? GoogleFonts.roboto(
    //                               color: Colors.grey,
    //                               fontWeight: FontWeight.w500)
    //                           : GoogleFonts.roboto(
    //                               fontWeight: FontWeight.w600, fontSize: 15),
    //                       maxLines: 1,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         )),
    //     Divider(
    //       thickness: 1,
    //     )
    //   ],
    // );
  }
}
