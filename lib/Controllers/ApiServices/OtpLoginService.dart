import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:folk/Controllers/ApiServices/variables.dart';

class LoginwithOtpService {
  static Future<bool> LoginWithOtp(body) async {

     Map<String, String> requestHeaders = {
       'Content-Type': 'application/json'
     };


    final response =
        await http.post('${URLS.BASE_URL}/user/loginwithotp', body: jsonEncode(body) , headers: requestHeaders);

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