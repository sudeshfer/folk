import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:folk/app_localizations.dart';
import 'package:folk/models/interestModel.dart';
import 'package:folk/pages/HomePage/Home.dart';
import 'package:folk/pages/login&signup/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:folk/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:folk/models/UserModel.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'dart:convert' as convert;
import 'package:provider/provider.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as Path;

class SetupStepThree extends StatefulWidget {
  final fbName;
  final gender;
  final bday;
  final fbEmail;
  final phone;
  final imgSource;
  File imageFile;
  final fbPicUrl;
  // PincodeVerify({Key key}) : super(key: key);
  SetupStepThree(
      {this.fbName,
      this.gender,
      this.bday,
      this.fbEmail,
      this.phone,
      this.imgSource,
      this.imageFile,
      this.fbPicUrl});

  @override
  _SetupStepThreeState createState() => _SetupStepThreeState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _SetupStepThreeState extends State<SetupStepThree> {
////
  void startIntRegister(body) async {
    var url = '${Constants.SERVER_URL}user/update_user_interest';

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    try {
      var response =
          await http.post(url, body: jsonEncode(body), headers: requestHeaders);
      var jsonResponse = await convert.jsonDecode(response.body);
      bool error = jsonResponse['error'];
      if (error) {
        pr.hide();
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
        pr.hide();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => GetLocation()),
            (Route<dynamic> route) => false);
      }
    } catch (err) {
      pr.hide();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(err.toString()),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('close'))
              ],
            );
          });
    } finally {}
  }
