//created by Suthura


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:path/path.dart' as Path;
import 'package:async/async.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:folk/utils/Constants.dart';

class UpdateUserInfo extends StatefulWidget {
  @override
  _UpdateUserInfoState createState() => _UpdateUserInfoState();
}

class _UpdateUserInfoState extends State<UpdateUserInfo> {
  UserModel userModel;

  var userNameController = TextEditingController();
  var bioController = TextEditingController();
  int currentLoading = 0;
  @override
  void initState() {
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    userNameController.text = userModel.name;
    bioController.text = userModel.bio;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.getThemeData.backgroundColor,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text('${userModel.name}'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
              child: Column(

                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),

                  InkWell(
                    onTap: () {
                      startPikUpImage(1);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: CachedNetworkImage(
                        imageUrl: Constants.USERS_PROFILES_URL + userModel.img,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                        placeholder: (d, d2) {
                          return Center(
                            child: Container(
                                padding: EdgeInsets.all(70),
                                child: CircularProgressIndicator()),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),



                  _entryField('name', userNameController),
                  _entryField('Bio', bioController),
                  SizedBox(
                    height: 20,
                  ),
                  currentLoading == 0 ? _submitButton() : progress,
                ],
              ))),
    );
  }

  Widget _entryField(String title, controller, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              obscureText: isPassword,
              decoration:
              InputDecoration(border: InputBorder.none, filled: true))
        ],
      ),
    );
  }

  void startPikUpImage(int type) async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality:50 );
    if (file != null) {
      _cropImage(file);

    }

  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        setState(() {
          currentLoading = 1;
        });
        startUpdate();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Update',
          style: TextStyle(fontSize: 20, color: Colors.white),
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

  void startUpdate() async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      var response = await http.post(
        '${Constants.SERVER_URL}user/update_bio_and_name',
        body: {
          'user_id': userModel.id,
          'user_name': '${userNameController.text}',
          'bio': '${bioController.text}'
        },
      );
      var jsonResponse = await convert.jsonDecode(response.body);
      bool error = jsonResponse['error'];
      if (error) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('${jsonResponse['data']}'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('close'))
                ],
              );
            });
      } else {
        String bio = jsonResponse['bio'];
        String userName = jsonResponse['user_name'];

        Provider.of<AuthProvider>(context, listen: false)
            .updateUserNameAndBio(userName, bio);
        Fluttertoast.showToast(msg: 'Done');
      }
    } catch (err) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('check your internet connection'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('close'))
              ],
            );
          });
    } finally {
      setState(() {
        currentLoading = 0;
      });
    }
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userNameController.dispose();
    bioController.dispose();
  }

  Future<Null> _cropImage(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      compressQuality: 50,
      compressFormat:ImageCompressFormat.png ,
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX:1,ratioY: 1),
      aspectRatioPresets: Platform.isAndroid
          ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ]
          : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    if (croppedFile != null) {

        startUpladImg(croppedFile);

    }
  }

  void startUpladImg(File imageFile) async{
    String _url = '${Constants.SERVER_URL}user/img';

    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(_url);
    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile('img', stream, length,
        filename: Path.basename(imageFile.path));
    request.files.add(multipartFile);
    request.fields.addAll({
      "user_id": "${userModel.id}",
    });
    var response = await request.send();

    response.stream.transform(convert.utf8.decoder).listen((value) async {
      try {
        var jsonResponse = await convert.jsonDecode(value);
        bool error = jsonResponse['error'];
        if (error == false) {
          Fluttertoast.showToast(
              msg: "img uploaded",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
          Provider.of<AuthProvider>(context, listen: false)
              .updateImg(jsonResponse['data']);
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

        Fluttertoast.showToast(
            msg: "unkown error ! check your connection",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
