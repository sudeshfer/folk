class PublicRoomsModel {
  String id;
  String roomName;
  String img;
  int createdTime;


  PublicRoomsModel({this.id, this.roomName, this.img, this.createdTime});

  PublicRoomsModel.fromJson(Map<String, dynamic> map)
      : id = map['_id'],
        roomName = map['room_name'],
        img = map['img'],
        createdTime = map['created'];
}