/////

  var regurl = '${Constants.SERVER_URL}user/create';

  void startRegister() async {
    pr.show();
    if (widget.imageFile != null) {

      var stream = new http.ByteStream(
          DelegatingStream.typed(widget.imageFile.openRead()));
      var length = await widget.imageFile.length();
      var uri = Uri.parse(regurl);
      var request = new http.MultipartRequest("POST", uri);
      request.headers['Content-Type'] = 'application/json';
      var multipartFile = new http.MultipartFile('img', stream, length,
          filename: Path.basename(widget.imageFile.path));
      request.files.add(multipartFile);
      request.fields.addAll({
        'user_name': widget.fbName.toString(),
        'gender': widget.gender.toString(),
        'bday': widget.bday.toString(),
        'email': widget.fbEmail.toString(),
        'phone': widget.phone.toString(),
        'imagesource': widget.imgSource.toString(),
        'base_64': '',
        'fb_url': widget.fbPicUrl.toString()
        // 'ints': finalints.toString(),
        // "geometry": "",
      });
      var response = await request.send();

      response.stream.transform(convert.utf8.decoder).listen((value) async {
        try {
          var jsonResponse = await convert.jsonDecode(value);
          bool error = jsonResponse['error'];
          if (error == false) {
            var userData = jsonResponse['data'];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("gettoken", jsonResponse['token']);
            UserModel myModel = UserModel.fromJson(userData);
            //make my model usable to all widgets
            Provider.of<AuthProvider>(context, listen: false).userModel =
                myModel;

            List finalints = [];
            String categoryString = '';

            for (var i = 0; i < _selectedIndexs.length; i++) {
              final newitm = {
                "interestID": _selectedIndexs[i].interestid,
                "interestName": _selectedIndexs[i].interestname
              };

              setState(() {
                myModel.userInterests.add(UserInterests(
                  interestname: _selectedIndexs[i].interestname,
                  interestid: _selectedIndexs[i].interestid,
                ));
              });
              finalints.add(newitm);
              if (categoryString == '') {
                categoryString += _selectedIndexs[i].interestname;
              } else {
                categoryString += " - " + _selectedIndexs[i].interestname;
              }

              // print(_selectedIndexs[i].intName);
            }
            SharedPreferences updateProfile =
                await SharedPreferences.getInstance();

            Provider.of<AuthProvider>(context, listen: false)
                .updateCategoryString(categoryString);

            setState(() {
              updateProfile.setString("catString", categoryString);
            });

            for (var i = 0; i < finalints.length; i++) {
              print("fonal catssssssssssssssssssss {$finalints[i]}");
            }
            print(finalints.length);
            final body = {'user_id': myModel.id, 'ints': finalints};

            startIntRegister(body);
          } else {
            pr.hide();
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
          }
        } catch (err) {
          pr.hide();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(err.toString()),
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
          setState(() {});
        }
      });
    } else {
    
      try {
        Map<String, String> requestHeaders = {
          'Content-Type': 'application/json'
        };

        print("here adding post");

        var req = await http.post(regurl,
            headers: requestHeaders,
            body: jsonEncode({
              'user_name': widget.fbName.toString(),
              'gender': widget.gender.toString(),
              'bday': widget.bday.toString(),
              'email': widget.fbEmail.toString(),
              'phone': widget.phone.toString(),
              'imagesource': widget.imgSource.toString(),
              'base_64': '',
              'fb_url': widget.fbPicUrl.toString()
              // 'ints': finalints.toString(),
              // "geometry": ""
            }));

        var response = convert.jsonDecode(req.body);

        if (!response['error']) {
          var userData = response['data'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("gettoken", response['token']);
          UserModel myModel = UserModel.fromJson(userData);
          //make my model usable to all widgets
          Provider.of<AuthProvider>(context, listen: false).userModel = myModel;

          List finalints = [];
          String categoryString = '';

          for (var i = 0; i < _selectedIndexs.length; i++) {
            final newitm = {
              "interestID": _selectedIndexs[i].interestid,
              "interestName": _selectedIndexs[i].interestname
            };

            setState(() {
              myModel.userInterests.add(UserInterests(
                interestname: _selectedIndexs[i].interestname,
                interestid: _selectedIndexs[i].interestid,
              ));
            });
            finalints.add(newitm);
            if (categoryString == '') {
              categoryString += _selectedIndexs[i].interestname;
            } else {
              categoryString += " - " + _selectedIndexs[i].interestname;
            }

            // print(_selectedIndexs[i].intName);
          }
          SharedPreferences updateProfile =
              await SharedPreferences.getInstance();

          Provider.of<AuthProvider>(context, listen: false)
              .updateCategoryString(categoryString);

          setState(() {
            updateProfile.setString("catString", categoryString);
          });

          for (var i = 0; i < finalints.length; i++) {
            print("fonal catssssssssssssssssssss {$finalints[i]}");
          }
          print(finalints.length);
          final body = {'user_id': myModel.id, 'ints': finalints};

          startIntRegister(body);
        }
      } catch (err) {
        pr.hide();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(err.toString()),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('close'))
                ],
              );
            });
      } finally {}
    }
  }

  final _debouncer = Debouncer(milliseconds: 500);
  List<Interest> interest = List();
  List<Interest> filteredInterests = List();

  List<InterestData> _selectedIndexs = [];
  final _search = TextEditingController();

  bool isClicked = false;
  bool isSearchFocused = false;
  String isExpanded = "";
  ProgressDialog pr;

  @override
  void initState() {
    callAPI();
    super.initState();
  }

  callAPI() {
    GetInterestService.getInterests().then((interestFromServer) {
      setState(() {
        interest = interestFromServer;
        filteredInterests = interest;
      });
    });

    setState(() {
      isExpanded = "true";
    });
  }

  Future<bool> _onBackPressed() {
    return AwesomeDialog(
            context: context,
            dialogType: DialogType.WARNING,
            // customHeader: Image.asset("assets/images/macha.gif"),
            animType: AnimType.TOPSLIDE,
            btnOkText: AppLocalizations.of(context).translate('yes'),
            btnCancelText: AppLocalizations.of(context).translate('no'),
            tittle: AppLocalizations.of(context).translate('you_sure'),
            desc: AppLocalizations.of(context).translate('exit_app'),
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              exit(0);
            }).show() ??
        false;
  }

  // _clearSearch() {
  //   _search.clear();
  // }

  changeIcon() {
    setState(() {
      isExpanded = "false";
    });
    print(isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
        message: 'Saving  Info...',
        borderRadius: 10.0,
        progressWidget: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/loading2.gif'),
                    fit: BoxFit.cover))),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: TextStyle(fontFamily: 'Montserrat'));

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          isSearchFocused = false; //
        },
        child: Scaffold(
          resizeToAvoidBottomPadding: false, // this avoids the overflow error
          resizeToAvoidBottomInset: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 45.0, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: 38,
                      onPressed: () {
                        log('Clikced on back btn');
                        Navigator.of(context).pop(); //go back
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 30.0),
                      width: MediaQuery.of(context).size.width / 1.4,
                      height: 45,
                      // margin: EdgeInsets.only(top: 32),
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5)
                          ]),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        // controller: _search,
                        onTap: () {
                          setState(() {
                            isSearchFocused = true;
                          });
                        },
                        onChanged: (string) {
                          _debouncer.run(() {
                            setState(() {
                              filteredInterests[0].interestData = interest[0]
                                  .interestData
                                  .where((u) => (u.interestname
                                      .toLowerCase()
                                      .contains(string.toLowerCase())))
                                  .toList();
                            });
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                            size: 30,
                          ),
                          hintText:
                              AppLocalizations.of(context).translate('search'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              FadeAnimation(
                0.8,
                Container(
                  margin: EdgeInsets.only(top: 30, left: 30, bottom: 20),
                  child: Text(
                    AppLocalizations.of(context).translate('choose_intrst'),
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
              Expanded(
                child: PageView(
                  controller: PageController(viewportFraction: 1),
                  scrollDirection: Axis.horizontal,
                  pageSnapping: true,
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredInterests.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FadeAnimation(
                          0.9,
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 18),
                            child: ExpansionTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    filteredInterests[index]
                                        .intType
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              onExpansionChanged: null,
                              trailing: Icon(
                                Icons.keyboard_arrow_down,
                                size: 35,
                                color: isExpanded == "false"
                                    ? Colors.black
                                    : Colors.black,
                              ),
                              initiallyExpanded: true,
                              children: <Widget>[
                                FadeAnimation(
                                  0.5,
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, bottom: 30.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            height: 35,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index2) {
                                                final _isSelected =
                                                    _selectedIndexs.contains(
                                                        filteredInterests[index]
                                                                .interestData[
                                                            index2]);
                                                return Wrap(
                                                  direction: Axis.vertical,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (_isSelected) {
                                                            _selectedIndexs.remove(
                                                                filteredInterests[
                                                                            index]
                                                                        .interestData[
                                                                    index2]);
                                                            print(
                                                                _selectedIndexs);
                                                          } else {
                                                            _selectedIndexs.add(
                                                                filteredInterests[
                                                                            index]
                                                                        .interestData[
                                                                    index2]);
                                                            print(
                                                                _selectedIndexs);
                                                          }
                                                        });
                                                      },
                                                      child: new Container(
                                                        margin: EdgeInsets.only(
                                                            right: 7),
                                                        height: 30,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            5.2,
                                                        decoration: BoxDecoration(
                                                            color: _isSelected
                                                                ? Color(
                                                                    0xFFFFEBE7)
                                                                : Colors.white,
                                                            border: Border.all(
                                                                color: Color(
                                                                    0xFFE0E0E0)),
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        50.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        50.0),
                                                                bottomRight:
                                                                    Radius.circular(
                                                                        50.0),
                                                                bottomLeft:
                                                                    Radius.circular(
                                                                        0.0))),
                                                        child: Center(
                                                          child: Text(
                                                            filteredInterests[
                                                                    index]
                                                                .interestData[
                                                                    index2]
                                                                .interestname,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Montserrat',
                                                                color: Color(
                                                                    0xFFFF5E3A),
                                                                fontSize: 13),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              itemCount:
                                                  filteredInterests[index]
                                                      .interestData
                                                      .length,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),

          bottomNavigationBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: Container(
              height: 100,
              // decoration: BoxDecoration(
              //   color:Colors.red
              // ),
              child: FadeAnimation(
                1.4,
                InkWell(
                  onTap: () async {
                    
                    // log('Clikced on trouble with login');

                    // final body = {
                    //   'user_name': widget.fbName.toString(),
                    //   'gender': widget.gender.toString(),
                    //   'bday': widget.bday.toString(),
                    //   'email': widget.fbEmail.toString(),
                    //   'phone': widget.phone.toString(),
                    //   'imagesource': widget.imgSource.toString(),
                    //   'base_64': '',
                    //   'fb_url': widget.fbPicUrl.toString(),
                    //   'ints': finalints,
                    //   "geometry": json.encode(geo),
                    // };
                    // print("************************************");
                    // print(body);
                    startRegister();

                    // print(body);
                  },
                  child: Container(
                    // padding: EdgeInsets.only(top: 35, bottom: 25),
                    child: Center(
                      child: Container(
                        height: 51,
                        width: MediaQuery.of(context).size.width / 1.12,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF6038), Color(0xFFFF9006)],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Text(
                            'Next'.toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GetInterestService {
  static const String url = '${Constants.SERVER_URL}user/getinterst';
  static Future<List<Interest>> getInterests() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<Interest> list = parseInterests(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Interest> parseInterests(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Interest>((json) => Interest.fromJson(json)).toList();
  }
}
