import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:uahage/View/Navigations/Navigationbar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/Widget/appBar.dart';
import 'package:uahage/Widget/showDialog.dart';
import 'package:flutter_config/flutter_config.dart';

class registrationPage extends StatefulWidget {
  String Email;
  String loginOption;
  registrationPage({Key key, this.Email, this.loginOption}) : super(key: key);
  @override
  _registrationPageState createState() => _registrationPageState();
}

class _registrationPageState extends State<registrationPage> {
  //gender image , gender image color
  bool isIOS = Platform.isIOS;
  String url;
  var boy = true;
  var girl = true;
  var boy_image = [
    './assets/registrationPage/boy_grey.png',
    './assets/registrationPage/boy_pink.png'
  ];
  var girl_image = [
    './assets/registrationPage/girl_grey.png',
    './assets/registrationPage/girl_pink.png'
  ];
  String birthday = "";
  String nickName = "";
  bool isIdValid = false;
  String loginOption = "";
  String gender = "";
  String userAge = "";
  String Email = "";
  String userId = "";
  bool saveError = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      url = FlutterConfig.get('API_URL');
      loginOption = widget.loginOption;
      Email = widget.Email;
    });
  }

//check nickname
  Future checkNickName() async {
   try {
      var response = await http.get(
        url+"/api/users/find-by-option?option=nickname&optionData='${nickName}'",
      );
     print("isdata nickname"+jsonDecode(response.body)["isdata"].toString());
      if (jsonDecode(response.body)["isdata"]==0) {
        setState(() {
          isIdValid = true;
        });
        return "사용 가능한 닉네임입니다.";
      } else {
        setState(() {
          isIdValid = false;
        });
        return "이미 사용중인 닉네임입니다.";
      }
    } catch (err) {
      print(err);
      return Future.error(err);
    }
  }

  Future signUp(String type) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

