//created by Suthura


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/PostProvider.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:folk/customAppBars/AddPostAppBar.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var postDataController = TextEditingController();
  UserModel _userModel;
  int currentLoading = 0;
  File file;
  String fileName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    postDataController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);


    return Scaffold(
      backgroundColor: themeProvider.getThemeData.backgroundColor,
      appBar: AddPostAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    // user image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.network(
                        Constants.USERS_PROFILES_URL + _userModel.img,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    //user name and public,
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_userModel.name),
                        Text(
                          'public',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.start,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //Edit text
              Container(
                  color: themeProvider.getThemeData.dividerColor,
                  padding: new EdgeInsets.all(1.0),
                  child: new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      maxWidth: MediaQuery.of(context).size.width,
                      maxHeight: 120,
                    ),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: TextField(
                          controller: postDataController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 80),
                              border: UnderlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.grey.shade200)),
                              hintText: 'what is in your mind?',
                              hintStyle: TextStyle(fontSize: 14)),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        )),
                  )),

              SizedBox(
                height: 10,
              ),
              // photo
              Container(
                child: InkWell(
                  onTap: () {
                    startImagePicker();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.image,
                        size: 17,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'photos',
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),

              file == null
                  ? SizedBox(
                height: 100,
              )
                  : Stack(
                children: <Widget>[
                  Image.file(
                    file,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                  Positioned(
                      top: 3,
                      right: 3,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            file = null;
                          });
                        },
                        child: Text(
                          'X',
                          style: TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ))
                ],
              ),
              currentLoading == 0
                  ? _submitButton(themeProvider.getThemeData.dividerColor)
                  : progress
            ],
          ),
        ),
      ),
    );
  }

  Widget progress = Container(
    padding: EdgeInsets.symmetric(vertical: 15),
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      backgroundColor: Colors.green,
      strokeWidth: 7,
    ),
  );

  void startImagePicker() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 50);
    setState(() {});
  }

  Widget _submitButton(color) {
    return InkWell(
      onTap: () {
        setState(() {
          currentLoading = 1;
        });
        startAdd();
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: color,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'POST',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void startAdd() async {
    String _url = "${Constants.SERVER_URL}post/create";
    Fluttertoast.showToast(msg: 'posting ...');
    if (file != null) {
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var uri = Uri.parse(_url);
      var request = new http.MultipartRequest("POST", uri);

      var multipartFile = new http.MultipartFile('img', stream, length,
          filename: Path.basename(file.path));
      request.files.add(multipartFile);
      request.fields.addAll({
        "user_id": _userModel.id,
        "post_data": ' ${postDataController.text}',
      });
      var response = await request.send();

      response.stream.transform(convert.utf8.decoder).listen((value) async {
        try {
          var jsonResponse = await convert.jsonDecode(value);
          bool error = jsonResponse['error'];
          if (error == false) {
            Provider.of<PostProvider>(context, listen: false)
                .startGetPostsData(_userModel.id);
            Fluttertoast.showToast(msg: ' done ...');
            postDataController.clear();
            Navigator.pop(context);
          } else {
            print('error! ' + jsonResponse);

            Fluttertoast.showToast(
                msg: "unkown error !" + jsonResponse,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } catch (err) {
          print(err);
          print(value);
          Fluttertoast.showToast(
              msg: "unkown error ! check your connection",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } finally {
          setState(() {
            currentLoading = 0;
          });
        }
      });
    } else {
      try {
        var req = await http.post(_url, body: {
          'user_id': _userModel.id,
          'post_data': '${postDataController.text}'
        });

        var response = convert.jsonDecode(req.body);

        if (!response['error']) {
          Provider.of<PostProvider>(context, listen: false)
              .startGetPostsData(_userModel.id);
          Fluttertoast.showToast(msg: ' done ...');
          postDataController.clear();
          Navigator.pop(context);
        }
      } catch (err) {
        print(err);
        Fluttertoast.showToast(msg: ' error while upload ... $err');
      } finally {
        setState(() {
          currentLoading = 0;
        });
      }
    }
  }
}
