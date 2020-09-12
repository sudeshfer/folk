//created by Suthura


import 'package:flutter/foundation.dart';
import 'package:folk/models/SubCommentModel.dart';

class CommentsModel {
  String comment;
  String id;
  String postId;
  String userName;
  String userId;
  String userImg;
  String imagesource;
  String bday;
  String postOwnerId;
  int timeStamp;
  bool isUserLiked;
  int commentLikes;
  List<SubCommentsModel> subcomments;

  CommentsModel(
      {@required this.id,
      this.comment,
      this.postId,
      this.userName,
      this.userId,
      this.userImg,
      this.imagesource,
      this.bday,
      this.postOwnerId,
      this.timeStamp,
      this.isUserLiked,
      this.commentLikes,
      this.subcomments});
}