<<<<<<< HEAD
    Map<String, dynamic> ss = type == "withNickname"
        ? {
            "email": userId + loginOption,
            "nickname": nickName,
            "gender": gender,
            "birthday": birthday,
            "age": userAge,
            "URL": "",
            "rf_token": ""
          }
        : {
            "email": userId + loginOption,
            "nickname": null,
            "gender": "",
            "birthday": "",
            "age": 0,
            "URL": "",
            "rf_token": ""
          };
    print(ss);
    try {
      var response = await http.post(
        "http://121.147.203.126:8000/api/auth/signup",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(ss),
      );
      if (response.statusCode == 200) {
        setState(() {
          saveError = false;
        });
        var data = jsonDecode(response.body);
        String token = data['data']['token'];
        String id = data['data']['id'].toString();
        print("token $token");
        await sharedPreferences.setString("uahageUserToken", token);
        await sharedPreferences.setString("uahageUserId", id);

=======
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
        url+"/api/auth/signup",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        setState(() {
          saveError = false;
        });
        var data = jsonDecode(response.body);
        String token = data['data']['token'];
        setState(() {
          userId = data['data']['id'].toString();
          print(token);
          print(userId);
        });
        //save user info
        await sharedPreferences.setString("uahageUserToken", token);
        await sharedPreferences.setString("uahageUserId", userId);

>>>>>>> 9532aaed86128037138a8249efd8856c3009d9f9
        return data["message"];
      } else {
        setState(() {
          saveError = true;
        });
        return Future.error(jsonDecode(response.body)["message"]);
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  // year calendar
  String year, month, yearMonthDay, yearMonthDayTime;
  TextEditingController yController = TextEditingController();
  var changeimage = [false, false, false, false, false, false];
  appbar bar = new appbar();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    var _fontsize = 62.5.sp;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    FocusScopeNode currentFocus = FocusScope.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: bar.navHome_abbbar("회원가입", context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 250.h)),

              //membership_Nickname

              Container(
                child: Container(
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 150.w)),
                      Text(
                        "닉네임",
                        style: TextStyle(
                            fontSize: 58.sp,
                            color: Color.fromARGB(255, 255, 114, 148),
                            fontFamily: 'NotoSansCJKkr_Medium'),
                      ),
                      Padding(padding: EdgeInsets.only(left: 88.w)),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(right: 121.sp),
                          child: Stack(
                            children: [
                              TextFormField(
                                onChanged: (value) {
                                  if (value.length <= 10)
                                    setState(() {
                                      nickName = value;
                                    });
                                },
                                maxLength: 10,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: const Color(0xff3a3939),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 62.5.sp,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(right: 410.w),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xffff7292),
                                    ),

                                    //Color.fromRGBO(255, 114, 148, 1.0)
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Color(0xffff7292)),
                                  ),
                                  hintText: '닉네임을 입력하세요',
                                  hintStyle: TextStyle(
                                      color: Color(0xffcccccc),
                                      fontSize: 58.sp,
                                      letterSpacing: -1.0),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 350.w,
                                  height: 125.h,
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                      new BorderRadius.circular(8.0),
                                    ),
                                    onPressed: nickName != ""
                                        ? () {
                                      currentFocus.unfocus();
                                      buildShowDialogOnOk(
                                          checkNickName(),
                                          context,
                                          200.h,
                                          200.w,
                                          80.w,
                                          1501.w,
                                          62.5.sp);
                                    }
                                        : () {},
                                    color: nickName == ""
                                        ? Color(0xffcacaca)
                                        : Color(0xffff7292),
                                    child: Text(
                                      "중복확인",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'NotoSansCJKkr_Medium',
                                        fontSize: 58.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 110.h)),

              //baby_Gender
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 91.w)),
                    Container(
                      child: Text(
                        "아이성별",
                        style: TextStyle(
                            fontSize: 58.sp,
                            color: Color.fromARGB(255, 255, 114, 148),
                            fontFamily: 'NotoSansCJKkr_Medium'),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 80.w)),
                    InkWell(
                      onTap: () {
                        _pressedbaby('M');
                      },
                      child: Column(children: <Widget>[
                        Container(
                          height: 362.h,
                          width: 262.w,
                          child: Image.asset(boy ? boy_image[0] : boy_image[1]),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 11)),
                      ]),
                    ),
                    Padding(padding: EdgeInsets.only(left: 98.w)),
                    InkWell(
                      onTap: () {
                        _pressedbaby('F');
                      },
                      child: Column(children: <Widget>[
                        Container(
                          height: 362.h,
                          width: 262.w,
                          child:
                          Image.asset(girl ? girl_image[0] : girl_image[1]),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 11)),
                      ]),
                    ),
                  ]),

              //baby_birtyday
              Container(
                margin: EdgeInsets.fromLTRB(99.w, 20.h, 0, 0),
                child: Row(
                  children: [
                    // 아이생일
                    Text(
                      "아이생일",
                      style: TextStyle(
                          fontSize: 58.sp,
                          color: Color.fromARGB(255, 255, 114, 148),
                          fontFamily: 'NotoSansCJKkr_Medium'),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(82.w, 0, 118.w, 0),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: yearPicker,
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: yController,
                                  // onChanged: (txt) {
                                  //   setState(() {
                                  //     birthday = txt;
                                  //   });
                                  // },
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xffff7292),
                                      fontSize: 73.sp,
                                      fontFamily: 'NotoSansCJKkr_Medium',
                                      fontStyle: FontStyle.normal,
                                      letterSpacing: -1.0),
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: const Color(0xffff7292),
                                      ),
                                      //Color.fromRGBO(255, 114, 148, 1.0)
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xffff7292)),
                                    ),
                                    hintText: '생년월일을 선택해주세요',
                                    hintStyle: TextStyle(
                                        color: Color(0xffd4d4d4),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontSize: 58.0.sp),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  yearPicker();
                                },
                                icon: Image.asset(
                                  './assets/registrationPage/calendar.png',
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(0, 98.h, 0, 0.h),
              ),
              //Parental age group

              Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 147.w)),
                    Text(
                      "보호자\n 연령대",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 57.sp,
                          color: Color.fromARGB(255, 255, 114, 148),
                          fontFamily: 'NotoSansCJKkr_Medium'),
                    ),
                    Padding(padding: EdgeInsets.only(left: 62.w)),
                    InkWell(
                      child: Image.asset(
                        changeimage[0]
                            ? './assets/registrationPage/10_pink.png'
                            : './assets/registrationPage/10_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        _change('10');
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 55.w)),
                    InkWell(
                      child: Image.asset(
                        changeimage[1]
                            ? './assets/registrationPage/20_pink.png'
                            : './assets/registrationPage/20_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        _change('20');
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 55.w)),
                    InkWell(
                      child: Image.asset(
                        changeimage[2]
                            ? './assets/registrationPage/30_pink.png'
                            : './assets/registrationPage/30_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        _change('30');
                      },
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 25.w)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 147.w)),
                    Text(
                      "보호자\n 연령대",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: 57.sp,
                          color: Colors.transparent,
                          fontFamily: 'NotoSansCJKkr_Medium'),
                    ),
                    Padding(padding: EdgeInsets.only(left: 62.w)),
                    InkWell(
                      child: Image.asset(
                        changeimage[3]
                            ? './assets/registrationPage/40_pink.png'
                            : './assets/registrationPage/40_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        _change('40');
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 55.w)),
                    InkWell(
                      child: Image.asset(
                        changeimage[4]
                            ? './assets/registrationPage/50_pink.png'
                            : './assets/registrationPage/50_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        _change('50');
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 55.w)),
                    InkWell(
                      child: Image.asset(
                        changeimage[5]
                            ? './assets/registrationPage/others_pink.png'
                            : './assets/registrationPage/others_grey.png',
                        height: 196.h,
                        width: 251.w,
                      ),
                      onTap: () {
                        _change('ohters');
                      },
                    ),
                  ],
                ),
              ]),
              Padding(padding: EdgeInsets.only(top: 125.h)),

              //ok button
              Container(
                width: 1193.w,
                height: 194.h,
                // margin: EdgeInsets.only(bottom: 70/(2667/ScreenHeight)),
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  onPressed: isIdValid &&
                      userAge != "" &&
                      birthday != "" &&
                      birthday != "" &&
                      nickName != ""
                      ? () async {

                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => FutureBuilder(
                          future: signUp("withNickname"),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                Navigator.pop(context);
                                saveError
                                    ? null
                                    : Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          navigationPage(
                                              oldNickname: nickName,
                                              userId: userId,
                                              loginOption:
                                              loginOption),
                                    ));
                              });
                            } else if (snapshot.hasError)
                              return buildAlertDialog(
                                  snapshot, 1500.h, context, _fontsize);

                            return buildCenterProgress(1500.h, 2667.h);
                          }),
                    );
                  }
                      : () {},
                  color: isIdValid &&
                      userAge != "" &&
                      birthday != "" &&
                      birthday != "" &&
                      nickName != ""
                      ? Color(0xffff7292)
                      : Color(0xffcccccc),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'NotoSansCJKkr_Medium',
                      fontSize: 57.sp,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 270.h)),

              //next
              Center(
                child: FlatButton(
                  onPressed: () async {
                    // SharedPreferences prefs =
                    // await SharedPreferences.getInstance();
                    //
                    // await prefs.setString('uahageUserId', Email);
                    // await prefs.setString("uahageLoginOption", loginOption);
                    showDialog(
                      context: context,
                      builder: (context) => FutureBuilder(
                        future: signUp(""),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              Navigator.pop(context);
                              if (!saveError) {
                                // SharedPreferences prefs =
                                // await SharedPreferences.getInstance();
                                //
                                // await prefs.setString(
                                //     'uahageUserEmail', Email);
                                // await prefs.setString(
                                //     "uahageLoginOption", loginOption);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => navigationPage(
                                        userId: userId,
                                        loginOption: loginOption),
                                  ),
                                );
                              }
                            });
                          } else if (snapshot.hasError) {
                            buildAlertDialog(
                                snapshot, 1500.w, context, _fontsize);
                          }
                          return buildCenterProgress(2667.h, 1500.w);
                        },
                      ),
                    );
                  },
                  child: Text(
                    "건너뛰기",
                    style: TextStyle(
                      color: Color.fromRGBO(255, 114, 148, 1.0),
                      fontFamily: 'NotoSansCJKkr_Medium',
                      fontSize: 58.sp,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Center buildCenterProgress(double screenHeight, double screenWidth) {
    return Center(
      child: SizedBox(
          height: 200.h,
          width: 200.w,
          child: buildSpinKitThreeBounce(80, screenWidth)
        // CircularProgressIndicator(
        //   strokeWidth: 5.0,
        //   valueColor: new AlwaysStoppedAnimation<Color>(
        //     Colors.pinkAccent,
        //   ),
        // )
      ),
    );
  }

  AlertDialog buildAlertDialog(AsyncSnapshot snapshot, double screenWidth,
      BuildContext context, double _fontsize) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title:
      // id already exists.
      Text("${snapshot.error}",
          style: TextStyle(
              color: Color(0xff4d4d4d),
              fontWeight: FontWeight.w500,
              fontFamily: "NotoSansCJKkr_Medium",
              fontStyle: FontStyle.normal,
              fontSize: 62.5.sp),
          textAlign: TextAlign.left),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: // 확인
            buildText(_fontsize))
      ],
    );
  }

  //gender event
  _pressedbaby(String value) {
    print(value);
    print(boy);
    if (value == 'M') {
      if (boy) {
        setState(() {
          gender = value;
          boy = false;
          girl = true;
        });
      }
    }
    if (value == 'F') {
      if (girl) {
        setState(() {
          gender = value;
          girl = false;
          boy = true;
        });
      }
    }
  }

  //picker(캘린더)
  yearPicker() {
    final year = DateTime.now().year;
    // double screenHeight = 2667 / MediaQuery.of(context).size.height;
    // double screenWidth = 1501 / MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Text(
            '생년월일을 입력하세요',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(255, 114, 148, 1.0),
              fontSize: 56.sp,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
              height: MediaQuery.of(context).size.height / 5.0,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newDate) async {
                  var datee = newDate.toString().substring(0, 10).split('-');
                  yController.text =
                      datee[0] + "년 " + datee[1] + "월 " + datee[2] + "일";
                },
                minimumYear: 2000,
                maximumYear: year,
                mode: CupertinoDatePickerMode.date,
              )),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '확인',
                style: TextStyle(
                  color: Color.fromRGBO(255, 114, 148, 1.0),
                  fontFamily: 'NotoSansCJKkr_Medium',
                  fontSize: 57.sp,
                ),
              ),
              onPressed: () {
                setState(() {
                  birthday = yController.text;
                  Navigator.of(context).pop();
                });
              },
            ),
            // FlatButton(
            //   child: Text(
            //     '아니요',
            //     style: TextStyle(
            //       color: Color.fromRGBO(255, 114, 148, 1.0),
            //       fontFamily: 'NotoSansCJKkr_Medium',
            //       fontSize: 57 .h,
            //     ),
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        );
      },
    );
  }

  //changimagecolor
  void _change(String age) {
    if (age == '10') {
      setState(() {
        userAge = "10";
        changeimage[0] = true;
        changeimage[1] = false;
        changeimage[2] = false;
        changeimage[3] = false;
        changeimage[4] = false;
        changeimage[5] = false;
      });
    } else if (age == '20') {
      setState(() {
        userAge = "20";
        changeimage[0] = false;
        changeimage[1] = true;
        changeimage[2] = false;
        changeimage[3] = false;
        changeimage[4] = false;
        changeimage[5] = false;
      });
    } else if (age == '30') {
      setState(() {
        userAge = "30";
        changeimage[0] = false;
        changeimage[1] = false;
        changeimage[2] = true;
        changeimage[3] = false;
        changeimage[4] = false;
        changeimage[5] = false;
      });
    } else if (age == '40') {
      setState(() {
        userAge = "40";
        changeimage[0] = false;
        changeimage[1] = false;
        changeimage[2] = false;
        changeimage[3] = true;
        changeimage[4] = false;
        changeimage[5] = false;
      });
    } else if (age == '50') {
      setState(() {
        userAge = "50";
        changeimage[0] = false;
        changeimage[1] = false;
        changeimage[2] = false;
        changeimage[3] = false;
        changeimage[4] = true;
        changeimage[5] = false;
      });
    } else {
      setState(() {
        userAge = "60";
        changeimage[0] = false;
        changeimage[1] = false;
        changeimage[2] = false;
        changeimage[3] = false;
        changeimage[4] = false;
        changeimage[5] = true;
      });
    }
  }
}
