import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/utils/Constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:folk/models/UserModel.dart';

class PhotoBoxFive extends StatefulWidget {
  final double width;
  final double height;
  final String imgPath;

  PhotoBoxFive(
      {this.width,
      this.height,
      this.imgPath = "assets/images/btn_upload_cover_square.png"});

  @override
  _PhotoBoxFiveState createState() => _PhotoBoxFiveState();
}

class _PhotoBoxFiveState extends State<PhotoBoxFive> {
  File imageFile;
  UserModel userModel;
  bool isUploadFnished = true;
  bool isDeleteImgFinished = true;

  @override
  void initState() {
    // TODO: implement initState
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    setState(() {
      isDeleteImgFinished = true;
      isUploadFnished = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (userModel.img5 == null || userModel.img5 == "default-user-profile-image.png") ? Colors.white : Colors.grey[100]),
          child: (userModel.img5 == null || userModel.img5 == "default-user-profile-image.png")
              //No img selected and camera logo is shown
              ? isUploadFnished ?ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.grey[100],
                      onTap: () {
                        print("Photo Pick Button pressed");
                        _showChoiceDialog(context);
                        
                        print(userModel.id);
                      },
                      child: Image(
                        image: AssetImage(widget.imgPath),
                      ),
                    ),
                  ),
                )
                : Center(
                            child: Container(
                                // padding: EdgeInsets.all(70),
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.orange,
                                  strokeWidth: 3,
                                )),
                          )
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    InkWell(
                      onTap: (){
                        print(userModel.img5);
                      },
                                          child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          child: isDeleteImgFinished?CachedNetworkImage(
                          imageUrl: Constants.USERS_PROFILES_URL + userModel.img5,
                          fit: BoxFit.cover,
                          placeholder: (d, d2) {
                            return Center(
                              child: Container(
                                  // padding: EdgeInsets.all(70),
                                  child: CircularProgressIndicator()),
                            );
                          },
                        )
                        :Center(
                            child: Container(
                                // padding: EdgeInsets.all(70),
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.orange,
                                  strokeWidth: 3,
                                )),
                          )
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          print("Delete Button Pressed");
                         startDeleteImg();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: Image(
                              image: AssetImage("assets/images/btn_close.png"),
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  _openGallery(BuildContext context,int type) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality:50);
    this.setState(() {
      imageFile = picture;
    });

    if(imageFile != null){
      setState(() {
       isUploadFnished = false;
     });
      _cropImage(imageFile);
    }
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context,int type) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality:50);
    this.setState(() {
      imageFile = picture;
    });

    if(imageFile != null){
      setState(() {
       isUploadFnished = false;
     });
      _cropImage(imageFile);
    }
    Navigator.of(context).pop();
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

  print("workingggggggggggggggggggggggggggggggggggggggg");
        startUplodImg(croppedFile);

    }
  }

    void startUplodImg(File imageFile) async{
    
    String _url = '${Constants.SERVER_URL}user/img5';

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
              .updateImg5(jsonResponse['data']);
              setState(() {
                isUploadFnished = true;
              });

        } else {
          print('error! ' + jsonResponse);
          setState(() {
                isUploadFnished = true;
              });
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
        setState(() {
                isUploadFnished = true;
              });
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

  void startDeleteImg() async {
    // await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isDeleteImgFinished = false;
    });
    try {
      var response = await http.post(
        '${Constants.SERVER_URL}user/remUserImg5',
        body: {
          'user_id': userModel.id,
        },
      );
      var jsonResponse = await convert.jsonDecode(response.body);
      bool error = jsonResponse['error'];
      if (error) {
        setState(() {
      isDeleteImgFinished = false;
    });
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
        // String bio = jsonResponse['bio'];
        String defaultimg = "default-user-profile-image.png";

        Provider.of<AuthProvider>(context, listen: false)
            .updateImg5(defaultimg);
            setState(() {
      isDeleteImgFinished = false;
    });
        // Fluttertoast.showToast(msg: 'Bio is Updated');
      }
    } catch (err) {
      setState(() {
      isDeleteImgFinished = false;
    });
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
      isDeleteImgFinished = false;
    });
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a source',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Select a content',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _openGallery(context,1);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              spreadRadius: 0.5,
                              blurRadius: 10,
                              offset: Offset(
                                -2,
                                10,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Container(
                            child: Image.asset(
                              'assets/images/fromGallery.png',
                              height: MediaQuery.of(context).size.height / 12,
                              // width: MediaQuery.of(context).size.width / 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _openCamera(context,1);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              spreadRadius: 0.5,
                              blurRadius: 10,
                              offset: Offset(
                                -2,
                                10,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Container(
                            child: Image.asset(
                              'assets/images/fromCamera.png',
                              height: MediaQuery.of(context).size.height / 12,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
