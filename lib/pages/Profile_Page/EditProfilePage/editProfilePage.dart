import 'package:flutter/material.dart';
import 'package:folk/pages/Profile_Page/EditProfilePage/editProfile.dart';
// import 'package:folk/widgets/postPage.dart';


class EditProfilePage extends StatefulWidget {
  List catlist;
  EditProfilePage({this.catlist});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: new Text("Edit Profile"),
        leading: IconButton(
            icon: Icon(Icons.keyboard_backspace),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        textTheme: TextTheme(
            title: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        )),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: EditProfile(catlist:widget.catlist),
    );
  }
}
