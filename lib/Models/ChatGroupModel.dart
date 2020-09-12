class ChatGroupModel {
  String chatId;
  String userName;
  String token;
  String userImg;
  String userId;
  String lastMessage;
  bool isOnline;
  bool isLastMessageSeen;
  bool isTwoUsersSeeLastMessage;
  String imagesource;
  String fb_url;
  String timeStamp;
  String chatRoomImg;
  String roomName;
  String roomAdminId;
  List<GroupUserData> groupUserData;

  ChatGroupModel(
      {this.chatId,
      this.userName,
      this.isTwoUsersSeeLastMessage,
      this.token,
      this.userImg,
      this.userId,
      this.lastMessage,
      this.isOnline,
      this.isLastMessageSeen,
      this.imagesource,
      this.fb_url,
      this.timeStamp,
      this.chatRoomImg,
      this.roomName,
      this.roomAdminId,
      this.groupUserData});
}

class GroupUserData {
  String userid;
  String username;
  String img;
  String token;
  String imagesource;
  String fb_url;

  GroupUserData({this.userid, this.username});

  GroupUserData.fromJson(Map<String, dynamic> json) {
    userid = json['_id'];
    username = json['user_name'];
    img = json['img'];
    token = json['token'];
    imagesource = json['imagesource'];
    fb_url = json['fb_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.userid;
    data['user_name'] = this.username;
    data['img'] = this.img;
    data['token'] = this.token;
    data['imagesource'] = this.imagesource;
    data['fb_url'] = this.fb_url;
    return data;
  }
}
