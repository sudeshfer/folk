import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:folk/Controllers/ApiServices/GetInterestsService.dart';
import 'package:folk/Models/interestModel.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/pages/Profile_Page/EditProfilePage/editProfilePage.dart';
import 'package:folk/app_localizations.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:folk/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:fluttertoast/fluttertoast.dart';

class ChooseCategories extends StatefulWidget {
  // final bday;
  // final gender;
  // final email;
  // final phone;
  // final fbId;
  // final fbName;
  // final fbEmail;
  // final fbPicUrl;
  // PincodeVerify({Key key}) : super(key: key);
  ChooseCategories(
      // {
      //this.bday,
      // this.gender,
      // this.email,
      // this.phone,
      // this.fbId,
      // this.fbName,
      // this.fbEmail,
      // this.fbPicUrl
      // }
      );

  @override
  _ChooseCategoriesState createState() => _ChooseCategoriesState();
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

class _ChooseCategoriesState extends State<ChooseCategories> {
  final _debouncer = Debouncer(milliseconds: 500);
  List<Interest> interest = List();
  List<Interest> filteredInterests = List();

  List<InterestData> _selectedIndexs = [];
  List<InterestData> _temp = [];
  final _search = TextEditingController();

  bool isClicked = false;
  bool isSearchFocused = false;
  String isExpanded = "";

  UserModel userModel;

  @override
  void initState() {
    callAPI();
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;

    super.initState();
  }

  callAPI() {
    GetInterestService.getInterests().then((interestFromServer) {
      setState(() {
        interest = interestFromServer;
        filteredInterests = interest;
      });

      for (var i = 0; i < filteredInterests.length; i++) {
        for (var t = 0; t < filteredInterests[i].interestData.length; t++) {
          if (userModel.userInterests.any((element) =>
              element.interestname ==
              filteredInterests[i].interestData[t].interestname)) {
            setState(() {
              _selectedIndexs.add(filteredInterests[i].interestData[t]);
            });
            print(
                "_selectedIndexs length isssssssssssssssss ${userModel.userInterests[i].interestname}");
          }
        }
      }
    });

    setState(() {
      isExpanded = "true";
    });
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop();
  }

  changeIcon() {
    setState(() {
      isExpanded = "false";
    });
    print(isExpanded);
  }

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.only(top: 50.0, left: 15),
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
                          // _debouncer.run(() {
                          //   setState(() {
                          //     filteredInterests = interest
                          //         .where((u) => (u.intName
                          //             .toLowerCase()
                          //             .contains(string.toLowerCase())))
                          //         .toList();
                          //   });
                          // });
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
                  margin: EdgeInsets.only(top: 10, left: 30, bottom: 20),
                  child: Text(
                    "Choose categories",
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
                                                            //remove the interest from userInterest model
                                                            removeUserInterest(
                                                                index, index2);

                                                            print(
                                                                _selectedIndexs);
                                                          } else {
                                                            _selectedIndexs.add(
                                                                filteredInterests[
                                                                            index]
                                                                        .interestData[
                                                                    index2]);

                                                                    addToUserInterest(index, index2);

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
                    log('Clikced on trouble with login');
                    List finalcats = [];
                    String categoryString = '';
                    for (var i = 0; i < _selectedIndexs.length; i++) {
                      final newitm = {
                        "interestID": _selectedIndexs[i].interestid,
                        "interestName": _selectedIndexs[i].interestname
                      };
                      finalcats.add(newitm);
                      if (categoryString == '') {
                        categoryString += _selectedIndexs[i].interestname;
                      } else {
                        categoryString +=
                            " - " + _selectedIndexs[i].interestname;
                      }

                      // print(_selectedIndexs[i].intName);
                    }
                    SharedPreferences updateProfile =
                        await SharedPreferences.getInstance();

                    Provider.of<AuthProvider>(context, listen: false)
                        .updateCategoryString(categoryString);

                    setState(() {
                      updateProfile.setString("catString", categoryString);
                      // updateProfile.setStringList('catlist', finalcats);
                      // updateProfile.setString("postcategories", json.encode(finalcats));
                    });

                    for (var i = 0; i < finalcats.length; i++) {
                      print("fonal catssssssssssssssssssss {$finalcats[i]}");
                    }
                    print(finalcats.length);
                    final body = {'user_id': userModel.id, 'ints': finalcats};

                    startRegister(body, finalcats);
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

  void removeUserInterest(int index, int index2) {
    if (userModel.userInterests.any((element) =>
          element.interestname == filteredInterests[index].interestData[index2].interestname)) {
            
            for (var i = 0; i < userModel.userInterests.length; i++) {
              if(filteredInterests[index].interestData[index2].interestname == userModel.userInterests[i].interestname){
                  setState(() {
                          userModel.userInterests.remove(userModel.userInterests[i]);
                        });
                        print("removeddddddd ${userModel.userInterests.length}");
              }
              
            }
        
      }
  }

  void addToUserInterest(int index, int index2) {
    if (userModel.userInterests.any((element) =>
          element.interestname !=
          filteredInterests[index].interestData[index2].interestname)) {
        setState(() {
          userModel.userInterests.add(UserInterests(
             interestname: filteredInterests[index].interestData[index2].interestname,
            interestid: filteredInterests[index].interestData[index2].interestid,
          ));
        });
        print("removeddddddd ${userModel.userInterests.length}");
      }
  }

  void startRegister(body, finalcats) async {
    var url = '${Constants.SERVER_URL}user/update_user_interest';

    print(">>>>>>>>>");
    print(finalcats);
    print(">>>>>>>>>");

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    try {
      var response =
          await http.post(url, body: jsonEncode(body), headers: requestHeaders);
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
        // var userData = jsonResponse['data'];
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString("gettoken", jsonResponse['token']);
        // UserModel myModel = UserModel.fromJson(userData);
        // //make my model usable to all widgets
        // Provider.of<AuthProvider>(context, listen: false).userModel = myModel;

        // String categoryString = '';

        //   for (var i = 0; i < myModel.userInterests.length; i++) {
        //     print(myModel.userInterests[i].interestname);

        //      if (categoryString == '') {
        //                 categoryString += myModel.userInterests[i].interestname;
        //               } else {
        //                 categoryString +=
        //                     " - " + myModel.userInterests[i].interestname;
        //               }
        //   }

        //   print("cat string is = "+categoryString);
        //   Provider.of<AuthProvider>(context, listen: false)
        //     .updateCategoryString(categoryString);
        Fluttertoast.showToast(msg: 'User Interests are Updated');
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditProfilePage(catlist: finalcats)));
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => GetLocation()),
        //     (Route<dynamic> route) => false);
      }
    } catch (err) {
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
