import 'package:flutter/foundation.dart';

import 'package:folk/models/ConversionModel.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/utils/Constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ConversionProvider with ChangeNotifier {
  UserModel _userModel;

  List<ConversionModel> _conversionList = [];

  List<ConversionModel> get conversionList => _conversionList;

  bool isPeerSeeLastMessage = false;

  void setIsPeerSeeLastMessage(bool value) {
    isPeerSeeLastMessage = value;
    notifyListeners();
  }

  initConversionSocketAndRequestChats(UserModel userModel) {
    this._userModel = userModel;
    var url = '${Constants.SOCKET_URL}/api/chatRoomList';

    io.Socket roomSocket = io.io('$url', <String, dynamic>{
      'transports': ['websocket']
    });

    roomSocket.on('connect', (_) {
      //send request to server to ge messages
      roomSocket.emit('getConversionsList', userModel.id);
    });

    roomSocket.on('ConversionsListReady', (res) {
      // once server send Conversions
      try {
        if (!res['error']) {

          //if user id in _listOnlineUsers make this user Online else offline
          List<dynamic> _listOnlineUsers = res['onLineUsersId'];
          var listData = res['data'];
          List<ConversionModel> temp = [];

          for (int i = 0; i < listData.length; i++) {
            String userOne = res['data'][i]['users'][0]['_id'];
            String chatId = res['data'][i]['_id'];
            String time = res['data'][i]['updatedAt'];

            int indexOfPeerUser = 0;
            if (userOne == _userModel.id) {
              indexOfPeerUser = 1;
            } else {
              indexOfPeerUser = 0;
            }
            var userModel = res['data'][i]['users'][indexOfPeerUser];
            temp.add(ConversionModel(
                chatId: chatId,
                userName: userModel['user_name'],
                token: userModel['token'],
                userImg: userModel['img'],
                userId: userModel['_id'],
                imagesource: userModel['imagesource'],
                fb_url: userModel['fb_url'],
                timeStamp: time,
                lastMessage: res['data'][i]['lastMessage']['message'],
                isOnline: _listOnlineUsers.contains(userModel['_id']),
                isTwoUsersSeeLastMessage:
                    res['data'][i]['lastMessage']['users_see_message'].length ==
                        2,
                isLastMessageSeen: res['data'][i]['lastMessage']
                        ['users_see_message']
                    .contains(_userModel.id)));
          }
          _conversionList = temp;
          temp = null;
          notifyListeners();
        } else {
          print(res);
        }
      } catch (err) {
        print(err);
      }
    });

    roomSocket.on('updateChatRoomList', (data) {
      roomSocket.emit('getConversionsList', _userModel.id);
    });

    //invoke if any user get online or offline
    roomSocket.on('onOnlineUserListUpdate', (res) {
      //list of Users Online
      List dataOnline = res;
      //is list length = 0 mean there no users online make all offline
      if (dataOnline.length == 0) {
        _conversionList.forEach((user) {
          user.isOnline = false;
        });
        notifyListeners();
      } else {
        _conversionList.forEach((user) {
          if (res.contains(user.userId)) {
            user.isOnline = true;
          } else {
            user.isOnline = false;
          }
        });
        notifyListeners();
      }
    });
  }

  //   initChatGroupSocketAndRequestChats(UserModel userModel) {
      
  //   this._userModel = userModel;
  //   var url = '${Constants.SOCKET_URL}/api/chatRoomList';

  //   io.Socket roomSocket = io.io('$url', <String, dynamic>{
  //     'transports': ['websocket']
  //   });
  
  //   roomSocket.on('connect', (_) {
  //     //send request to server to ge messages
  //     roomSocket.emit('getChatRoomList', userModel.id);
  //   });
  //  print("workinggggggggggggggggggggggggggggggggggggg");
  //   roomSocket.on('ChatListReady', (res) {
      
  //     print(res['data']);
  //     // once server send Conversions
  //     try {
  //       if (!res['error']) {
         
  //         //if user id in _listOnlineUsers make this user Online else offline
  //         List<dynamic> _listOnlineUsers = res['onLineUsersId'];
  //         var listData = res['data'];
  //         print(listData);
  //         List<ConversionModel> temp = [];

  //         for (int i = 0; i < listData.length; i++) {
  //           String userOne = res['data'][i]['users'][0]['_id'];
  //           String chatId = res['data'][i]['_id'];
  //           String time = res['data'][i]['updatedAt'];
  //           String chatImg = res['data'][i]['img'];
  //           String roomname = res['data'][i]['room_name'];

  //           int indexOfPeerUser = 0;
  //           if (userOne == _userModel.id) {
  //             indexOfPeerUser = 1;
  //           } else {
  //             indexOfPeerUser = 0;
  //           }
  //           var userModel = res['data'][i]['users'][indexOfPeerUser];
  //           temp.add(ConversionModel(
  //               chatId: chatId,
  //               userName: userModel['user_name'],
  //               token: userModel['token'],
  //               userImg: userModel['img'],
  //               userId: userModel['_id'],
  //               imagesource: userModel['imagesource'],
  //               fb_url: userModel['fb_url'],
  //               timeStamp: time,
  //               chatRoomImg: chatImg,
  //               roomName: roomname,
  //           ));
  //         }
  //         _chatgroupList = temp;
  //         temp = null;
  //         notifyListeners();
  //       } else {
  //         print(res);
  //       }
  //     } catch (err) {
  //       print(err);
  //     }
  //   });

  //   roomSocket.on('updateChatRoomList', (data) {
  //     roomSocket.emit('getChatRoomList', _userModel.id);
  //   });

  //   //invoke if any user get online or offline
  //   roomSocket.on('onOnlineUserListUpdate', (res) {
  //     //list of Users Online
  //     List dataOnline = res;
  //     //is list length = 0 mean there no users online make all offline
  //     if (dataOnline.length == 0) {
  //       _chatgroupList.forEach((user) {
  //         user.isOnline = false;
  //       });
  //       notifyListeners();
  //     } else {
  //       _chatgroupList.forEach((user) {
  //         // if (res.contains(user.userId)) {
  //         //   user.isOnline = true;
  //         // } else {
  //         //   user.isOnline = false;
  //         // }
  //       });
  //       notifyListeners();
  //     }
  //   });
  // }
}
