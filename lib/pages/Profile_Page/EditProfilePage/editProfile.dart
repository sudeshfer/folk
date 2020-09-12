import 'package:flutter/material.dart';
import 'package:folk/pages/Profile_Page/EditProfilePage/Widgets/photo_boxFive.dart';
import 'package:folk/pages/Profile_Page/EditProfilePage/Widgets/photo_boxFour.dart';
import 'package:folk/pages/Profile_Page/EditProfilePage/Widgets/photo_boxOne.dart';
import 'package:folk/pages/Profile_Page/EditProfilePage/Widgets/photo_boxTwo.dart';
import 'package:folk/pages/Profile_Page/EditProfilePage/Widgets/photo_boxThree.dart';
import 'package:folk/pages/Profile_Page/EditProfilePage/Widgets/photo_boxSix.dart';
import 'package:folk/utils/HelperWidgets/upload_photo.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chooseCategories.dart';
import 'package:folk/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import 'package:simple_auth_flutter/simple_auth_flutter.dart';
import 'package:dio/dio.dart';

class EditProfile extends StatefulWidget {
  List catlist;
  EditProfile({this.catlist});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModel userModel;

  final wtDouDoController = TextEditingController();
  final bioController = TextEditingController();
  final interestController = TextEditingController();
  int currentLoading = 0;

  // getCats() async {
  //   SharedPreferences updateProfile = await SharedPreferences.getInstance();
  //   String cats =updateProfile.getString("catString");
  //   // List catlist = updateProfile.getStringList("catlist");
  //   setState(() {
  //     interestController.text = cats != ""? cats:null;
  //   });
  // }

  @override
  void initState() {
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    // wtDouDoController.text = userModel.name == ""? userModel.name:null;
    bioController.text = userModel.bio != "" ? userModel.bio : null;
    interestController.text =
        userModel.catString != "" ? userModel.catString : null;
    wtDouDoController.text = userModel.whatudo != "" ? userModel.whatudo : null;

    super.initState();
  }

