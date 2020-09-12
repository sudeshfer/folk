//created by Suthura

import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'dart:math';
import 'package:file/local.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:async/async.dart';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uuid/uuid.dart';
import 'package:folk/models/MessageModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/ConverstionProvider.dart';
import 'package:folk/providers/DateProvider.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:folk/customAppBars/ChatAppbar.dart';
import 'package:image_picker/image_picker.dart';
import 'FullScreenImg.dart';
import 'package:folk/models/peerProfileModel.dart';
import 'package:folk/pages/Profile_Page/landlord_profile.dart';
import 'package:timeago/timeago.dart' as timeAgo;

// ignore: must_be_immutable
class MessagesPage extends StatefulWidget {
  String chatId;
  String peerId;
  String token;
  String myId;
  bool isSeeLastMessage;
  String peerImg;
  bool isOnline;
  String peerName;
  final _profile;

  MessagesPage(
      this.chatId,
      this.peerId,
      this.token,
      this.myId,
      this.isSeeLastMessage,
      this.peerImg,
      this.isOnline,
      this.peerName,
      this._profile);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  int numberOfUsersConnectedToThisRoom = 1;
  io.Socket socket;
  FocusNode _focusNode;
  String message = '';
  bool isCurrentUserTyping = false;
  TextEditingController _txtController = TextEditingController();
  List<MessageModel> _listMessages = [];
  final double minValue = 8.0;
  final double iconSize = 28.0;
  ScrollController _scrollController;
  UserModel _userModel;
  bool isMicrophone = false;
  bool liked = false;

  FlutterSound recorderModule = new FlutterSound();
  FlutterSound playerModule = new FlutterSound();
  StreamSubscription _recorderSubscription;

  var uuid = Uuid();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String _url = '${Constants.SERVER_URL}message/upload_img_message';

  double maxDuration = 1.0;
  StreamSubscription _playerSubscription;

