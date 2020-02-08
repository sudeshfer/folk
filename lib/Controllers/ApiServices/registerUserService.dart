import 'dart:convert';
import 'dart:developer';

import 'package:folk/Controllers/ApiServices/variables.dart';
import 'package:http/http.dart' as http;

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
      return true;
    } else {
      log(res_data['message']);
      return false;
    }
    // return true;
  }
}