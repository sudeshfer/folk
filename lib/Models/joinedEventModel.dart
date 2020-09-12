import 'dart:convert';
import 'package:flutter/foundation.dart';

class JoinedEventModel with ChangeNotifier {
  String id;
  String eventOwnerId;
  String eventData;
  int postLikes;
  bool hasImg;
  bool isUserLiked;
  String foodcategory;
  String postImg;
  int timeStamp;
  String eventDate;
  String title;
  String address;
  String createdAt;
  double latitude;
  double longitute;
  String typology;
  int maxParticipantCount;
  int minage;
  int maxage;
  int joinedCount;
  bool isUserJoined;
  String roomId;

  String name;
  String bday;
  int followercount;
  String img;
  
  String fb_url;

  String imagesource;

  JoinedEventModel(
      {this.id,
      this.eventOwnerId,
      this.eventData,
      this.postLikes,
      this.hasImg,
      this.isUserLiked,
      this.foodcategory,
      this.postImg,
      this.timeStamp,
      this.eventDate,
      this.title,
      this.address,
      this.createdAt,
      this.latitude,
      this.longitute,
      this.typology,
      this.maxParticipantCount,
      this.minage,
      this.maxage,
      this.joinedCount,
      this.isUserJoined,
      this.roomId,
      this.name,
      this.bday,
      this.followercount,
      this.img,
      this.fb_url,
      this.imagesource});

  JoinedEventModel.fromJson(Map<String, dynamic> map)
      : id = map['event_id'][0]['_id'],
        eventData = map['event_id'][0]['post_data'],
        postLikes = map['event_id'][0]['likes'],
        joinedCount = map['event_id'][0]['joinedCount'],
        postImg = map['event_id'][0]['post_img'],
        isUserLiked = map['event_id'][0]['isUserLiked'],
        isUserJoined = map['event_id'][0]['isUserJoined'],
        foodcategory = map['event_id'][0]['foodcategory'],
        eventDate = map['event_id'][0]['event_date'],
        eventOwnerId = map['event_id'][0]['user_id'],
        title = map['event_id'][0]['title'],
        typology = map['event_id'][0]['typology'],
        latitude = map['event_id'][0]["geometry"]["coordinates"][0],
        longitute = map['event_id'][0]["geometry"]["coordinates"][1],
        address = map['event_id'][0]['address'],
        maxParticipantCount = map['event_id'][0]['maxparticipants'],
        minage = map['event_id'][0]['minage'],
        maxage = map['event_id'][0]['maxage'],
        hasImg = map['event_id'][0]['has_img'],
        roomId = map['event_id'][0]['room_id'],
        timeStamp = map['event_id'][0]['created'],
        createdAt = map['event_id'][0]['createdAt'],
        name = map['user_id'][0]['user_name'],
        bday = map['user_id'][0]['bday'],
        followercount = map['user_id'][0]['followercount'],
        img = map['user_id'][0]['img'],
        fb_url = map['user_id'][0]['fb_url'],
        imagesource = map['user_id'][0]['imagesource'];

  String toJson() {
    Map<String, dynamic> temp = {};

    temp['user_id'] = this.eventOwnerId;

    temp['post_data'] = this.eventData;

    temp['post_img'] = this.postImg;

    print("************");
    print(temp);

    return jsonEncode(temp);
  }
}
