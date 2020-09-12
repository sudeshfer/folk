//created by Suthura


import 'dart:io';
import 'package:folk/pages/HomePage/Home.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:async/async.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:folk/utils/Constants.dart';

// ignore: must_be_immutable
class CompleteSignUpPage extends StatefulWidget {
  String id;

  CompleteSignUpPage(this.id);

  @override
  _CompleteSignUpPageState createState() => _CompleteSignUpPageState();
}

class _CompleteSignUpPageState extends State<CompleteSignUpPage> {
  File imageFile;
  String fileName;
  int currentLoading = 0;
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => Home()),
                    (Route<dynamic> route) => false);
              },
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => Home()),
                      (Route<dynamic> route) => false);
                },
                child: Text(
                  'Skip',
                ),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 90,
              ),
              InkWell(
                onTap: () {
                  startImagePicker();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: imageFile != null
                      ? Image.file(
                    imageFile,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          '${Constants.SERVER_IMAGE_URL}uploads/users_profile_img/default-user-profile-image.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Bio',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: bioController,
                        decoration: InputDecoration(
                            border: InputBorder.none, filled: true))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              currentLoading == 0 ? _submitButton() : progress,
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

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (imageFile == null && bioController.text.isEmpty) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Home()),
              (Route<dynamic> route) => false);
        } else {
          setState(() {
            currentLoading = 1;
          });

          if (imageFile == null) {
            startUpdateBioOnly();
          } else {
            startUploadImgAndBio();
          }
        }
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
          'Next',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  void startUploadImgAndBio() async {
    String _url = '${Constants.SERVER_URL}user/img';

    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(_url);
    var request = new http.MultipartRequest("POST", uri);
    var bioText =
        "${bioController.text.isEmpty ? 'Hi iam using V Chat App' : '${bioController.text}'}";
    var multipartFile = new http.MultipartFile('img', stream, length,
        filename: Path.basename(imageFile.path));
    request.files.add(multipartFile);
    request.fields.addAll({
      "user_id": "${widget.id}",
      "bio": bioText,
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

          Provider.of<AuthProvider>(context, listen: false).updateBio(bioText);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => Home()),
              (Route<dynamic> route) => false);
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
      } finally {
        setState(() {
          currentLoading = 0;
        });
      }
    });
  }

  void startImagePicker() async {
    imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    _cropImage();
  }
  Future<Null> _cropImage() async {
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
      setState(() {
        imageFile = croppedFile;
      });


    }
  }

  void startUpdateBioOnly() async {
    try {
      var bioText =
          "${bioController.text.isEmpty ? 'Hi iam using V Chat App' : '${bioController.text}'}";
      await http.post('${Constants.SERVER_URL}user/update_bio', body: {
        'user_id': widget.id,
        "bio": bioText,
      });
      Provider.of<AuthProvider>(context, listen: false).updateBio(bioText);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Home()),
          (Route<dynamic> route) => false);
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
    } finally {
      setState(() {
        currentLoading = 0;
      });
    }
  }
}
