import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class auth {
  //LOGIN
  static Future signIn(Email, loginOption) async {
    String url = FlutterConfig.get('API_URL');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userId;

    Map<String, dynamic> userData = {
      "email": "'$Email$loginOption'",
    };
    var response = await http.post(
      url + "/api/auth/signin",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      String token = data['data']['token'];
      userId = data['data']['id'].toString();

      //save user info
      await sharedPreferences.setString("uahageUserToken", token);
      await sharedPreferences.setString("uahageUserId", userId);
      return userId;
    }
  }

  //REGISTER
  static Future signUp(
      type, Email, loginOption, nickName, gender, birthday, userAge) async {
    String url = FlutterConfig.get('API_URL');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userId;
    bool saveError = true;
    Map<String, dynamic> userData = type == "withNickname"
        ? {
            "email": "'$Email$loginOption'",
            "nickname": "'$nickName'",
            "gender": "'$gender'",
            "birthday": "'$birthday'",
            "age": userAge,
            "URL": null,
            "rf_token": null
          }
        : {
            "email": "'$Email$loginOption'",
            "nickname": null,
            "gender": null,
            "birthday": null,
            "age": null,
            "URL": null,
            "rf_token": null
          };
    try {
      var response = await http.post(
        url + "/api/auth/signup",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String token = data['data']['token'];
        userId = data['data']['id'].toString();

        //save user info
        await sharedPreferences.setString("uahageUserToken", token);
        await sharedPreferences.setString("uahageUserId", userId);

        return userId;
      } else {
        return saveError;
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  //CHECK THE EMAIL
  static Future checkEmail(Email, loginOption) async {
    String url = FlutterConfig.get('API_URL');
    var response = await http.get(url +
        "/api/users/find-by-option?option=email&optionData='${Email}${loginOption}'");
    return jsonDecode(response.body)["isdata"] == 0 ? true : false;
  }

//CHECK THE NICKNAME
  static Future checkNickName(nickName) async {
    bool isIdValid = false;
    String url = FlutterConfig.get('API_URL');
    try {
      var response = await http.get(
        url +
            "/api/users/find-by-option?option=nickname&optionData='${nickName}'",
      );
      print("isdata nickname" + jsonDecode(response.body)["isdata"].toString());
      if (jsonDecode(response.body)["isdata"] == 0) {
        isIdValid = true;

        return isIdValid;
      } else {
        isIdValid = false;

        return isIdValid;
      }
    } catch (err) {
      print(err);
      return Future.error(err);
    }
  }
}
