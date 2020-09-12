import 'package:flutter/foundation.dart';
import 'package:folk/models/NotificationModel.dart';
import 'package:folk/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _listNotification = [];
  int _notificationCount = 0;

  List<NotificationModel> get listNotification => _listNotification;
  int get notificationCount => _notificationCount;

  Future<List<NotificationModel>> startGetNotificationsData(String id) {
    _listNotification = [];

    String _url = "${Constants.SERVER_URL}notifications/fetch_all";
    return http.post(_url, body: {'user_id': id}).then((res) async {
      var convertedData = convert.jsonDecode(res.body);
      if (!convertedData['error']) {
        List data = convertedData['data'];

        _listNotification =
            data.map((item) => NotificationModel.fromJson(item)).toList();

       if(_listNotification.isNotEmpty){
          var req = await http.post(
            '${Constants.SERVER_URL}notifications/markasread',
            body: {'user_id':id});
        var res = convert.jsonDecode(req.body);
        if (!res['error']) {
          print("markedddddddddd as read");
        } else {
          print("not markedddddddddd as read");
        }
       }
      }
      notifyListeners();
      return _listNotification;
    });
  }

    Future<int> startGetNotificationsCount(String id) {
    _notificationCount = 0;

    String _url = "${Constants.SERVER_URL}notifications/getcount";
    return http.post(_url, body: {'user_id': id}).then((res) async {
      var convertedData = convert.jsonDecode(res.body);
      if (!convertedData['error']) {
        _notificationCount = convertedData['count'];
        print("notification count issssssssss $_notificationCount");
        return _notificationCount;
      }
      notifyListeners();
    });
  }
}
