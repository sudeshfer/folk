//created by Suthura

import 'package:flutter/foundation.dart';

class SubCommentsModel {
  String comment;
  String id;
  String commentId;
  String userName;
  String userId;
  String userImg;
  String imagesource;
  String bday;
  String postOwnerId;
  int timeStamp;
  bool isUserLiked;
  int commentLikes;

  SubCommentsModel(
      {@required this.id,
      this.comment,
      this.commentId,
      this.userName,
      this.userId,
      this.userImg,
      this.imagesource,
      this.bday,
      this.postOwnerId,
      this.timeStamp,
      this.isUserLiked,
      this.commentLikes});

  SubCommentsModel.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    id = json['_id'];
    commentId = json['comment_id'];
    userName = json['user_name'];
    userId = json['user_id'];
    userImg = json['user_img'];
    imagesource = json['imagesource'];
    bday = json['bday'];
    postOwnerId = json['post_owner_id'];
    timeStamp = json['created'];
    isUserLiked = json['isUserLiked'];
    commentLikes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['_id'] = this.id;
    data['comment_id'] = this.commentId;
    data['user_name'] = this.userName;
    data['user_id'] = this.userId;
    data['user_img'] = this.userImg;
    data['imagesource'] = this.imagesource;
    data['bday'] = this.bday;
    data['post_owner_id'] = this.postOwnerId;
    data['created'] = this.timeStamp;
    data['isUserLiked'] = this.isUserLiked;
    data['likes'] = this.commentLikes;
    return data;
  }
}
