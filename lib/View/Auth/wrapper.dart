import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uahage/View/Navigations//Navigationbar.dart';
import 'package:uahage/View/Auth/loginPage.dart';

class Wrapper extends StatefulWidget {
 //email check page
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String userId = "";


  @override
  void initState() {
    super.initState();
    _loadUserId();

  }

  _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('uahageUserId') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userId == "") {
      return loginPage();
    } else {
      return navigationPage(
        userId: userId
      );
    }
  }
}
