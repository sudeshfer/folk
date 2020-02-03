import 'dart:convert';
import 'dart:developer';

import 'package:folk/Controllers/ApiServices/variables.dart';
import 'package:http/http.dart' as http;

class LoginwithFBService {
  static Future<bool> LoginWithFB(body) async {

     Map<String, String> requestHeaders = {
       'Content-Type': 'application/json'
     };


    final response =
        await http.post('${URLS.BASE_URL}/user/loginwithfb', body: jsonEncode(body) , headers: requestHeaders);

    var data = response.body;
    print(body);
    print(json.decode(data));

    Map<String, dynamic> res_data = jsonDecode(data);
    log(res_data['loginstatus']);
    if (res_data['loginstatus'] == 'olduser') {
      return true;
    } else {
      return false;
    }
    // return false;
  }
}