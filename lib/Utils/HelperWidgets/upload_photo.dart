import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class PhotoBox extends StatefulWidget {
  final double width;
  final double height;
  final String imgPath;

  PhotoBox(
      {this.width,
      this.height,
      this.imgPath = "assets/images/btn_upload_cover_square.png"});

  @override
  _PhotoBoxState createState() => _PhotoBoxState();
}

class _PhotoBoxState extends State<PhotoBox> {
  File imageFile;

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
              color: (imageFile == null) ? Colors.white : Colors.grey[100]),
          child: (imageFile == null)
              //No img selected and camera logo is shown
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.grey[100],
                      onTap: () {
                        print("Photo Pick Button pressed");
                        _showChoiceDialog(context);
                      },
                      child: Image(
                        image: AssetImage(widget.imgPath),
                      ),
                    ),
                  ),
                )
              : Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        child: Image.file(
                          imageFile,
                          fit: BoxFit.cover,
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
                          setState(() {
                            imageFile = null;
                          });
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

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
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
                        _openGallery(context);
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
                        _openCamera(context);
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
