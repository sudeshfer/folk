import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:folk/Models/interestModel.dart';
 
class GetInterestService {
  static const String url = 'http://morning-fortress-69187.herokuapp.com/api/interest/getall';
 
  static Future<List<Interest>> getInterests() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<Interest> list = parseInterests(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
 
  static List<Interest> parseInterests(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Interest>((json) => Interest.fromJson(json)).toList();
  }
}