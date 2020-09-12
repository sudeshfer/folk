class PublicChatMessageModel {
  String id;
  String message;
  String senderName;
  String senderImg;
  String senderId;
  String roomId;
  bool isJoin;
  int dateTime;
  String imageSource;

  PublicChatMessageModel(
      {this.id,
      this.message,
      this.senderName,
      this.senderImg,
      this.isJoin = false,
      this.senderId,
      this.roomId,
      this.dateTime,
      this.imageSource});
}
