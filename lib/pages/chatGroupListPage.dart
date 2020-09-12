import 'package:flutter/material.dart';
import 'package:folk/models/ChatGroupModel.dart';
import 'package:folk/pages/publicChatRooms/PublicChatRoomMessagesPage.dart';
import 'package:folk/providers/chatGroupProvider.dart';
import 'package:folk/widgets/groupChatItem.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/ConverstionProvider.dart';
import 'MessagesPage.dart';

class ChatGroupList extends StatefulWidget {
  ChatGroupList();

  @override
  _ChatGroupListState createState() => _ChatGroupListState();
}

class _ChatGroupListState extends State<ChatGroupList> {
  List<ChatGroupModel> _listChatRooms = [];
  UserModel _userModel;
  var date;

  var textFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    Provider.of<ChatGroupProvider>(context, listen: false)
        .initChatGroupSocketAndRequestChats(_userModel);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listChatRooms = Provider.of<ChatGroupProvider>(context).chatgroupList;
    print("lengththhhhhhhhhhhhhhhhhhhhhhhh is ${_listChatRooms.length}");

    print("sunnapodesh124567");
    print("${_listChatRooms[0].groupUserData[0].username}");
    print("sunnapodesh124567");
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
                      ChatGroupModel _listChats = _listChatRooms[index];
                      return InkWell(
                          onTap: () {
                            Provider.of<ChatGroupProvider>(context,
                                        listen: false)
                                    .isPeerSeeLastMessage =
                                _listChatRooms[index].isTwoUsersSeeLastMessage;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    PublicChatRoomMessagesPage(
                                        _listChats.chatId,
                                        _listChats.roomName)));
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (_) => MessagesPage(
                            //             _listChatRooms[index].chatId,
                            //             _listChatRooms[index].userId,
                            //             _listChatRooms[index].token,
                            //             _userModel.id,
                            //             _listChatRooms[index].isLastMessageSeen,
                            //             _listChatRooms[index].userImg,
                            //             _listChatRooms[index].isOnline,
                            //             _listChatRooms[index].userName,
                            //             _listChatRooms[index])));
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 7, left: 5),
                              child: GroupChatItem(_listChats, _userModel.id)));
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
