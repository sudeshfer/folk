//created by Suthura


import 'dart:convert';

class PeerProfileModel {
  int followercount;
  bool isUserFollowed;
  bool isUserRequested;
  String userName;
  String id;
  String email;
  String token;
  String gender;
  String bday;
  String img;
  String img2;
  String img3;
  String img4;
  String img5;
  String img6;
  String bio;
  String whatudo;
  String catString;
  String phoneNum;
  int timeStamp;
  String imagesource;
  String fb_url;
  List<UserInterests> userInterests;
   double latitude;
  double longitute;

  PeerProfileModel(
      {this.followercount,
      this.isUserFollowed,
      this.isUserRequested,
      this.id,
      this.userName,
      this.email,
      this.img,
      this.img2,
      this.img3,
      this.img4,
      this.img5,
      this.img6,
      this.timeStamp,
      this.token,
      this.gender,
      this.bday,
      this.bio,
      this.whatudo,
      this.catString,
      this.phoneNum,
      this.imagesource,
      this.userInterests,
      this.fb_url,
      this.latitude,
      this.longitute});

  PeerProfileModel.fromJson(Map<String, dynamic> map)
      : followercount = map['followercount'],
        isUserFollowed = map['isUserFollowed'],
        isUserRequested = map['isUserRequested'],
        userName = map['user_name'],
        id = map['_id'],
        bio = map['bio'],
        whatudo = map['whatudo'],
        token = map['token'],
        gender = map['gender'],
        bday = map['bday'],
        email = map['email'],
        img = map['img'],
        img2 = map['img2'],
        img3 = map['img3'],
        img4 = map['img4'],
        img5 = map['img5'],
        img6 = map['img6'],
        phoneNum = map['phone'],
        timeStamp = map['time_stamp'],
        imagesource = map['imagesource'],
        fb_url = map['fb_url'],
        latitude = map["geometry"]["coordinates"][0],
        longitute = map["geometry"]["coordinates"][1],
        userInterests = (map['interests'] as List)
            ?.map((i) => UserInterests.fromJson(i))
            ?.toList();

  String toJson(PeerProfileModel adminModel) {
    Map<String, dynamic> temp = {};
    temp['name'] = adminModel.userName;
    temp['_id'] = adminModel.id;
    temp['email'] = adminModel.email;
    temp['token'] = adminModel.token;
    temp['gender'] = adminModel.gender;
    temp['bday'] = adminModel.bday;
    temp['img'] = adminModel.img;

    return jsonEncode(temp);
  }
}

class UserInterests {
  String objectId;
  String interestname;
  String interestid;

  UserInterests({this.objectId, this.interestname, this.interestid});

  UserInterests.fromJson(Map<String, dynamic> json) {
    objectId = json['_id'];
    interestname = json['interestName'];
    interestid = json['interestID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.objectId;
    data['interestName'] = this.interestname;
    data['interestID'] = this.interestid;
    return data;
  }
}