  _printLatestValue(String value) {
    print("bio text field: " + value);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        child: ListView(
          children: <Widget>[
            PhotoCollage(width),
            InkWell(
              onTap: () {
                print(userModel.id);
              },
              child: VerifyBtn()),
            InkWell(
              onTap: () {
                print(userModel.id);
              },
              child: InstagramBtn()),
            // InkWell(
            //   onFocusChange: (value) {
            //     if(value){
            //       print("updateBio");
            //       print(userModel.id);

            //     }
            //     else{
            //       print("start update bio");
            //       startUpdateBio();
            //     }
            //   },
            //   child: InputField("About Me", false,bioController,_printLatestValue(bioController.text))),
            InkWell(
                onFocusChange: (value) {
                  if (value) {
                    print("updateBio");
                    print(userModel.id);
                  } else {
                    print("start update bio");
                    // startUpdateBio(bioController.text);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              maxLength: 500,
                              controller: bioController,
                              onChanged: (value) {
                                String bioData;
                                setState(() {
                                  bioData = value;
                                });
                                startUpdateBio(bioData);
                              },
                              decoration: InputDecoration(
                                  labelText: "About me",
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none),
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: wtDouDoController,
                          onChanged: (value) {
                            String wtudo;
                            setState(() {
                              wtudo = value;
                            });
                            print(wtudo);
                            startUpdateWtudo(wtudo);
                          },
                          decoration: InputDecoration(
                              labelText: "What do you do?",
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              border: InputBorder.none),
                          keyboardType: TextInputType.multiline,
                          textAlign: TextAlign.justify,
                          maxLines: 5,
                          minLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // InputField("What do you do?", false,wtDouDoController),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChooseCategories()));
              },
              child: IgnorePointer(
                  ignoring: true,
                  child: InputField(
                      "What are your interests?", true, interestController)),
            ),
          ],
        ),
      ),
    );
  }

  void startUpdateBio(biocontroller) async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      var response = await http.post(
        '${Constants.SERVER_URL}user/update_bio',
        body: {'user_id': userModel.id, 'bio': biocontroller},
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
        // String bio = jsonResponse['bio'];
        // String userName = jsonResponse['user_name'];
        
        Provider.of<AuthProvider>(context, listen: false)
            .updateBio(bioController.text);
        // Fluttertoast.showToast(msg: 'Bio is Updated');
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

   void startUpdateWtudo(wtudoController) async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      var response = await http.post(
        '${Constants.SERVER_URL}user/update_whatudo',
        body: {'user_id': userModel.id, 'whatudo': wtudoController},
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
        // String bio = jsonResponse['bio'];
        // String userName = jsonResponse['user_name'];
        print(wtDouDoController.text);
        Provider.of<AuthProvider>(context, listen: false)
            .updateWhatudo(wtudoController);
        Fluttertoast.showToast(msg: 'Status is Updated');
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
}

class InputField extends StatelessWidget {
  final String label;
  final bool isInterestBtn;
  final TextEditingController controller;
  // final Function function;
  InputField(this.label, this.isInterestBtn, this.controller);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  // onChanged: (value) => function(value),
                  decoration: InputDecoration(
                      labelText: label,
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none),
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.justify,
                  maxLines: 5,
                  minLines: 1,
                ),
              ),
              (isInterestBtn)
                  ? GestureDetector(
                      onTap: () {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('2000ක් දියන් ...')));
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class VerifyBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: GestureDetector(
        onTap: () {
          print("Verify button pressed");
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('සල්ලි දියන් යකූ ...')));
          // Navigator.of(context).pushNamed("/choose");
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue[400],
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Image(
                  image: AssetImage("assets/images/ic_radio.png"),
                  height: 30,
                ),
              ),
              Expanded(
                child: Text(
                  "Verify your Profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InstagramBtn extends StatefulWidget {
  @override
  _InstagramBtnState createState() => _InstagramBtnState();
}

class _InstagramBtnState extends State<InstagramBtn> {
  Map _userData;
  String _errorMsg;
  UserModel userModel;

  final simpleAuth.InstagramApi _igApi = simpleAuth.InstagramApi(
    "instagram",
    Constants.igClientId,
    Constants.igClientSecret,
    Constants.igRedirectURI,
    scopes: [
      'user_profile', // For getting username, account type, etc.
      'user_media', // For accessing media count & data like posts, videos etc.
    ],
  );

  @override
  void initState() {
    // TODO: implement initState
    SimpleAuthFlutter.init(context);
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:20,bottom: 20, left:20),
      child: GestureDetector(
        onTap: () async {
          print("Verify button pressed");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if(prefs.getString("longliveToken") == null){
             _loginAndGetData();
          }else{
            // prefs.remove("longliveToken");
            Fluttertoast.showToast(msg: 'You have already connected Instagram');
          }
          
         
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
                              colors: [Color(0xFF4C5DD1),Color(0xFF8B43C3), Color(0xFFE46844),Color(0xFFFDC862)],
                            ),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Image(
                  image: AssetImage("assets/images/insta.png"),
                  height: 30,
                ),
              ),
              Expanded(
                child: Text(
                  "Connect Instagram",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _loginAndGetData() async {
    _igApi.authenticate().then(
      (simpleAuth.Account _user) async {
        simpleAuth.OAuthAccount user = _user;
        SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("usertoken", user.token);

        var instaRes =
            await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
          '/access_token',
          queryParameters: {
            // Get the fields you need.
            // https://developers.facebook.com/docs/instagram-basic-display-api/reference/user
            "grant_type": "ig_exchange_token",
            "client_secret": "${Constants.igClientSecret}",
            "access_token": prefs.getString("usertoken"),
          },
        );

        try {
      var response = await http.post(
        '${Constants.SERVER_URL}instaAuth/saveInstaAuth',
        body: {'user_id': userModel.id, 'user_token': "${instaRes.data['access_token']}"},
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
        prefs.setString("longliveToken", "${instaRes.data['access_token']}");
        Fluttertoast.showToast(msg: 'Instagram authorization is successfull');
      }
    }catch(e){
      print(e);
    }
        
        print("token isssssssssssssssssssssssss ${instaRes.data['access_token']}");
      },
    ).catchError(
      (Object e) {
        setState(() => _errorMsg = e.toString());
      },
    );
  }
}

class PhotoCollage extends StatelessWidget {
  final double width;

  PhotoCollage(this.width);
  @override
  Widget build(BuildContext context) {
    double width = this.width - 10;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              PhotoBoxOne(
                width: (width * 2 / 3),
                height: (width * 2 / 3),
              ),
              Column(
                children: <Widget>[
                  PhotoBoxTwo(
                    width: width / 3,
                    height: width / 3,
                  ),
                  PhotoBoxThree(
                    width: width / 3,
                    height: width / 3,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              PhotoBoxFour(
                width: width / 3,
                height: width / 3,
              ),
              PhotoBoxFive(
                width: width / 3,
                height: width / 3,
              ),
              PhotoBoxSix(
                width: width / 3,
                height: width / 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class PhotoBox extends StatefulWidget {
//   final double width;

//   PhotoBox({this.width});

//   @override
//   _PhotoBoxState createState() => _PhotoBoxState();
// }

// class _PhotoBoxState extends State<PhotoBox> {
//   File imageFile;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.width,
//       height: widget.width,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: (imageFile == null) ? Colors.white : Colors.grey[100]),
//           child: (imageFile == null)
//               //No img selected and camera logo is shown
//               ? ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       splashColor: Colors.grey[100],
//                       onTap: () {
//                         print("Photo Pick Button pressed");
//                         _showChoiceDialog(context);
//                       },
//                       child: Image(
//                         image: AssetImage(
//                             "assets/drawable-xxxhdpi/btn_upload_cover.png"),
//                       ),
//                     ),
//                   ),
//                 )
//               : Stack(
//                   fit: StackFit.expand,
//                   children: <Widget>[
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Container(
//                         child: Image.file(
//                           imageFile,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: InkWell(
//                         splashColor: Colors.transparent,
//                         highlightColor: Colors.transparent,
//                         onTap: () {
//                           print("Delete Button Pressed");
//                           setState(() {
//                             imageFile = null;
//                           });
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Container(
//                             child: Image(
//                               image:
//                                   AssetImage("assets/drawable-xxxhdpi/1.png"),
//                               height: 30,
//                             ),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }

//   _openGallery(BuildContext context) async {
//     var picture = await folk.pickImage(source: ImageSource.gallery);
//     this.setState(() {
//       imageFile = picture;
//     });
//     Navigator.of(context).pop();
//   }

//   _openCamera(BuildContext context) async {
//     var picture = await folk.pickImage(source: ImageSource.camera);
//     this.setState(() {
//       imageFile = picture;
//     });
//     Navigator.of(context).pop();
//   }

//   Future<void> _showChoiceDialog(BuildContext context) {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0))),
//             title: Text(
//               'Select image source',
//               style: TextStyle(
//                   fontSize: 20,
//                   fontFamily: 'Montserrat',
//                   fontWeight: FontWeight.bold),
//             ),
//             content: Padding(
//               padding: const EdgeInsets.only(top: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   IconButton(
//                       icon: FaIcon(FontAwesomeIcons.solidImages),
//                       onPressed: () {
//                         _openGallery(context);
//                       }),
//                   IconButton(
//                       icon: FaIcon(FontAwesomeIcons.camera),
//                       onPressed: () {
//                         _openCamera(context);
//                       })
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
