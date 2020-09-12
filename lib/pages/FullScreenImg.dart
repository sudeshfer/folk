//created by Suthura

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:folk/providers/Theme_provider.dart';

// ignore: must_be_immutable
class FullScreenImg extends StatelessWidget {
  String imgUrl;

  FullScreenImg(this.imgUrl);

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);
    return Scaffold(
      //  backgroundColor: theme.getThemeData.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Full image View'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                showDialog(
                    context: (context),
                    builder: (context) {
                      return AlertDialog(
                        content: InkWell(
                            onTap: () {
                              // checkPermissions(context);
                              GallerySaver.saveImage(imgUrl)
                                  .then((bool success) {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: 'image saved to your gallery !');
                              });
                            },
                            child: Text('save image to gallery')),
                      );
                    });
              })
        ],
      ),
      body: SafeArea(
        child: Center(
          child: PhotoView(
            imageProvider: NetworkImage(imgUrl),
          ),
        ),
      ),
    );
  }

  // void checkPermissions(BuildContext context) async {

  //     if (await Permission.storage.request().isGranted) {
  //       GallerySaver.saveImage(imgUrl).then((bool success) {
  //         Navigator.pop(context);
  //         Fluttertoast.showToast(msg: 'image saved to your gallery !');
  //       });

  //     }else{
  //       PermissionStatus status=  await Permission.storage.request();
  //       if(status.isGranted){
  //         GallerySaver.saveImage(imgUrl).then((bool success) {
  //           Navigator.pop(context);
  //           Fluttertoast.showToast(msg: 'image saved to your gallery !');
  //         });
  //       }else{
  //         Fluttertoast.showToast(msg: 'you must accept Permission to save img ! ');
  //       }

  //     }

  // }
}
