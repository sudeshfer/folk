import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:folk/models/EventModel.dart';
import 'package:folk/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:folk/models/joinedEventModel.dart';

class EventProvider with ChangeNotifier {
  List<EventModel> _eventModelList = [];
  List<JoinedEventModel> _joinedEventModelList = [];

  List<EventModel> get listEvents => _eventModelList;
  List<JoinedEventModel> get listJoinedEvents => _joinedEventModelList;

  EventModel _eventModel;
  JoinedEventModel _joinEventModel;

  // ignore: unnecessary_getters_setters
  EventModel get eventModel => _eventModel;

  JoinedEventModel get joinEventModel => _joinEventModel;

  // ignore: unnecessary_getters_setters
  set eventModel(EventModel value) {
    _eventModel = value;
  }

  set joinEventModel(JoinedEventModel value) {
    _joinEventModel = value;
  }

  void updateUserJoinedStatusAndcount(bool isUserJoined,int count) {
    _eventModel.isUserJoined = isUserJoined;
     _eventModel.joinedCount = count;
    notifyListeners();
  }

  int page = 1;

  Future<void> startGetEventsData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int maxDistance = prefs.getInt("maxDistance");
    String duration = prefs.getString("filterWhen");
    String sortParm = prefs.getString("filterSort");
    int minAge = prefs.getInt("lowerAge");
    int maxAge = prefs.getInt("maxAge");
    final lat = prefs.getDouble("lat");
    final long = prefs.getDouble("lng");

    final allCheckString = prefs.getString("categoryAll");
    DateTime now = DateTime.now();

    print(DateTime.now().toString() + "date issssssssssssssssssssss");

    if (maxDistance == null) {
      print('distance is null');
      maxDistance = 4000;
      print('distance issssssssssssssssssssssssss $allCheckString');
    }

    if(minAge == null){
      minAge = 18;
    }
    if(maxAge == null){
       maxAge = 80;
    }

    if (duration == null) {
      duration = "all";
      print("filter when is $duration");
    }
    if (sortParm == null) {
      sortParm = "recent";
      print("filter sort is $sortParm");
    }

    _eventModelList = [];

    page = 1;
    String _url = "${Constants.SERVER_URL}event/fetch";
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
              'date': now.toString(),
              'duration': duration,
              'sortParameter': sortParm,
              'minAge': minAge,
              'maxAge': maxAge
            }))
        .then((res) async {
      var convertedData = convert.jsonDecode(res.body);

      if (!convertedData['error']) {
        print(convertedData);

        List data = convertedData['data'];
        // all ekata mkkda enne
        _eventModelList = data.map((data) => EventModel.fromJson(data)).toList();
        print("============================================${_eventModelList.length}");
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
     int minAge = prefs.getInt("lowerAge");
    int maxAge = prefs.getInt("maxAge");
    final lat = prefs.getDouble("lat");
    final long = prefs.getDouble("lng");
    final allCheckString = prefs.getString("categoryAll");

    if (maxDistance == null) {
      print('distance is null');
      maxDistance = 2000;
      print('distance issssssssssssssssssssssssss $maxDistance');
    }

    if (duration == null) {
      duration = "all";
      print("filter when is $duration");
    }

    if(minAge == null){
      minAge = 18;
    }
    if(maxAge == null){
       maxAge = 80;
    }

    if (sortParm == null) {
      sortParm = "recent";
      print("filter sort is $sortParm");
    }
    DateTime now = DateTime.now();

    ++page;
    String _url = "${Constants.SERVER_URL}event/fetch";
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
            'date': now.toString(),
            'duration': duration,
            'sortParameter': sortParm,
            'minAge': minAge,
            'MaxAge': maxAge
          }));
      var convertedData = convert.jsonDecode(req.body);
      if (!convertedData['error']) {
        List data = convertedData['data'];
        _eventModelList
            .addAll(data.map((data) => EventModel.fromJson(data)).toList());
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
    _eventModelList.removeWhere((item) => item.id == postId);
    notifyListeners();
  }

  void deletePostRequest(String postId) async {
    try {
      await http.post('${Constants.SERVER_URL}event/deleteEvent',
          body: {'post_id': postId});
      removePostFromListByPostId(postId);
    } catch (err) {
      Fluttertoast.showToast(msg: 'error while delete post  try again !');
    }
    notifyListeners();
  }

  //joined events providers
    Future<void> startGetJoinedEventsData(String id) async {
    
    _joinedEventModelList = [];

    page = 1;
    String _url = "${Constants.SERVER_URL}event/getjoinedevents";
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    return http
        .post(_url,
            headers: requestHeaders,
            body: convert.json.encode({
              'user_id': id,
              'page': '$page'
            }))
        .then((res) async {
      var convertedData = convert.jsonDecode(res.body);

      if (!convertedData['error']) {
        print(convertedData);

        List data = convertedData['data'];
        // all ekata mkkda enne
        _joinedEventModelList = data.map((data) => JoinedEventModel.fromJson(data)).toList();
        print("============================================${_joinedEventModelList.length}");
      }
      notifyListeners();
    }).catchError((err) {
      print('init Data error is $err');
    });
  }
}
