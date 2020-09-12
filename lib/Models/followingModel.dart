import 'package:flutter/foundation.dart';

class FollowingModel with ChangeNotifier {
  String id;
  String img;
  String followerUserId;
  String name;
  String userbday;
  String imagesource;
  String fb_url;
  int userfollowercount;
  bool isUserFollowed;
  bool isUserRequested;
  String token;

  FollowingModel(
      {this.id,
      this.followerUserId,
      this.isUserRequested,
      this.name,
      this.img,
      this.userbday,
      this.imagesource,
      this.fb_url, 
      this.userfollowercount,
      this.isUserFollowed,
      this.token
      });

  FollowingModel.fromJson(Map<String, dynamic> map)
      : id = map['_id'],
        isUserRequested = map['user_id']['isUserRequested'][0],
        img = map['user_id']['img'][0],
        followerUserId = map['user_id']['_id'][0],
        name = map['user_id']['user_name'][0],
        userbday = map['user_id']['bday'][0],
        imagesource = map['user_id']['imagesource'][0],
        fb_url = map['user_id']['fb_url'][0],
        userfollowercount = map['user_id']['followercount'][0],
        isUserFollowed = map['user_id']['isUserFollowed'][0],
        token = map['user_id']['token'][0];
}
