//created by Suthura


class ConversionModel {
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

  ConversionModel(
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
      this.roomAdminId});
}
