import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:folk/Controllers/ApiServices/variables.dart';

class FbLoginService {
  static Future<bool> fbAuth(body) async {
    final response = await http.post('${URLS.BASE_URL}/user/loginwithfb', body: body);

    final data = response.body;

    Map<String, dynamic> user = jsonDecode(data);
    log(user['loginstatus']);
    // print(user['loginstatus']);



    if (user['loginstatus'] == 'newuser') {
      return true;
    } else {
      return false;
    }
  }
}