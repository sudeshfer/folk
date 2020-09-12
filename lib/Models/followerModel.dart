import 'package:flutter/foundation.dart';

class FollowerModel with ChangeNotifier {
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

  FollowerModel(
      {this.id,
      this.followerUserId,
      this.isUserRequested,
      this.name,
      this.img,
      this.userbday,
      this.imagesource,
      this.fb_url, 
      this.userfollowercount,
      this.isUserFollowed
      });

  FollowerModel.fromJson(Map<String, dynamic> map)
      : id = map['_id'],
        isUserRequested = map['user_id'][0]['isUserRequested'][0],
        img = map['user_id'][0]['img'][0],
        followerUserId = map['user_id'][0]['_id'][0],
        name = map['user_id'][0]['user_name'][0],
        userbday = map['user_id'][0]['bday'][0],
        imagesource = map['user_id'][0]['imagesource'][0],
        fb_url = map['user_id'][0]['fb_url'][0],
        userfollowercount = map['user_id'][0]['followercount'][0],
        isUserFollowed = map['user_id'][0]['isUserFollowed'][0];
}
