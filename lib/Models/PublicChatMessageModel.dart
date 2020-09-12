class EventChatMessageModel {
  String id;
  String message;
  String senderName;
  String senderImg;
  String senderId;
  String roomId;
  bool isJoin;

  EventChatMessageModel(
      {this.id,
      this.message,
      this.senderName,
      this.senderImg,
      this.isJoin = false,
      this.senderId,
      this.roomId});
}
