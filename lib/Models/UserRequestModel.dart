import 'package:flutter/foundation.dart';

class UserRequestsModel with ChangeNotifier {
  String id;
  String followerID;
  String name;
  String bday;
  int followercount;
  String img;
  String fb_url;
  String imagesource;
  bool isShowing;
  UserRequestsModel(
      {this.id,
      this.followerID,
      this.name,
      this.bday,
      this.followercount,
      this.img,
      this.fb_url,
      this.imagesource,
      this.isShowing});

  UserRequestsModel.fromJson(Map<String, dynamic> map)
      : id = map['_id'],
        followerID = map['user_id'][0]['_id'][0],
        name = map['user_id'][0]['user_name'][0],
        bday = map['user_id'][0]['bday'][0],
        followercount = map['user_id'][0]['followercount'][0],
        img = map['user_id'][0]['img'][0],
        fb_url = map['user_id'][0]['fb_url'][0],
        imagesource = map['user_id'][0]['imagesource'][0],
        isShowing = true;
}
