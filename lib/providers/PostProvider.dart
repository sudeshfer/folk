//created by Suthura

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:folk/models/PostModel.dart';
import 'package:folk/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:folk/models/filterCatsModel.dart';

class PostProvider with ChangeNotifier {
  List<PostModel> _postModelList = [];

  List<PostModel> get listPosts => _postModelList;
  int page = 1;

  Future<void> startGetPostsData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int maxDistance = prefs.getInt("maxDistance");
    String typology = prefs.getString("filterTypology");
    String duration = prefs.getString("filterWhen");
    String sortParm = prefs.getString("filterSort");
    final lat = prefs.getDouble("lat");
    final long = prefs.getDouble("lng");

    final allCheckString = prefs.getString("categoryAll");
    List finalCats = [];
    String list = '';
    // print(maxDistance.toString());
    // print(lat.toString());
    // print(long.toString());
    DateTime now = DateTime.now();

    print(DateTime.now().toString() + "date issssssssssssssssssssss");

    if (maxDistance == null) {
      print('distance is null');
      maxDistance = 2000;
      print('distance issssssssssssssssssssssssss $allCheckString');
    }

    var finalArray = [];

    //filter categoriesssssssss
    if (prefs.getStringList("cats") != null) {
      List<String> catlist = prefs.getStringList("cats");
      List<FilterCats> initCats =
          catlist.map((json) => FilterCats.fromJson(json)).toList();
      print("sssssssssssssssssssssssssssssssssssssss $initCats");
      print("sssssssssssssssssssssssssssssssssssssss $catlist");
      for (var i = 0; i < initCats.length; i++) {
        finalArray.add(initCats[i].catName);
      }
    }

    //hutto copy kranna dipan

    if (typology == null) {
      typology = "all";
      print("typology is $typology");
    }
    if (duration == null) {
      duration = "all";
      print("filter when is $duration");
    }
    if (sortParm == null) {
      sortParm = "recent";
      print("filter sort is $sortParm");
    }

    _postModelList = [];

    page = 1;
    String _url = "${Constants.SERVER_URL}post/fetch";
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    return http
        .post(_url,
            headers: requestHeaders,
            body: convert.json.encode({
              'user_id': id,
              'page': '$page',
              'lat': lat.toString(),
              'long': long.toString(),
              'maxDistance': maxDistance.toString(),
              'typology': typology,
              'date': now.toString(),
              'duration': duration,
              'sortParameter': sortParm,
              'categoryParameter': finalArray.length == 0 ? "all" : finalArray
            }))
        .then((res) async {
      var convertedData = convert.jsonDecode(res.body);

      if (!convertedData['error']) {
        // print(convertedData);

        List data = convertedData['data'];
        // all ekata mkkda enne
        _postModelList = data.map((data) => PostModel.fromJson(data)).toList();
        // print("============================================");
      }
      notifyListeners();
    }).catchError((err) {
      print('init Data error is $err');
    });
  }

  Future<int> loadMore(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int maxDistance = prefs.getInt("maxDistance");
    String typology = prefs.getString("filterTypology");
    String duration = prefs.getString("filterWhen");
    String sortParm = prefs.getString("filterSort");
    final lat = prefs.getDouble("lat");
    final long = prefs.getDouble("lng");
    final allCheckString = prefs.getString("categoryAll");

    // print(maxDistance.toString());
    // print(lat.toString());
    // print(long.toString());

    if (maxDistance == null) {
      print('distance is null');
      maxDistance = 2000;
      print('distance issssssssssssssssssssssssss $maxDistance');
    }
    var finalArray = [];

    //filter categoriesssssssss
    if (prefs.getStringList("cats") != null) {
      List<String> catlist = prefs.getStringList("cats");
      List<FilterCats> initCats =
          catlist.map((json) => FilterCats.fromJson(json)).toList();
      print("sssssssssssssssssssssssssssssssssssssss $initCats");
      print("sssssssssssssssssssssssssssssssssssssss $catlist");
      for (var i = 0; i < initCats.length; i++) {
        finalArray.add(initCats[i].catName);
      }
    }

    if (typology == null) {
      typology = "all";
      print("typology is $typology");
    }
    if (duration == null) {
      duration = "all";
      print("filter when is $duration");
    }
    if (sortParm == null) {
      sortParm = "recent";
      print("filter sort is $sortParm");
    }
    DateTime now = DateTime.now();

    ++page;
    String _url = "${Constants.SERVER_URL}post/fetch";
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    try {
      var req = await http.post(_url,
          headers: requestHeaders,
          body: convert.json.encode({
            'user_id': id,
            'page': '$page',
            'lat': lat.toString(),
            'long': long.toString(),
            'maxDistance': maxDistance.toString(),
            'typology': typology,
            'date': now.toString(),
            'duration': duration,
            'sortParameter': sortParm,
            'categoryParameter': finalArray.length == 0 ? "all" : finalArray
          }));
      var convertedData = convert.jsonDecode(req.body);
      if (!convertedData['error']) {
        List data = convertedData['data'];
        _postModelList
            .addAll(data.map((data) => PostModel.fromJson(data)).toList());
        notifyListeners();
        return 1;
      } else {
        notifyListeners();
        return 0;
      }
    } catch (err) {
      return 0;
    }
  }

  void removePostFromListByPostId(String postId) {
    _postModelList.removeWhere((item) => item.id == postId);
    notifyListeners();
  }

  void deletePostRequest(String postId) async {
    try {
      await http.post('${Constants.SERVER_URL}post/deletePost',
          body: {'post_id': postId});
      removePostFromListByPostId(postId);
      print("post deleted");
    } catch (err) {
      Fluttertoast.showToast(msg: 'error while delete post  try again !');
    }
    notifyListeners();
  }
}
