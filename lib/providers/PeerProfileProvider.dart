import 'package:flutter/foundation.dart';
import 'package:folk/models/UserModel.dart';
import 'package:folk/models/peerProfileModel.dart';
import 'package:folk/utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PeerProfileProvider with ChangeNotifier {
  List<PeerProfileModel> _listProfile = [];


  List<PeerProfileModel> get listProfile => _listProfile;

  Future<List<PeerProfileModel>> startGetPeerProfile(String id, String peerid) {
    _listProfile = [];
    var temp = [];

    String _url = "${Constants.SERVER_URL}user/get";
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    
    return http.post(_url,headers: requestHeaders, body: convert.json.encode({'user_id': id, 'peer_id': peerid})).then((res) async {
      
      var convertedData = convert.jsonDecode(res.body);
      if (!convertedData['error']) {
        temp.add(convertedData['data']);
        List data = temp;
        // print("workingggggggggggggggggggggg huttoo $data");
          
        _listProfile =
            data.map((item) => PeerProfileModel.fromJson(item)).toList();

            print("length issssssssssssssssssss ${_listProfile.length}");
      }
      notifyListeners();
      return _listProfile;
    });
  }
}
