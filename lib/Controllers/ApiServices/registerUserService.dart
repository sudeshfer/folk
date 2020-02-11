import 'dart:convert';
import 'dart:developer';

import 'package:folk/Controllers/ApiServices/variables.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUserService {
  static Future<bool> RegisterUser(body) async {

    print(body);

     Map<String, String> requestHeaders = {
       'Content-Type': 'application/json'
     };


    final response =
        await http.post('${URLS.BASE_URL}/user/register', body: jsonEncode(body) , headers: requestHeaders);

    var data = response.body;
    // print(body);
    print(json.decode(data));

    Map<String, dynamic> res_data = jsonDecode(data);
    log(res_data.toString());
    if (res_data['loginstatus'] == 'olduser') {
      final _token = res_data['token'];
      print(_token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", _token);
      return true;
    } else {
      log(res_data['message']);
      return false;
    }
    // return true;
  }
}