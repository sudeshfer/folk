//created by Suthura


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/CommentsModel.dart';
import 'package:folk/pages/PeerProfile.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:folk/utils/Constants.dart';

// ignore: must_be_immutable
class CommentItem extends StatefulWidget {
  CommentsModel commentsModel;

  CommentItem(this.commentsModel);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
  final theme =  Provider.of<ThemeProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PeerProfile(widget.commentsModel.userId)));
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Container(
              width: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0 * 4),
                child: CachedNetworkImage(
                  imageUrl: Constants.USERS_PROFILES_URL +
                      widget.commentsModel.userImg,
                  fit: BoxFit.cover,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    color: theme.getThemeData.brightness==Brightness.dark? Colors.white12:Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.only(top: 8, bottom: 8,left: 5,right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${widget.commentsModel.userName}',
                      style: GoogleFonts.roboto(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${widget.commentsModel.comment}',
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
