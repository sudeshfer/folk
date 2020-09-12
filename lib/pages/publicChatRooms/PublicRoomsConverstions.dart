//created by Suthura


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:folk/pages/publicChatRooms/PublicRoomsModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/pages/FullScreenImg.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'CreateRoomPage.dart';
import 'PublicChatRoomMessagesPage.dart';

// ignore: must_be_immutable
class PublicRoomsConverstions extends StatefulWidget {
  UserModel _userModel;

  PublicRoomsConverstions(this._userModel);

  @override
  _PublicRoomsConverstionsState createState() =>
      _PublicRoomsConverstionsState();
}

class _PublicRoomsConverstionsState extends State<PublicRoomsConverstions> {
  List<PublicRoomsModel> _listRooms = [];
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    startGetRooms();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var screenSize = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          height: screenSize.height,
          width: screenSize.width,
          child: SmartRefresher(
            enablePullUp: false,
            header: WaterDropHeader(),
            onRefresh: _onRefresh,

            controller: _refreshController,
            child: ListView.builder(
              itemBuilder: (context, i) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      onLongPress: () {
                        if (widget._userModel.email == Constants.ADMIN_EMAIL) {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return AlertDialog(
                                  title: Text('are you sure to delete '),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          starDeleteRoom(_listRooms[i].id, i);
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
                        }
                      },
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (_) =>
                        //         PublicChatRoomMessagesPage(_listRooms[i])));
                      },
                      contentPadding: EdgeInsets.all(10),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CachedNetworkImage(
                          imageUrl:
                              Constants.PUBLIC_ROOMS_IMAGES + _listRooms[i].img,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(_listRooms[i].roomName),
                    ),
                    Divider(
                      color: Colors.blue,
                    )
                  ],
                );
              },
              itemCount: _listRooms.length,
              shrinkWrap: true,
            ),
          ),
        ),
        widget._userModel.email == Constants.ADMIN_EMAIL
            ? Positioned(
                bottom: 15,
                right: 15,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>CreateRoomPage()));
                  },
                  child: Icon(Icons.add,color: Colors.black,),
                ))
            : Container()
      ],
    );
  }


  startGetRooms() async {
    _listRooms=[];
    var req = await http.post('${Constants.SERVER_URL}rooms/getRooms');
    var res = convert.jsonDecode(req.body);
    if (!res['error']) {
      List data = res['data'];

      List<PublicRoomsModel> temp = [];
      temp.addAll(data.map((data) => PublicRoomsModel.fromJson(data)).toList());

      setState(() {
        _listRooms = temp;
        temp = null;
      });
      _refreshController.refreshCompleted();
    }
  }

  void starDeleteRoom(String id, int index) async {
    var req = await http
        .post('${Constants.SERVER_URL}rooms/deleteRoom', body: {"roomId": id});
    var res = convert.jsonDecode(req.body);
    if (!res['error']) {
      setState(() {
        _listRooms.removeAt(index);
      });
      Navigator.pop(context);
    }
  }

  void _onRefresh() {
    startGetRooms();


  }
}
