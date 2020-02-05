import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:folk/Screens/Login/setup_step2.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class SetupStepOne extends StatefulWidget {
  final phone;
  final fbId;
  final fbName;
  final fbEmail;
  final fbPicUrl;
  final loginType;
  SetupStepOne(
      {Key key,
      this.title,
      this.phone,
      this.fbId,
      this.fbName,
      this.fbEmail,
      this.fbPicUrl,
       this.loginType})
      : super(key: key);

  final String title;

  @override
  _SetupStepOneState createState() => _SetupStepOneState();
}

class _SetupStepOneState extends State<SetupStepOne> {
  final _name = TextEditingController();
  String _errorName = "";
  File imageFile;

  //asynce function to pick an image from gallery
  _openGallery(BuildContext context) async{

    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(picture != null){
    File croppedFile = await ImageCropper.cropImage(
    sourcePath: picture.path,
    aspectRatioPresets: Platform.isAndroid
    ?[
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
    ]
    :[
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
         toolbarTitle: 'Crop Your photo',
          toolbarColor: Color(0xFFFF9006),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );
    
    this.setState((){
          //  imageFile = croppedFile;
           imageFile = croppedFile;

    });
    Navigator.of(context).pop();
    _showImg();
  }
    else{
      _showImg();
    }
  }
//asynce function to pick an image from camera
  _openCamera(BuildContext context) async{

    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    if(picture != null){
    File croppedFile = await ImageCropper.cropImage(
    sourcePath: picture.path,
    aspectRatioPresets: Platform.isAndroid
    ?[
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
    ]
    :[
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
         toolbarTitle: 'Crop Yor Photo',
          toolbarColor: Color(0xFFFF9006),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
    );

    this.setState((){
           imageFile = croppedFile;
    });
    Navigator.of(context).pop();
    _showImg();
     }
    else{
      _showImg();
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Make a Choice',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            _openGallery(context);
                            
                          },
                          child: Image.asset('assets/images/art.png')),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: Text(
                          "From Galery",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _openCamera(context);
                        },
                        child: Image.asset('assets/images/camera.png'),
                      ),
                      Text(
                        "From Camera",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
//function to show image
  _showImg() {
    final imguUrl = widget.fbPicUrl;
    print({"URl ==== ": imguUrl, "image file ": imageFile});

    if ((imageFile == null) && (imguUrl == null)) {
      // return Image.network(imguUrl);
      return Image.asset('assets/images/btn_upload_cover.png',
          width: 220.0, height: 220.0, fit: BoxFit.cover);
    }
    if ((imguUrl != null) && (imageFile == null)) {

      return Image.network(imguUrl,
      width: 220.0, height: 220.0,fit: BoxFit.fill);
      // return Image.asset('assets/images/btn_upload_cover.png',
      //     width: 220.0, height: 220.0, fit: BoxFit.cover);
    }
   if ((imguUrl == null) && (imageFile != null)) 
    {
      return Image.file(
        imageFile,
        width: 220,
        height: 220,
        fit: BoxFit.fill,
      );
    }
  }
//function tht determines the name controller
  _initiateNameController(){
    if(widget.fbName == null){
      setState(() {
        _name.text =null;
      });
      print("name controller is empty");
    }
    else{
      _name.text= widget.fbName;
      print(_name.text);
    }
  }

  @override
  void initState() {
    // print(widget.fbId +
    //     "\n" +
    //     widget.fbName +
    //     "\n" +
    //     widget.fbEmail +
    //     "\n" +
    //     widget.fbPicUrl +
    //     "\n" +
    //     widget.phone+
    //     "\n" +
    //     widget.loginType);
    print(widget.loginType);
    _initiateNameController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, // this avoids the overflow error
      resizeToAvoidBottomInset: true,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 50.0, left: 14),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 38,
                  onPressed: () {
                    log('Clikced on back btn');
                    Navigator.of(context).pop();
                  },
                ),
              ),
              FadeAnimation(0.8, Container(
                  margin: EdgeInsets.only(top: 30, left: 30),
                  child: Text(
                    "Introduce Yourself",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(64, 75, 105, 1),
                      fontSize: 25,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  log("image upload btn clicked");
                  _showChoiceDialog(context);
                },
                child: FadeAnimation(1, Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 40),
                      child:
                          Align(alignment: Alignment.center, child: _showImg()),
                    ),
                  ),
                ),
              ),
              FadeAnimation(1.2, Container(
                  // width: MediaQuery.of(context).size.width / 1.5,
                  margin: EdgeInsets.only(top: 40, left: 28, right: 28),
                  child: TextField(
                    controller: _name,
                    enabled: widget.loginType =="fb"? false :true,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Color(0xFFF5F5F5))),
                        labelText: 'Name',
                        errorText: _errorName,
                        errorBorder: _errorName.isEmpty
                            ? OutlineInputBorder(
                                borderSide: new BorderSide(color: Color(0xFFE0E0E0)))
                            : null, 
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orangeAccent))),
                  ),
                ),
              ),
              FadeAnimation(1.4, Center(
                  child: Container(
                    margin:
                        EdgeInsets.only(top: 20, left: 26, right: 26, bottom: 15),
                    child: InkWell(
                      onTap: () {
                        if (checkNull()) {
                          setState(() {
                            _errorName = "";
                          });

                      final _phone = widget.phone;
                      final _fbId = widget.fbId;
                      final _fbName = widget.fbName;
                      final _fbEmail = widget.fbEmail;
                      final _fbPicUrl = widget.fbPicUrl;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SetupStepTwo(
                                phone: _phone,
                                fbId: _fbId,
                                fbName: _fbName,
                                fbEmail: _fbEmail,
                                fbPicUrl: _fbPicUrl,
                                loginType: widget.loginType,

                              )));
                        } else {
                          setState(() {
                            _errorName = "You should fill out this field !";
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.15,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF6038), Color(0xFFFF9006)],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Text(
                            'Next'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  bool checkNull() {
    if (_name.text == '') {
      return false;
    } else {
      return true;
    }
  }
}
