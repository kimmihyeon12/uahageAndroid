import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class bookMark {
  static bookmarkCreate(userId, place_id) async {
    String url = FlutterConfig.get('API_URL');
    var data = {"user_id": userId, "place_id": place_id};
    var response = await http.post(
      url + "/api/bookmarks",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
  }

  static bookmarkDelete(userId, place_id) async {
    String url = FlutterConfig.get('API_URL');
    var response = await http
        .delete(url + "/api/bookmarks?user_id=$userId&place_id=$place_id");
  }

  static bookmarkSelect(userId, place_id) async {
    String url = FlutterConfig.get('API_URL');
    var response = await http
        .get(url + "/api/bookmarks?user_id=$userId&place_id=$place_id");
    return json.decode(response.body)["data"]["rowCount"];
  }
}
