//created by Suthura

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/ConversionModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/ConverstionProvider.dart';
import 'package:folk/widgets/ChatItem.dart';
import 'MessagesPage.dart';
import 'SearchUserPage.dart';
import 'package:folk/models/peerProfileModel.dart';

class ConversionPage extends StatefulWidget {
  ConversionPage();

  @override
  _ConversionPageState createState() => _ConversionPageState();
}

class _ConversionPageState extends State<ConversionPage> {
  List<ConversionModel> _listChatRooms = [];
  UserModel _userModel;
  var date;

  var textFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listChatRooms = Provider.of<ConversionProvider>(context).conversionList;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // InkWell(
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (_) =>
            //                   SearchUserPage(_userModel.id, _userModel.email)));
            //     },
            //     child:
            //         _entryField('search users in Folk', textFieldController)),
            _listChatRooms.length == 0
                ? Container()
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      ConversionModel _listChats = _listChatRooms[index];
                      return InkWell(
                          onTap: () {
                            
                            Provider.of<ConversionProvider>(context,
                                        listen: false)
                                    .isPeerSeeLastMessage =
                                _listChatRooms[index].isTwoUsersSeeLastMessage;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MessagesPage(
                                        _listChatRooms[index].chatId,
                                        _listChatRooms[index].userId,
                                        _listChatRooms[index].token,
                                        _userModel.id,
                                        _listChatRooms[index].isLastMessageSeen,
                                        _listChatRooms[index].userImg,
                                        _listChatRooms[index].isOnline,
                                        _listChatRooms[index].userName,
                                        _listChatRooms[index])));
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 7, left: 5),
                              child: ChatItem(_listChats, _userModel.id)));
                    },
                    itemCount: _listChatRooms.length,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, controller, {bool isPassword = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              enabled: false,
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: title, filled: true))
        ],
      ),
    );
  }
}
