import 'dart:convert';
import 'dart:developer';
import 'package:folk/Controllers/ApiServices/variables.dart';
import 'package:http/http.dart' as http;

class VerifyEmailService {
  static Future<bool> VerifyEmail(body) async {

     Map<String, String> requestHeaders = {
       'Content-Type': 'application/json'
     };


    final response =
        await http.post('${URLS.BASE_URL}/mail/verifyemail', body: jsonEncode(body) , headers: requestHeaders);

    var data = response.body;
    // print(body);
    print(json.decode(data));

    Map<String, dynamic> res_data = jsonDecode(data);
    // log(res_data['loginstatus']);
    if (res_data['loginstatus'] == 'olduser') {
      return true;
    } else {
      return false;
    }
    // return false;
  }
}