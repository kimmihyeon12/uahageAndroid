
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

import 'package:uahage/Model//Restaurant_helper.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:uahage/Model/Kids_cafe_helper.dart';
import 'package:uahage/Model/experience_center_helper.dart';
import 'package:uahage/Model/examination_institution_helper.dart';

class places{

  static placeCode(tableType){
    var place_code = 0;
    if (tableType == 'restaurant') {
      place_code = 1;
    } else if (tableType == 'Examination_institution') {
      place_code = 2;
    } else if (tableType == 'Experience_center') {
      place_code = 6;
    } else if (tableType == 'Kids_cafe') {
      place_code = 5;
    }
    return place_code;
  }
  static Future<List<dynamic>> getList(data,tableType,latitude,longitude,pageNumber,userId) async {
    String url = FlutterConfig.get('API_URL');


    List<dynamic> sortedListData = data;
    var place_code = 0;
    place_code = placeCode(tableType);


    final response = await http.get(
        url+'/api/places?place_code=$place_code&lat=$latitude&lon=$longitude&pageNumber=$pageNumber&user_id=$userId');
    List responseJson = json.decode(response.body)["data"]["rows"];
    if (json.decode(response.body)["message"] == false) {
    } else {
      var currentData;
      for (var data in responseJson) {
        print(data);
        if (tableType == 'restaurant') {
          currentData = Restaurant.fromJson(data);
        } else if (tableType == 'Examination_institution') {
          currentData = examinationinstitution.fromJson(data);
        } else if (tableType == 'Experience_center') {
          currentData = Experiencecenter.fromJson(data);
        } else if (tableType == 'Kids_cafe') {
          currentData = KidsCafe.fromJson(data);
        }
        print(currentData);
        sortedListData.add(currentData);
      }


    }
    return sortedListData;
  }

}