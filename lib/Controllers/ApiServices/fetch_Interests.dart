import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:folk/Controllers/ApiServices/variables.dart';

class GetInterests {
  static Future<List<dynamic>> getInterests() async {
    final response = await http.get('${URLS.BASE_URL}/interest/getall');

    // final data = response.body;

    if (response != null) {
      log("Interests are fetched");
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
