//created by Suthura


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPostAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _AddPostAppBarState createState() => _AddPostAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AddPostAppBarState extends State<AddPostAppBar> {
  final double minValue = 8.0;
  final double iconSize = 25.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.arrow_back,
                            size: iconSize,
                          ))),
                ],
              ),
              Divider(
                thickness: .5,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
