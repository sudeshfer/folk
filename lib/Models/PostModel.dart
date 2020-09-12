//created by Suthura

import 'dart:convert';

import 'package:flutter/foundation.dart';

class PostModel with ChangeNotifier {
  String id;
  String postOwnerId;
  String postData;
  int postLikes;
  int commentsCount;
  bool hasImg;
  bool isUserLiked;
  String userName;
  String postImg;
  int timeStamp;
  String createdAt;
  String img;
  String expDate;
  double latitude;
  double longitute;
  String typology;
  String userbday;
  String imagesource;
  String fb_url;
  List<PostCatModel> postCats;

  PostModel(
      {this.id,
      this.postOwnerId,
      this.postData,
      this.postLikes,
      this.commentsCount,
      this.hasImg,
      this.isUserLiked,
      this.userName,
      this.postImg,
      this.timeStamp,
      this.img,
      this.createdAt,
      this.expDate,
      this.latitude,
      this.longitute,
      this.typology,
      this.userbday,
      this.imagesource,
      this.fb_url,
      this.postCats});

  PostModel.fromJson(Map<String, dynamic> map)
      : id = map['_id'],
        postOwnerId = map['user_id'][0]['_id'][0],
        hasImg = map['has_img'],
        isUserLiked = map['isUserLiked'],
        postData = map['post_data'],
        postLikes = map['likes'],
        commentsCount = map['commentsCount'],
        createdAt = map['createdAt'],
        postImg = map['post_img'],
        timeStamp = map['created'],
        userName = map['user_id'][0]['user_name'][0],
        img = map['user_id'][0]['img'][0],
        expDate = map['exp_date'],
        latitude = map["geometry"]["coordinates"][0],
        longitute = map["geometry"]["coordinates"][1],
        typology = map['typology'],
        userbday = map['user_id'][0]['bday'][0],
        fb_url = map['user_id'][0]['fb_url'][0],
        imagesource = map['user_id'][0]['imagesource'][0],
        postCats = (map['category'] as List)
            ?.map((i) => PostCatModel.fromJson(i))
            ?.toList();

  String toJson() {
    Map<String, dynamic> temp = {};

    temp['user_id'] = this.postOwnerId;

    temp['post_data'] = this.postData;

    temp['post_img'] = this.postImg;

    print("************");
    print(temp);

    return jsonEncode(temp);
  }
}

class PostCatModel {
  String catID;
  String catName;

  PostCatModel({@required this.catID, this.catName});

  PostCatModel.fromJson(Map<String, dynamic> json) {
    catID = json['catID'];
    catName = json['catName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['catID'] = this.catID;
    data['catName'] = this.catName;
    return data;
  }
}
