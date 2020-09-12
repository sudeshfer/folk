import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:folk/models/interestModel.dart';
import 'package:folk/utils/Constants.dart';
import 'package:gallery_saver/files.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:folk/Utils/Animations/FadeAnimation.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/models/filterCatsModel.dart';

class CategoryFilter extends StatefulWidget {
  CategoryFilter({Key key}) : super(key: key);

  @override
  _CategoryFilterState createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  UserModel userModel;
  String isExpanded = "";
  List<UserInterests> interest = List();
  List<UserInterests> _selectedIndexs = [];
  List<FilterCats> finalcats = [];
  List<FilterCats> initCats = [];
  String categoryString = '';
  var newitm;
  bool isAll = false;

  @override
  void initState() {
    // getInterrests();
    super.initState();
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;

    for (var i = 0; i < userModel.userInterests.length; i++) {
      interest.add(userModel.userInterests[i]);
      print(interest.length);
    }
    initializeCats();
  }

  initializeCats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("selected length isssss${prefs.getStringList("cats")}");
    if (prefs.getStringList("cats") != null) {
      print("hutttoooooooooooooooooooooo");
      List<String> catlist = prefs.getStringList("cats");
      initCats = catlist.map((json) => FilterCats.fromJson(json)).toList();
      for (var i = 0; i < interest.length; i++) {
        if (initCats.any((element) => element.catName == interest[i].interestname)) {
          setState(() {
            _selectedIndexs.add(interest[i]);
            finalcats.add(initCats[i]);
          });
          print(
              "_selectedIndexs length isssssssssssssssss ${_selectedIndexs[i].interestname}");
        }
      }

      print("selected length isssss${_selectedIndexs.length}");
    } else if (prefs.getString("categoryAll") != null) {
      print("selcted all");
      setState(() {
        isAll = true;
      });
      for (var i = 0; i < interest.length; i++) {
        setState(() {
          _selectedIndexs.add(interest[i]);
        });
      }
      finalcats.clear();
      prefs.remove("cats");

    }else{
       print("havent selected category filter");
      setState(() {
        isAll = false;
      });
      _selectedIndexs.clear();
      finalcats.clear();
      prefs.remove("categoryAll");
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      0.9,
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 18),
        child: ExpansionTile(
          title: buildExpansionHeader("Categories"),
          onExpansionChanged: changeIcon(),
          trailing: Icon(
            Icons.keyboard_arrow_down,
            size: 35,
            color: isExpanded == "false" ? Colors.black : Colors.black,
          ),
          initiallyExpanded: false,
          children: <Widget>[
            FadeAnimation(
              0.5,
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 30.0, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          isAll = !isAll;
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (isAll) {
                          print("all selected");
                          for (var i = 0; i < interest.length; i++) {
                            setState(() {
                              _selectedIndexs.add(interest[i]);
                            });
                          }
                          prefs.setString("categoryAll", "all");
                          finalcats.clear();
                          prefs.remove("cats");
                        } else {
                          print("all cleared");
                          _selectedIndexs.clear();
                          finalcats.clear();
                          prefs.remove("cats");
                          prefs.remove("categoryAll");
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 7),
                        height: 35,
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                            color: isAll ? Color(0xFFFFEBE7) : Colors.white,
                            border: Border.all(color: Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50.0),
                                topRight: Radius.circular(50.0),
                                bottomRight: Radius.circular(50.0),
                                bottomLeft: Radius.circular(0.0))),
                        child: Center(
                          child: Text(
                            "All Categories",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Color(0xFFFF5E3A),
                                fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 35,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final _isSelected =
                                _selectedIndexs.contains(interest[index]);
                            return Wrap(
                              direction: Axis.vertical,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                      setState(() {
                                        isAll = false;
                                      });
                                    // _selectedIndexs.clear();
                                    // finalcats.clear();
                                    // prefs.remove("cats");
                                    prefs.remove("categoryAll");
                                    print(_isSelected);
                                    
                                    if (_isSelected) {
                                      setState(() {
                                        _selectedIndexs.remove(interest[index]);
                                        // finalcats.remove(interest[index]);
                                      });
                                      print(finalcats.length);
                                      if (_selectedIndexs.length != 0) {
                                        for (var i = 0;i < finalcats.length;i++) {
                                          if (_selectedIndexs.any((element) =>
                                              element.interestname !=
                                              finalcats[i].catName)) {
                                            setState(() {
                                              finalcats.remove(finalcats[i]);
                                            });

                                            print(
                                                "finalcatssssssssss length isssssssssssssssss ${finalcats.length}");
                                          }
                                        }
                                      } else {
                                        finalcats.clear();
                                        prefs.remove("cats");
                                        print(
                                            "finalcatssssssssss length isssssssssssssssss ${finalcats.length}");
                                      }

                                      List<String> jsonList = finalcats
                                          .map((cat) => cat.toJson())
                                          .toList();
                                      prefs.setStringList("cats", jsonList);
                                    } else {
                                      setState(() {
                                        _selectedIndexs.add(interest[index]);
                                      });
                                      finalcats.add(FilterCats(
                                          catName:
                                              interest[index].interestname));
                                      print(finalcats);
                                      List<String> jsonList = finalcats
                                          .map((cat) => cat.toJson())
                                          .toList();
                                      prefs.setStringList("cats", jsonList);
                                    }
                                  },
                                  child: new Container(
                                    margin: EdgeInsets.only(right: 7),
                                    height: 35,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    decoration: BoxDecoration(
                                        color: _isSelected
                                            ? Color(0xFFFFEBE7)
                                            : Colors.white,
                                        border: Border.all(
                                            color: Color(0xFFE0E0E0)),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50.0),
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                            bottomLeft: Radius.circular(0.0))),
                                    child: Center(
                                      child: Text(
                                        interest[index].interestname,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Color(0xFFFF5E3A),
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount: interest.length,
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
  }

  showToast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xFFFF6038),
        textColor: Colors.white,
        fontSize: 16.0,
        );
  }

  changeIcon() {
    setState(() {
      isExpanded = "false";
    });
    print(isExpanded);
  }

  Widget buildExpansionHeader(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// class GetInterestService {
//   static const String url = '${Constants.SERVER_URL}user/getinterst';
//   static Future<List<Interest>> getInterests() async {
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         List<Interest> list = parseInterests(response.body);
//         return list;
//       } else {
//         throw Exception("Error");
//       }
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

//   static List<Interest> parseInterests(String responseBody) {
//     final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
//     return parsed.map<Interest>((json) => Interest.fromJson(json)).toList();
//   }
// }

// class FilterCats {
//   String catName;

//   FilterCats({
//     this.catName,
//   });

//   factory FilterCats.fromJson(String str) =>
//       FilterCats.fromMap(json.decode(str));

//   String toJson() => json.encode(toMap());

//   factory FilterCats.fromMap(Map<String, dynamic> json) =>
//       FilterCats(catName: json["catName"]);

//   Map<String, dynamic> toMap() => {"catName": catName};
// }
