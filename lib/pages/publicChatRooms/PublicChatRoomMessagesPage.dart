import 'package:bubble/bubble.dart';
import 'dart:io';
import 'dart:io' as io;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:folk/models/MessageModel.dart';
import 'package:folk/pages/PeerProfile.dart';
import 'package:folk/pages/publicChatRooms/PublicRoomsModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:folk/utils/Constants.dart';
import 'PublicChatMessageModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:folk/pages/Profile_Page/landlord_profile.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:intl/intl.dart';

class PublicChatRoomMessagesPage extends StatefulWidget {
  // PublicRoomsModel roomInfo;
  String roomId;
  String roomName;

  PublicChatRoomMessagesPage(this.roomId, this.roomName);

  @override
  _PublicChatRoomMessagesPageState createState() =>
      _PublicChatRoomMessagesPageState();
}

class _PublicChatRoomMessagesPageState
    extends State<PublicChatRoomMessagesPage> {
  UserModel _userModel;
  List<PublicChatMessageModel> _listMessages = [];
  io.Socket socket;
  TextEditingController _txtController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  final double minValue = 8.0;
  final double iconSize = 28.0;
  String numClients;
  bool liked = false;
  bool isloading = true;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    initSocket();

    startGetLastMessages();
  }

  void initSocket() async {
    String URI = "${Constants.SOCKET_URL}/api/joinPublicRoom";
    socket = io.io('$URI', <String, dynamic>{
      'transports': ['websocket']
    });
    socket.on('connect', (_) {
      sendJoin();
    });
    socket.on('disconnect', (_) => print('disconnect'));

    socket.on('RoomMsgReceive', (data) {
      _onReceiveCommentMessage(data);
    });

    socket.on('UserJoin', (msg) {
      var data = convert.jsonDecode(msg);

      setState(() {
        numClients = '${data['numClients']}';
        _listMessages.insert(
            0,
            PublicChatMessageModel(
                senderName: data['sender_name'], isJoin: true,
              //   senderId: data['sender_id'],
              // senderImg: data['sender_img'],
              // message: data['message'],
              // imageSource: data['imagesource'],
              // dateTime: data['createdAt'],
                ));
      });
    });
  }

  void sendJoin() {
    String roomId = widget.roomId;
    var mainMap = Map<String, Object>();
    mainMap['roomId'] = roomId;
    mainMap['user_name'] = _userModel.name;
    String jsonString = convert.jsonEncode(mainMap);
    socket.emit("joinPublicRoom", [jsonString]);
  }

  @override
  void dispose() {
    _unSubscribes();
    super.dispose();
  }

  _unSubscribes() {
    if (socket != null) {
      socket.disconnect();
    }
  }

  getmsgSendTime(date) {
    String selecteddate = date.toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat().add_jm();
    // final DateFormat serverFormaterr = DateFormat().add_Hms();
    final DateTime displayDate = displayFormater.parse(selecteddate);
    final String formatted = serverFormater.format(displayDate);
    String timeSelected = formatted;
    return timeSelected;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: themeProvider.getThemeData.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text('${widget.roomName}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: SmartRefresher(
              header: WaterDropHeader(),
              onLoading: _onLoadMore,
              enablePullUp: true,
              enablePullDown: false,
              controller: _refreshController,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _listMessages.length,
                reverse: true,
                itemBuilder: (context, i) {
                  PublicChatMessageModel message = _listMessages[i];
                  // var timestamp =
                  //     new DateTime.fromMillisecondsSinceEpoch(message.dateTime);
                  return message.isJoin
                      ? Center(
                          child: Container(
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.yellow.shade300,
                              ),
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '${message.senderName} joined chat',
                                style: TextStyle(color: Colors.black),
                              )),
                        )
                      : _listMessages[i].senderId == _userModel.id
                          //my message No image
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    color: Color.fromRGBO(255, 94, 58, 1),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "09.50 AM",
                                              style: TextStyle(
                                                fontSize: 12,
                                                // fontWeight: FontWeight.bold,
                                                color: Colors.grey[300],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            SelectableText(
                                              '${message.message}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )

                          // Bubble(
                          // padding: BubbleEdges.all(9),
                          // margin: BubbleEdges.only(
                          //     top: (i < _listMessages.length - 1)
                          //         ? ScreenUtil().setHeight(15.0)
                          //         : ScreenUtil().setHeight(20.0),
                          //     left: ScreenUtil().setWidth(100.0),
                          //     bottom: i == 0
                          //         ? ScreenUtil().setHeight(10.0)
                          //         : ScreenUtil().setHeight(0.0)),
                          // elevation: 0.4,
                          // nip: BubbleNip.no,
                          // color: themeProvider.getThemeData.brightness ==
                          //     Brightness.dark
                          //     ? Colors.blue
                          //     : Colors.blue.shade300,
                          // style: new BubbleStyle(
                          //     radius: Radius.circular(
                          //         ScreenUtil().setWidth(40.0))),
                          // nipHeight: ScreenUtil().setHeight(20),
                          // nipWidth: ScreenUtil().setWidth(23),
                          // alignment: Alignment.centerRight,
                          // child: SelectableText(
                          //   '${message.message}',
                          //   textAlign: TextAlign.start,
                          //   style: GoogleFonts.roboto(
                          //       fontWeight: FontWeight.w400, fontSize: 18),
                          // ))
                          //user Message with image
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: Colors.grey[100],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            EdgeInsets.only(top: 10, left: 2),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          LandlordProfile(
                                                              postOwnerId:
                                                                  _listMessages[
                                                                          i]
                                                                      .senderId)));

                                              // Navigator.of(context).push(MaterialPageRoute(
                                              //     builder: (_) =>
                                              //         PeerProfile(_listMessages[i].senderId)));
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: message.imageSource == 'userimage'?
                                                  Constants.USERS_PROFILES_URL +
                                                      message.senderImg
                                                      :message.senderImg,
                                              height: 30,
                                              width: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () {
                                                        print("${message.imageSource}");
                                                      },
                                                                                                          child: Text(
                                                        '${message.senderName}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          // fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      "(4)",
                                                      style: TextStyle(
                                                        color:
                                                            Colors.deepOrange,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                 "09.50 AM",
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            SelectableText(
                                              "${message.message}",
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      liked = !liked;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: FaIcon(
                                      FontAwesomeIcons.solidHeart,
                                      color: (liked)
                                          ? Colors.red
                                          : Colors.red[100],
                                    ),
                                  ),
                                )
                              ],
                            );
                  //     Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: <Widget>[
                  //     Container(
                  //       margin: EdgeInsets.only(top: 10, left: 2),
                  //       child: ClipRRect(
                  //         borderRadius: BorderRadius.circular(60),
                  //         child: InkWell(
                  //           onTap: () {
                  //             Navigator.of(context).push(MaterialPageRoute(
                  //                 builder: (_) =>
                  //                     PeerProfile(_listMessages[i].senderId)));
                  //           },
                  //           child: CachedNetworkImage(
                  //             imageUrl: Constants.USERS_PROFILES_URL +
                  //                 message.senderImg,
                  //             height: 30,
                  //             width: 30,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Flexible(
                  //       child: Container(
                  //         child: Bubble(
                  //           padding: BubbleEdges.all(9),
                  //           nip: BubbleNip.no,
                  //           margin: BubbleEdges.only(top: 5),
                  //           color: themeProvider
                  //               .getThemeData.brightness ==
                  //               Brightness.dark
                  //               ? Colors.white30
                  //               : Colors.grey.shade100,
                  //           nipHeight: ScreenUtil().setHeight(20),
                  //           nipWidth: ScreenUtil().setWidth(23),
                  //           style: new BubbleStyle(
                  //               radius: Radius.circular(
                  //                   ScreenUtil().setWidth(40.0))),
                  //           alignment: Alignment.centerLeft,
                  //           elevation: 0.4,
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: <Widget>[
                  //               Text('${message.senderName}',
                  //                   style: GoogleFonts.roboto(
                  //                       fontWeight: FontWeight.w800,
                  //                       fontSize: 14)),
                  //               SizedBox(height: 2,),
                  //               SelectableText('${message.message}',
                  //                   style: GoogleFonts.roboto(
                  //                       fontWeight: FontWeight.w400,
                  //                       fontSize: 18)),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // );
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomSection(themeProvider),
          )
        ],
      ),
    );
  }

  _buildBottomSection(themeProvider) {
    return Container(
      decoration: BoxDecoration(
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
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: FaIcon(FontAwesomeIcons.laugh),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.65,
            child: TextField(
              maxLines: null,
              focusNode: _focusNode,
              keyboardType: TextInputType.multiline,
              controller: _txtController,
              autofocus: false,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Write a message"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            child: GestureDetector(
              onTap: () {
                if (_txtController.text.isEmpty) {
                  Fluttertoast.showToast(msg: 'cant send empty message');
                } else {
                  _sendMessage();
                }
              },
              child: Image(
                image: AssetImage("assets/images/ic_send.png"),
                width: 30,
              ),
            ),
          ),
        ],
      ),
    );

    // Row(
    //   children: <Widget>[
    //     Expanded(
    //       child: Container(
    //         height: 52,
    //         margin: EdgeInsets.all(8),
    //         padding: EdgeInsets.symmetric(horizontal: 8),
    //         decoration: BoxDecoration(
    //             color: themeProvider.getThemeData.dividerColor,
    //             borderRadius: BorderRadius.all(Radius.circular(8.0 * 4))),
    //         child: Row(
    //           children: <Widget>[
    //             Expanded(
    //               child: TextField(
    //                 maxLines: null,
    //                 focusNode: _focusNode,
    //                 keyboardType: TextInputType.multiline,
    //                 controller: _txtController,
    //                 decoration: InputDecoration(
    //                     border: InputBorder.none,
    //                     hintText: "Type your message"),
    //                 autofocus: false,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     Padding(
    //       padding: EdgeInsets.only(right: minValue, top: 5, bottom: 5),
    //       child: FloatingActionButton(
    //         elevation: 0,
    //         onPressed: () {
    //           if (_txtController.text.isEmpty) {
    //             Fluttertoast.showToast(msg: 'cant send empty message');
    //           } else {
    //             _sendMessage();
    //           }
    //         },
    //         child: Icon(
    //           Icons.send,
    //           size: 25,
    //           color: Colors.black,
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }

  void _onReceiveCommentMessage(var msg) {
    try {
      var data = convert.jsonDecode(msg);

      setState(() {
        _listMessages.insert(
            0,
            PublicChatMessageModel(
              senderId: data['sender_id'],
              senderImg: data['sender_img'],
              senderName: data['sender_name'],
              message: data['message'],
              imageSource: data['imagesource'],
              // dateTime: data['createdAt'],
            ));
      });
    } catch (err) {
      print('error is $err');
    }
  }

  void _sendMessage() {
    String userImg = (_userModel.imagesource == 'userimage') ? _userModel.img : _userModel.fb_url; 
    var mainMap = Map<String, Object>();
    mainMap['sender_id'] = _userModel.id;
    mainMap['message'] = _txtController.text;
    mainMap['sender_name'] = _userModel.name;
    mainMap['sender_img'] = userImg;
    mainMap['room_id'] = widget.roomId;
    mainMap['imagesource'] = _userModel.imagesource;
    mainMap['createdAt'] = DateTime.now().microsecondsSinceEpoch;
    String jsonString = convert.jsonEncode(mainMap);
    socket.emit('new_comment', [jsonString]);
    setState(() {
      _listMessages.insert(
          0,
          PublicChatMessageModel(
              senderId: _userModel.id,
              message: _txtController.text,
              // dateTime: DateTime.now().millisecondsSinceEpoch
              ));
    });
    _txtController.clear();
  }

  void startGetLastMessages() async {
    page = 1;
    var req = await http.post('${Constants.SERVER_URL}roomsMessages/fetch_all',
        body: {'room_id': '${widget.roomId}', 'page': '1'});
    var res = convert.jsonDecode(req.body);
    if (!res['error']) {
      List data = res['data'];
      List<PublicChatMessageModel> temp = [];
      for (int i = 0; i < data.length; i++) {
        temp.add(PublicChatMessageModel(
          senderId: data[i]['sender_id'],
          senderName: data[i]['sender_name'],
          message: data[i]['message'],
          senderImg: data[i]['sender_img'],
          imageSource: data[i]['imagesource'],
          // dateTime: data[i]['createdAt'],
        ));
      }
      setState(() {
        _listMessages = temp;
        isloading = false;
        temp = null;
      });
    }
  }

  void _onLoadMore() async {
    ++page;
    var req = await http.post('${Constants.SERVER_URL}roomsMessages/fetch_all',
        body: {'room_id': '${widget.roomId}', 'page': '$page'});
    var res = convert.jsonDecode(req.body);

    if (!res['error']) {
      List data = res['data'];
      List<PublicChatMessageModel> temp = [];
      for (int i = 0; i < data.length; i++) {
        temp.add(PublicChatMessageModel(
          senderId: data[i]['sender_id'],
          senderName: data[i]['sender_name'],
          message: data[i]['message'],
          senderImg: data[i]['sender_img'],
          imageSource: data[i]['imagesource'],
          // dateTime: data[i]['createdAt'],
        ));
      }
      setState(() {
        _listMessages.addAll(temp);
        temp = null;
        _refreshController.loadComplete();
      });
    } else {
      //load more done
      _refreshController.loadNoData();
    }
  }
}
