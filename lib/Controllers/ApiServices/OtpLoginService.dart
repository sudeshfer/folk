import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:folk/Controllers/ApiServices/variables.dart';

class OtpLoginService {
  static Future<bool> OtpAuth(body) async {
    final response = await http.post('${URLS.BASE_URL}/user/loginwithotp', body: body);

    final data = response.body;

    Map<String, dynamic> user = jsonDecode(data);
    log(user['loginstatus']);

    if (user['loginstatus'] == 'newuser') {
      return true;
    } else {
      return false;
    }
  }
}