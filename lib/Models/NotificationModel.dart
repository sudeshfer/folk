class NotificationModel {
  String id;
  String name;
  String title;
  String userImg;
  String imagesourse;
  String postId;
  String peerId;
  int timeStamp;
  String notifContent;
  bool isread;
  String notificationType;

  NotificationModel(
      {this.id,
      this.name,
      this.title,
      this.userImg,
      this.imagesourse,
      this.postId,
      this.peerId,
      this.timeStamp,
      this.notifContent,
      this.isread,
      this.notificationType});

  NotificationModel.fromJson(Map<String, dynamic> map)
      : id = map['_id'],
        userImg = map['userImg'],
        imagesourse = map['imagesource'],
        title = map['title'],
        peerId = map['notif_to_user'],
        postId = map['postId'],
        timeStamp = map['created'],
        notifContent = map['notifMessage'],
        isread = map['isread'],
        notificationType = map['notificationType'],
        name = map['name'];
}