  String localFilePath;
  String maxRecordDuration;
  final LocalFileSystem localFileSystem = LocalFileSystem();
  String path;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: themeProvider.getThemeData.backgroundColor,
      appBar: ChatAppbar(widget.peerId, widget.peerImg, widget.isOnline,
          widget.peerName, widget._profile),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          //list messages
          Expanded(
            child: SmartRefresher(
              controller: _refreshController,
              header: WaterDropHeader(),
              onLoading: _onLoadMore,
              enablePullUp: true,
              enablePullDown: false,
              child: ListView.builder(
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (context, i) {
                  var myMessage = _listMessages[i];
                  var date = new DateTime.fromMillisecondsSinceEpoch(_listMessages[i].timeStamp);
                  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
                  final DateFormat serverFormater = DateFormat().add_jm();
                  final DateTime displayDate = displayFormater.parse(date.toString());
                  final String formatted = serverFormater.format(displayDate);

                  if (myMessage.senderId == widget.myId) {
                    //my message

                    return InkWell(
                      onLongPress: () {
                        if (widget.myId == _listMessages[i].senderId)
                          showDialog(
                              context: context,
                              builder: (context0) {
                                return AlertDialog(
                                  contentPadding: EdgeInsets.all(0),
                                  content: Container(
                                      padding: EdgeInsets.only(
                                          top: 20,
                                          bottom: 20,
                                          left: 10,
                                          right: 10),
                                      child: Text('delete from every one')),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          startDeleteMessage(
                                              _listMessages[i].id);
                                        },
                                        child: Text('delete')),
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('cancel'))
                                  ],
                                );
                              });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
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
                                      myMessage.isDeleted != 1
                                          ? InkWell(
                                            onTap: () {
                                              print(date);
                                            },
                                                                                      child: Text(
                                                  "$formatted",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    // fontWeight: FontWeight.bold,
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                          )
                                          : Container(),
                                      SizedBox(height: 5),
                                      myMessage.isDeleted == 1
                                          ? Text(
                                              'This message was removed',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold
                                              ),
                                            )
                                          : getMyMessageType(
                                              myMessage, themeProvider)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),

                      //  Bubble(
                      //     padding: BubbleEdges.all(9),
                      //     margin: BubbleEdges.only(
                      //         top: (i < _listMessages.length - 1)
                      //             ? ScreenUtil().setHeight(5.0)
                      //             : ScreenUtil().setHeight(20.0),
                      //         left: ScreenUtil().setWidth(100.0),
                      //         bottom: i == 0
                      //             ? ScreenUtil().setHeight(10.0)
                      //             : ScreenUtil().setHeight(0.0)),
                      //     elevation: 0.4,
                      //     nip: BubbleNip.no,
                      //     color: themeProvider.getThemeData.brightness ==
                      //         Brightness.dark
                      //         ? Color(0xff054640)
                      //         : Colors.blue,
                      //     style: new BubbleStyle(
                      //         radius:
                      //         Radius.circular(ScreenUtil().setWidth(40.0))),
                      //     nipHeight: ScreenUtil().setHeight(20),
                      //     nipWidth: ScreenUtil().setWidth(23),
                      //     alignment: Alignment.centerRight,
                      //     child: myMessage.isDeleted == 1
                      //         ? Text('message removed',
                      //         textAlign: TextAlign.right,
                      //         style: GoogleFonts.roboto(
                      //             fontWeight: FontWeight.w400,
                      //             fontSize: 18))
                      //         : getMyMessageType(myMessage, themeProvider))
                    );
                  } else {
                    //peer message
                    return InkWell(
                        onLongPress: () {
                          if (widget.myId == _listMessages[i].senderId)
                            showDialog(
                                context: context,
                                builder: (context0) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.all(0),
                                    content: InkWell(
                                        onTap: () {
                                          startDeleteMessage(
                                              _listMessages[i].id);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                top: 20,
                                                bottom: 20,
                                                left: 10,
                                                right: 10),
                                            child:
                                                Text('delete from every one'))),
                                  );
                                });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.85,
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
                                    margin: EdgeInsets.only(top: 10, left: 2),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      LandlordProfile(
                                                          postOwnerId:
                                                              _listMessages[i]
                                                                  .senderId)));

                                          // Navigator.of(context).push(MaterialPageRoute(
                                          //     builder: (_) =>
                                          //         PeerProfile(_listMessages[i].senderId)));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: widget
                                                      ._profile.imagesource ==
                                                  'fb'
                                              ? widget._profile.fb_url
                                              : Constants.USERS_PROFILES_URL +
                                                  widget._profile.userImg,
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
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '${widget._profile.userName}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                // SizedBox(width: 5),
                                                // Text(
                                                //   "(4)",
                                                //   style: TextStyle(
                                                //     color: Colors.deepOrange,
                                                //     fontSize: 14,
                                                //     fontWeight: FontWeight.bold,
                                                //   ),
                                                // )
                                              ],
                                            ),
                                            Text(
                                                "$formatted",
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12,
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        myMessage.isDeleted == 1
                                            ? Text('This message was removed',
                                                textAlign: TextAlign.right,
                                                style:TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold
                                              ),
                                                    )
                                            : getMyMessageType(
                                                myMessage, themeProvider)
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
                                  color: (liked) ? Colors.red : Colors.red[100],
                                ),
                              ),
                            )
                          ],
                        )

                        // Bubble(
                        //   padding: BubbleEdges.all(9),
                        //   nip: BubbleNip.no,
                        //   margin: BubbleEdges.only(top: 10),
                        //   color: themeProvider.getThemeData.brightness ==
                        //           Brightness.dark
                        //       ? Color(0xff212e36)
                        //       : Color(0xfff0f0f0),
                        //   nipHeight: ScreenUtil().setHeight(20),
                        //   nipWidth: ScreenUtil().setWidth(23),
                        //   style: new BubbleStyle(
                        //       radius:
                        //           Radius.circular(ScreenUtil().setWidth(40.0))),
                        //   alignment: Alignment.centerLeft,
                        //   elevation: 0.4,
                        //   child: myMessage.isDeleted == 1
                        //       ? Text('message removed',
                        //           textAlign: TextAlign.right,
                        //           style: GoogleFonts.roboto(
                        //               fontWeight: FontWeight.w400, fontSize: 18))
                        //       : Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: <Widget>[
                        //             getMyMessageType(myMessage, themeProvider)
                        //           ],
                        //         ),
                        // ),
                        );
                  }
                },
                itemCount: _listMessages.length,
              ),
            ),
          ),

          // is see last message
          Consumer<ConversionProvider>(builder: (context, provider, child) {
            if (provider.isPeerSeeLastMessage) {
              return Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Seen",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize:13,
                        color:Colors.grey[500],
                      ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.done_all,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ],
                  ));
            } else {
              return Container();
              // Container(
              //     margin: EdgeInsets.only(right: 5),
              //     child: Icon(
              //       Icons.done_all,
              //       color: Colors.grey[700],
              //       size: 20,
              //     ));
            }
          }),

          //input filed
          Align(
            alignment: Alignment.bottomCenter,
            child: isMicrophone
                ? _buildRecordWidget(themeProvider)
                : _buildBottomSection(themeProvider),
          )
        ],
      ),
    );
  }

  int page;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    page = 1;
    getLastMessages();
    initializeDateFormatting();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    initSocket();
    _initRecorder();
    _scrollController = ScrollController(initialScrollOffset: 0);
  }

  void getLastMessages() async {
    var url = '${Constants.SERVER_URL}message/fetch_all';

    var response =
        await http.post(url, body: {'page': '$page', 'chat_id': widget.chatId});
    var jsonResponse = await convert.jsonDecode(response.body);
    bool err = jsonResponse['error'];
    if (!err) {
      List data = jsonResponse['data'];
      List<MessageModel> temp = [];
      for (int i = 0; i < data.length; i++) {
        temp.add(MessageModel(
            isDeleted: data[i]['isDeleted'],
            id: data[i]['_id'],
            messageType: data[i]['message_type'],
            img: data[i]['img'],
            senderId: data[i]['sender_id'],
            receiverId: data[i]['receiver_id'],
            message: data[i]['message'],
            timeStamp: data[i]['created']
            
            ));
      }
      setState(() {
        _listMessages = temp;
        temp = null;
      });
    }
  }

  void startLoadMore() async {
    ++page;
    var url = '${Constants.SERVER_URL}message/fetch_all';

    var response =
        await http.post(url, body: {'page': '$page', 'chat_id': widget.chatId});
    var jsonResponse = await convert.jsonDecode(response.body);
    bool err = jsonResponse['error'];
    if (!err) {
      List data = jsonResponse['data'];

      for (int i = 0; i < data.length; i++) {
        _listMessages.add(MessageModel(
            id: data[i]['_id'],
            isDeleted: data[i]['isDeleted'],
            messageType: data[i]['message_type'],
            img: data[i]['img'],
            senderId: data[i]['sender_id'],
            receiverId: data[i]['receiver_id'],
            message: data[i]['message'],
            timeStamp: data[i]['created']));
      }
      setState(() {
        _refreshController.loadComplete();
      });
    } else {
      _refreshController.loadNoData();
    }
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
                InkWell(
                    onTap: () {
                      setState(() {
                        isMicrophone = true;
                      });
                    },
                    child: Icon(FontAwesomeIcons.microphone)),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                    onTap: () {
                      startGetAndUploadPhoto();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.photo),
                      ],
                    )),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    autocorrect: true,
                    maxLines: null,
                    onChanged: _onMessageChanged,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.multiline,
                    controller: _txtController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type your message"),
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
              if (message == '') {
                Fluttertoast.showToast(msg: 'cant send empty message');
              } else {
                _sendMessage();
              }
            },
            child: Icon(
              Icons.send,
              size: 25,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void initSocket() async {
    String url = "${Constants.SOCKET_URL}/api/message";
    socket = io.io('$url', <String, dynamic>{
      'transports': ['websocket']
    });
    socket.on('connect', (_) {
      sendJoinChat();
      if (!widget.isSeeLastMessage) {
        sendMakeLastMessageAsRead();
        sendGetNumberOfConnectedUsersToThisRoom();
      }
    });

    socket.on('msgReceive', (data) {
      _onReceiveMessage(data);
    });
    socket.on('onDeleted', (data) {
      _listMessages.map((item) {
        if (item.id == data) {
          setState(() {
            item.isDeleted = 1;
          });
        }
      }).toList();
    });

    socket.on('numberOfConenctedUsers', (data) {
      if (data == 2) {
        numberOfUsersConnectedToThisRoom = 2;
        Provider.of<ConversionProvider>(context, listen: false)
            .setIsPeerSeeLastMessage(true);
      } else {
        numberOfUsersConnectedToThisRoom = 1;
      }
    });
  }

  _unSubscribes() {
    if (socket != null) {
      socket.disconnect();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    cancelRecord();
    _unSubscribes();
    _txtController.dispose();
    if (recorderModule != null) closeRecorder();
    cancelPlayerSubscriptions();
    releaseFlauto();
    super.dispose();
  }

  void _onMessageChanged(String value) {
    setState(() {
      message = value;
      if (value.trim().isEmpty) {
        isCurrentUserTyping = false;
        return;
      } else {
        isCurrentUserTyping = true;
      }
    });
  }

  _sendMessage({int type = 0, String img = ''}) async {
    String messageId = uuid.v1();

    if (numberOfUsersConnectedToThisRoom == 2) {
      Provider.of<ConversionProvider>(context, listen: false)
          .setIsPeerSeeLastMessage(true);
    } else {
      Provider.of<ConversionProvider>(context, listen: false)
          .setIsPeerSeeLastMessage(false);
    }

    var mainMap = Map<String, Object>();
    mainMap['sender_id'] = widget.myId;
    mainMap['messageId'] = messageId;
    mainMap['sender_name'] = _userModel.name;
    mainMap['token'] = widget.token;
    mainMap['receiver_id'] = widget.peerId;
    mainMap['message'] =
        type == 0 ? message : type == 1 ? 'Sent a Photo' : 'Sent a Voice Message';
    mainMap['chat_id'] = widget.chatId;
    mainMap['message_type'] = type;
    mainMap['img'] = img;
    mainMap['created'] = DateTime.now().millisecondsSinceEpoch;

    String jsonString = convert.jsonEncode(mainMap);

    socket.emit('new_message', jsonString);

    if (type == 1) {
      // insert image at the top of list
      setState(() {
        _listMessages.insert(
            0,
            (MessageModel(
                id: messageId,
                message: message,
                senderId: widget.myId,
                messageType: 1,
                isDeleted: 0,
                img: img,
                timeStamp: DateTime.now().millisecondsSinceEpoch
                )));
        message = '';
        _txtController.text = '';
      });
    } else if (type == 2) {
      setState(() {
        _listMessages.insert(
            0,
            (MessageModel(
                id: messageId,
                message: message,
                senderId: widget.myId,
                messageType: 2,
                isDeleted: 0,
                img: img,
                timeStamp: DateTime.now().millisecondsSinceEpoch)));
        message = '';
        _txtController.text = '';
      });
    } else {
      setState(() {
        _listMessages.insert(
            0,
            (MessageModel(
                id: messageId,
                isDeleted: 0,
                message: message,
                senderId: widget.myId,
                messageType: 0,
                img: "",
                timeStamp: DateTime.now().millisecondsSinceEpoch)));
        message = '';
        _txtController.text = '';
      });
    }

    _scrollToLast();
  }

  void sendJoinChat() {
    Map map = Map();
    map['chatId'] = widget.chatId;
    map['userId'] = widget.myId;
    var myJson = convert.jsonEncode(map);
    socket.emit("joinChat", myJson);
  }

  void _onReceiveMessage(msg) {
    var data = convert.jsonDecode(msg);
    int messageType = int.parse(data['message_type']);
    print('type isssssssss $messageType');
    String img = data['img'];

    setState(() {
      _listMessages.insert(
          0,
          MessageModel(
              id: data['messageId'],
              isDeleted: 0,
              senderId: data['sender_id'],
              message: data['message'],
              messageType: messageType,
              img: img,
              timeStamp: data['created']
              ));
    });
  }

  void _scrollToLast() {
    try {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    } catch (err) {}
  }

  void sendMakeLastMessageAsRead() {
    Map map = Map();
    map['chatId'] = widget.chatId;
    map['userId'] = widget.myId;
    var myJson = convert.jsonEncode(map);
    socket.emit("makeLastMessageAsSeen", myJson);
  }

  void startGetAndUploadPhoto() async {
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    if (file != null) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(
                'are you sure to send  this image ?',
                style: TextStyle(fontSize: 16),
              ),
              content: Image.file(
                file,
                fit: BoxFit.cover,
                width: 120,
                height: 120,
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('cancel'),
                ),
                FlatButton(
                    onPressed: () {
                      startSendImageMessageOrRecord(file, 1);
                      Navigator.of(context).pop();
                    },
                    child: Text('Send'))
              ],
            );
          });
    }
  }

  void sendGetNumberOfConnectedUsersToThisRoom() {
    socket.emit("getNumberofConnectedUsersToThisRoom", widget.chatId);
  }

  void _onLoadMore() {
    startLoadMore();
  }

  void startDeleteMessage(String id) async {
    socket.emit('deleteMessage', id);

    _listMessages.map((item) {
      if (item.id == id) {
        setState(() {
          item.isDeleted = 1;
        });
      }
    }).toList();
    Navigator.pop(context);
  }

  void startSendImageMessageOrRecord(var file, int type,
      {isRecord = false}) async {
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var uri = Uri.parse(_url);
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('img', stream, length,
        filename: Path.basename(file.path));
    request.files.add(multipartFile);
    var response = await request.send();
    response.stream.transform(convert.utf8.decoder).listen((value) async {
      try {
        var jsonResponse = await convert.jsonDecode(value);
        bool error = jsonResponse['error'];
        if (error == false) {
          String imageName = jsonResponse['data'];

          _sendMessage(type: type, img: imageName);
        } else {
          print('error! ' + jsonResponse);
        }
      } catch (err) {
        print(err);
      }
    });
  }

  _initRecorder() async {
    await recorderModule.setDbPeakLevelUpdate(0.8);
    await recorderModule.setDbLevelEnabled(true);
    await recorderModule.setDbLevelEnabled(true);
  }

  _buildRecordWidget(ThemeProvider themeProvider) {
    // startRequestPermissionRec();
    _startRecord();
    return Container(
      color: themeProvider.getThemeData.brightness == Brightness.dark
          ? Colors.white30
          : Colors.black12,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
              onTap: () {
                closeRecorder();
                setState(() {
                  isMicrophone = false;
                });
              },
              child: Icon(
                Icons.delete,
                size: 30,
              )),
          Consumer<DateProvider>(builder: (context, dateProvider, child) {
            return Text('${dateProvider.dateText}');
          }),
          InkWell(
              onTap: () {
                startSendRecording();
              },
              child: Icon(
                Icons.play_arrow,
                size: 35,
              )),
        ],
      ),
    );
  }

  void startSendRecording() async {
    try {
      File file = localFileSystem.file(path);
      await recorderModule.stopRecorder();

      startSendImageMessageOrRecord(file, 2, isRecord: true);

      setState(() {
        isMicrophone = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  // void startRequestPermissionRec() async {
  //   if (await Permission.microphone.isGranted &&
  //       await Permission.storage.isGranted) {
  //     _startRecord();
  //   } else {
  //     Map<Permission, PermissionStatus> statuses = await [
  //       Permission.microphone,
  //       Permission.storage,
  //     ].request();

  //     _startRecord();
  //   }
  // }

  _startRecord() async {
    String id = Uuid().v1();
    try {
      Directory tempDir = await getTemporaryDirectory();
      path = '${tempDir.path}/$id.aac';

      path = await recorderModule.startRecorder(
          codec: t_CODEC.CODEC_AAC, uri: path);
      _recorderSubscription = recorderModule.onRecorderStateChanged.listen((e) {
        if (e != null && e.currentPosition != null) {
          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              e.currentPosition.toInt(),
              isUtc: true);
          maxRecordDuration = DateFormat('mm:ss:SS', 'en_GB').format(date);
          Provider.of<DateProvider>(context, listen: false).dateText =
              maxRecordDuration.substring(0, 8);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void closeRecorder() async {
    try {
      await recorderModule.stopRecorder();
    } catch (err) {}
  }

  void _addListeners(messageProvider) {
    cancelPlayerSubscriptions();
    _playerSubscription = playerModule.onPlayerStateChanged.listen((e) {
      if (e != null) {
        maxDuration = e.duration;
        if (maxDuration <= 0) maxDuration = 0.0;

        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            e.currentPosition.toInt(),
            isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
        messageProvider.playerText = txt.substring(0, 8);
        if (e.currentPosition.toInt() == maxDuration) {
          messageProvider.currentIcon = 0;
        }
      }
    });
  }

  getMyMessageType(MessageModel myMessage, themeProvider) {
    if (myMessage.messageType == 0) {
      return SelectableText(
        '${myMessage.message}',
        textAlign: TextAlign.start,
        style: TextStyle(
          color: myMessage.senderId == widget.myId? Colors.white : Colors.grey[700],
          fontSize: 14,
        ),
      );
    } else if (myMessage.messageType == 1) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => FullScreenImg(
                      Constants.USERS_MESSAGES_IMAGES + myMessage.img)));
        },
        child: CachedNetworkImage(
          imageUrl: Constants.USERS_MESSAGES_IMAGES + myMessage.img,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
          placeholder: (r, e) {
            return Container(
              padding: EdgeInsets.all(60),
              color: themeProvider.getThemeData.buttonColor,
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      );
    } else if (myMessage.messageType == 2) {
      return ChangeNotifierProvider.value(
        value: myMessage,
        child: Container(
          child: Consumer<MessageModel>(
            builder: (ctx, messageProvider, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          _loadFile(
                              Constants.USERS_MESSAGES_IMAGES +
                                  '${myMessage.img}',
                              messageProvider);
                          if (messageProvider.currentIcon == 0)
                            messageProvider.currentIcon = 1;
                          else
                            messageProvider.currentIcon = 0;
                        },
                        child: messageProvider.currentIcon == 0
                            ? Icon(
                                FontAwesomeIcons.play,
                                size: 25,
                              )
                            : Icon(
                                FontAwesomeIcons.pause,
                                size: 25,
                              ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 50, top: 5),
                      child: Text(
                          '${messageProvider.playerText == '00:00:00' ? '' : messageProvider.playerText}',
                          style: TextStyle(fontSize: 12)))
                ],
              );
            },
          ),
        ),
      );
    }
  }

  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;
    }
  }

  Future _loadFile(String kUrl1, messageProvider) async {
    final bytes = await readBytes(kUrl1);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${Uuid().v1()}.aac');
    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      if (playerModule.isPlaying) {
        await playerModule.stopPlayer();
      } else {
        await playerModule.startPlayer(file.path);
        _addListeners(messageProvider);
      }
    }
  }

  void releaseFlauto() async {
    try {
      await playerModule.stopPlayer();
    } catch (err) {}
  }

  void cancelRecord() async {
    if (_recorderSubscription != null) _recorderSubscription.cancel();
  }
}
