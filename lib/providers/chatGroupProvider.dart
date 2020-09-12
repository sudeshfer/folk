import 'package:flutter/foundation.dart';
import 'package:folk/models/ChatGroupModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/utils/Constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatGroupProvider with ChangeNotifier {
  UserModel _userModel;

  List<ChatGroupModel> _chatgroupList = [];

  List<ChatGroupModel> get chatgroupList => _chatgroupList;

  bool isPeerSeeLastMessage = false;

  void setIsPeerSeeLastMessage(bool value) {
    isPeerSeeLastMessage = value;
    notifyListeners();
  }

  initChatGroupSocketAndRequestChats(UserModel userModel) {
    this._userModel = userModel;
    var url = '${Constants.SOCKET_URL}/api/chatRoomList';

    io.Socket roomSocket = io.io('$url', <String, dynamic>{
      'transports': ['websocket']
    });

    roomSocket.on('connect', (_) {
      //send request to server to ge messages
      roomSocket.emit('getChatRoomList', userModel.id);
    });

    roomSocket.on('ChatListReady', (res) {
      print("workinggggggggggggggggggggggggggggggggggggg");
      // once server send Conversions
      try {
        if (!res['error']) {
          //if user id in _listOnlineUsers make this user Online else offline
          List<dynamic> _listOnlineUsers = res['onLineUsersId'];
          var listData = res['data'];
          print(listData);
          List<ChatGroupModel> temp = [];

          for (int i = 0; i < listData.length; i++) {
            String userOne = res['data'][i]['users'][0]['_id'];
            String chatId = res['data'][i]['_id'];
            String time = res['data'][i]['updatedAt'];
            String chatImg = res['data'][i]['img'];
            String roomname = res['data'][i]['room_name'];

            print("ssssssssssssssssssssssssss $time");
            int indexOfPeerUser = 0;
            if (userOne == _userModel.id) {
              indexOfPeerUser = 1;
            } else {
              indexOfPeerUser = 0;
            }
            var userModel = res['data'][i]['users'][0];
            temp.add(ChatGroupModel(
                chatId: chatId,
                userName: userModel['user_name'],
                token: userModel['token'],
                userImg: userModel['img'],
                userId: userModel['_id'],
                imagesource: userModel['imagesource'],
                fb_url: userModel['fb_url'],
                timeStamp: time,
                chatRoomImg: chatImg,
                roomName: roomname,
                groupUserData: (res['data'][i]['users'] as List)
                    ?.map((i) => GroupUserData.fromJson(i))
                    ?.toList()));
          }
          // print("/*/*/*/*/*/*/*/*/*/*/*/*/");
          // print(temp[0]);
          // print("/*/*/*/*/*/*//*/*/*/*/*/*");
          _chatgroupList = temp;
          temp = null;
          notifyListeners();
        } else {
          print(res);
        }
      } catch (err) {
        print("hutttooooooooooooooooooooooooooooooooooooooooooooooooooo");
        print(err);
      }
    });

    roomSocket.on('updateChatRoomList', (data) {
      roomSocket.emit('getChatRoomList', _userModel.id);
    });

    //invoke if any user get online or offline
    roomSocket.on('onOnlineUserListUpdate', (res) {
      //list of Users Online
      List dataOnline = res;
      //is list length = 0 mean there no users online make all offline
      if (dataOnline.length == 0) {
        _chatgroupList.forEach((user) {
          user.isOnline = false;
        });
        notifyListeners();
      } else {
        _chatgroupList.forEach((user) {
          // if (res.contains(user.userId)) {
          //   user.isOnline = true;
          // } else {
          //   user.isOnline = false;
          // }
        });
        notifyListeners();
      }
    });
  }
}
