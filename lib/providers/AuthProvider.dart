import 'package:flutter/material.dart';
import 'package:folk/models/UserModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:folk/utils/Constants.dart';


class AuthProvider with ChangeNotifier {
  io.Socket socket;

  UserModel _userModel;

  // ignore: unnecessary_getters_setters
  UserModel get userModel => _userModel;

  // ignore: unnecessary_getters_setters
  set userModel(UserModel value) {
    _userModel = value;
  }

  void updateImg(String img) {
    _userModel.img = img;
    _userModel.imagesource='userimage';
    notifyListeners();
  }

    void updateImg2(String img2) {
    _userModel.img2 = img2;
    notifyListeners();
  }
    void updateImg3(String img3) {
    _userModel.img3 = img3;
    notifyListeners();
  }
    void updateImg4(String img4) {
    _userModel.img4 = img4;
    notifyListeners();
  }
    void updateImg5(String img5) {
    _userModel.img5 = img5;
    notifyListeners();
  }

    void updateImg6(String img6) {
    _userModel.img6 = img6;
    notifyListeners();
  }

  void updateBio(String bio) {
    _userModel.bio = bio;
    notifyListeners();
  }

  void updateEmail(String email) {
    _userModel.email = email;
    notifyListeners();
  }

  void updatePhone(String phone) {
    _userModel.phoneNum = phone;
    notifyListeners();
  }

   void updateWhatudo(String whatudo) {
    _userModel.whatudo = whatudo;
    notifyListeners();
  }

  void updateCategoryString(String cat) {
    _userModel.catString = cat;
    notifyListeners();
  }

  void updateUserNameAndBio(String userName, String bio) {
    _userModel.name = userName;
    _userModel.bio = bio;
    notifyListeners();
  }

  // void startUpdateGeo(double long, double lat, String userid) async {
  //     try {
  //       final geo = {
  //       "pintype": "Point",
  //       "coordinates": [long, lat]
  //     };

  //     print("============= "+geo.toString());

  //       Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

  //         var req = await http.post('${Constants.SERVER_URL}user/update_user_location',headers: requestHeaders,
  //             body: {
  //               'user_id': '$userid',
  //               "geometry": json.encode(geo)
  //             });

  //             print("ssssssssssssssssss $userid");
  //         var res = convert.jsonDecode(req.body);
  //         if (!res['error']) {
  //           // Fluttertoast.showToast(msg: 'You requested follow ${widget.profile[0].name}');
  //           print("update geo success");
  //         }
     
  //     } catch (err) {} finally {}
  //   }

  void sendOnline() {
    var url = '${Constants.SOCKET_URL}';
    socket = io.io('$url', <String, dynamic>{
      'transports': ['websocket']
    });
    socket.on('connect', (_) {

      socket.emit('goOnline', _userModel.id);
    });

  }

  void disconnect() {
    if (socket != null) {
      socket.destroy();
    }
  }
}
