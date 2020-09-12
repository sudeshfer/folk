import 'dart:convert';
import 'package:flutter/foundation.dart';

class EventModel with ChangeNotifier {
  String id;
  String eventOwnerId;
  String eventData;
  int postLikes;
  bool hasImg;
  bool isUserLiked;
  String foodcategory;
  String userName;
  String postImg;
  int timeStamp;
  String eventDate;
  String title;
  String address;
  String createdAt;
  String img;
  String expDate;
  double latitude;
  double longitute;
  String typology;
  String userbday;
  String imagesource;
  String fb_url;
  int ownerfollowercount;
  int maxParticipantCount;
  int minage;
  int maxage;
  int joinedCount;
  bool isUserJoined;
  String roomId;

  EventModel(
      {this.id,
      this.eventOwnerId,
      this.eventData,
      this.postLikes,
      this.hasImg,
      this.isUserLiked,
      this.foodcategory,
      this.userName,
      this.postImg,
      this.timeStamp,
      this.eventDate,
      this.title,
      this.address,
      this.img,
      this.createdAt,
      this.expDate,
      this.latitude,
      this.longitute,
      this.typology,
      this.userbday,
      this.imagesource,
      this.fb_url,      // this.postCats,
      this.ownerfollowercount,
      this.maxParticipantCount,
      this.minage,
      this.maxage,
      this.joinedCount,
      this.isUserJoined,
      this.roomId
      });

  EventModel.fromJson(Map<String, dynamic> map)
      : id = map['_id'],
        eventData = map['post_data'],
        postLikes = map['likes'],
        postImg = map['post_img'],
        isUserLiked = map['isUserLiked'],
        foodcategory = map['foodcategory'],
        eventDate = map['event_date'],
        img = map['user_id'][0]['img'][0],
        eventOwnerId = map['user_id'][0]['_id'][0],
        userName = map['user_id'][0]['user_name'][0],
        userbday = map['user_id'][0]['bday'][0],
        imagesource = map['user_id'][0]['imagesource'][0],
        fb_url = map['user_id'][0]['fb_url'][0],
        ownerfollowercount = map['user_id'][0]['followercount'][0],
        title = map['title'],
        typology = map['typology'],
        latitude = map["geometry"]["coordinates"][0],
        longitute = map["geometry"]["coordinates"][1],
        address = map['address'],
        maxParticipantCount = map['maxparticipants'],
        minage = map['minage'],
        maxage = map['maxage'],
        hasImg = map['has_img'],
        timeStamp = map['created'],
        createdAt = map['createdAt'],
        expDate = map['exp_date'],
        joinedCount = map['joinedCount'],
        isUserJoined = map['isUserJoined'],
        roomId = map['room_id'];

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

// class PostCatModel {
//   String catID;
//   String catName;

//   PostCatModel({@required this.catID, this.catName});

//   PostCatModel.fromJson(Map<String, dynamic> json) {
//     catID = json['catID'];
//     catName = json['catName'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['catID'] = this.catID;
//     data['catName'] = this.catName;
//     return data;
//   }
// }
