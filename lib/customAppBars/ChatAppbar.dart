//created by Suthura
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:folk/pages/PeerProfile.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:folk/pages/Profile_Page/landlord_profile.dart';

// ignore: must_be_immutable
class ChatAppbar extends StatefulWidget implements PreferredSizeWidget {
  String peerImg;
  String peerName;
  String peerId;
  bool isOnline;
  final _profile;

  ChatAppbar(
      this.peerId, this.peerImg, this.isOnline, this.peerName, this._profile);

  @override
  _ChatAppbarState createState() => _ChatAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _ChatAppbarState extends State<ChatAppbar> {
  final double minValue = 8.0;
  final double iconSize = 25.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 27,
              )),
          SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (_) => PeerProfile(widget.peerId)));
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      LandlordProfile(postOwnerId: widget._profile.id)));
              print("${widget._profile.imagesource}");
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: CachedNetworkImage(
                imageUrl: widget._profile.imagesource == 'fb'? widget._profile.fb_url:
                          Constants.USERS_PROFILES_URL + widget._profile.userImg,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
              ),
            ),
          ),
          SizedBox(
            width: 6,
          ),
          InkWell(
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      LandlordProfile(postOwnerId: widget._profile.id)));
            },
            child: Container(
              height: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    '${widget.peerName}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  // Text(widget.isOnline ? 'ONLINE' : 'OFFLINE',
                  //     style:
                  //         TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          )
        ],
      ),

      // backgroundColor: themeProvider.getThemeData.backgroundColor,
      elevation: 1,
    );
  }
}
