import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:folk/utils/Constants.dart';
import 'package:path/path.dart' as Path;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:async/async.dart';
import 'dart:io';

class CreateRoomPage extends StatefulWidget {
  @override
  _CreateRoomPageState createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  File file;
  String fileName;
  int currentLoading = 0;
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text('create Room'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
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
                  child: file != null
                      ? Image.file(
                          file,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          '${Constants.SERVER_IMAGE_URL}uploads/public_chat_rooms/default-chat-room-image.jpg',
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
                      'Room Name',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                            border: InputBorder.none, filled: true))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              currentLoading == 0 ? _submitButton() : progress,
            ],
          ),
        ),
      ),
    );
  }

  void startImagePicker() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
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
        if (file == null && nameController.text.isEmpty) {
          Fluttertoast.showToast(msg: 'img or name is empty !');
        } else {
          setState(() {
            currentLoading = 1;
          });
          startUploadRoom();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Next',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  void startUploadRoom() async {
    String _url = '${Constants.SERVER_URL}rooms/create';

    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var uri = Uri.parse(_url);
    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile('img', stream, length,
        filename: Path.basename(file.path));
    request.files.add(multipartFile);
    request.fields.addAll({
      "room_name": '${nameController.text}',
    });
    var response = await request.send();
    response.stream.transform(convert.utf8.decoder).listen((value) async {
      try {
        var jsonResponse = await convert.jsonDecode(value);
        bool error = jsonResponse['error'];
        if (error == false) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "doen",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0);
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
      }finally {
        setState(() {
          currentLoading = 0;
        });
      }
    });
  }
}
