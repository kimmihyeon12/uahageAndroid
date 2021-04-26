import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uahage/View/Navigations/userModifyPage.dart';
import 'package:uahage/View/Auth/withdrawal.dart';
import 'package:uahage/View/Auth/loginPage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:uahage/Widget/toast.dart ';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class myPage extends StatefulWidget {
  String loginOption;
  String userId;
  // String oldNickname;
  myPage({Key key, this.userId, this.loginOption}) : super(key: key);
  @override
  _myPageState createState() => _myPageState();
}

class _myPageState extends State<myPage> {
  TextEditingController yController = TextEditingController();

  String birthday = "";

  String oldNickname = "";
  String userId = "";
  String year, month, yearMonthDay, yearMonthDayTime;
  var changeimage = [false, false, false, false, false, false];
  var genderImage = [false, false];
  bool onEdit = false;
  bool isIdValid = false;
  String loginOption = "";
  File _image;

  SharedPreferences sharedPreferences;

  String id = "";
  String nickName = "";
  String gender = "";
  String imageLink = "";
  String userAge = "";

  String token;
  bool isloding = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      userId = widget.userId ?? "";
    });

    if (loginOption != "login") {
      getMyInfo();
    }
  }

  toast show_toast = new toast();

  // SHOW USER
  getMyInfo() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferences.getString("uahageUserToken");
      id = sharedPreferences.getString("uahageUserId");
      print(token);
      print(id);
    });
    try {
      var response = await http.get("http://112.187.123.29:8000/api/users/$id",
          headers: <String, String>{"Authorization": token});

      if (jsonDecode(response.body)['message'] == 'finded successfully') {
        var data = jsonDecode(response.body)['data']["result"][0];
        setState(() {
          isloding = true;
          //setting id
          id = data["id"].toString();

          //setting nickname
          nickName = data["nickname"];

          // setting baby_birthday
          birthday = data["baby_birthday"];
          yController.text = birthday;

          // setting baby_gender
          if (data['baby_gender'].toString() == "F") {
            genderImage[0] = false;
            genderImage[1] = true;
          } else if (data['baby_gender'].toString() == "M") {
            genderImage[0] = true;
            genderImage[1] = false;
          }

          // setting age
          _change(data["parent_age"].toString());

          // setting image
          imageLink = data["profile_url"];
        });
      }
    } catch (err) {
      print(err);
    }
  }

  // DELETE USER
  Future withdrawalUser() async {
    //????????????????
    if (imageLink != "") {
      try {
        await http.post(
          "http://112.187.123.29:3000/api/profile/deleteImage",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"fileName": imageLink}),
        );
      } catch (err) {}
    }

    try {
      var res = await http.delete("http://112.187.123.29:8000/api/users/$id",
          headers: <String, String>{"Authorization": token});
      var data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return data["message"];
      } else {
        throw (data["message"]);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    FocusScopeNode currentFocus = FocusScope.of(context);

    var _fontsize = 52.5.sp;
    var textStyle52 = TextStyle(
      color: const Color(0xffb1b1b1),
      fontWeight: FontWeight.w500,
      fontFamily: "NotoSansCJKkr_Medium",
      fontStyle: FontStyle.normal,
      fontSize: 52.sp,
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Center avatar
              Padding(
                padding: EdgeInsets.only(top: 150.h),
              ),
              Center(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 439.h,
                      width: 439.w,
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage("./assets/myPage/avatar.png"),
                        child: (() {
                          // your code here

                          if (imageLink != "" && imageLink != null) {
                            //print("2 $imageLink");
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(imageLink),
                                    fit: BoxFit.cover),
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image:
                                      AssetImage("./assets/myPage/avatar.png"),
                                ),
                              ),
                            );
                          }
                        }()),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        // margin: EdgeInsets.fromLTRB(
                        //     330 .w, 341 .h, 0, 0),
                        child: InkWell(
                          child: Image.asset(
                            "./assets/myPage/camera.png",
                            height: 109.h,
                            width: 110.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Nickname
              Container(
                margin: EdgeInsets.only(top: 31.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (() {
                      if (isloding) {
                        Container(
                            child: nickName == null
                                ? nickNameShow("우아하게", 1500.w)
                                : nickNameShow(nickName, 1500.w));
                      } else {
                        return Center(
                          child: SizedBox(
                            height: 50.h,
                            width: 50.w,
                            child: buildSpinKitThreeBounce(30, 1500.w),
                          ),
                        );
                      }
                    }()),
                    Container(
                      child:
                          loginOption == "login" // Change this on release to ==
                              ? Image.asset(
                                  "./assets/myPage/button1_grey.png",
                                  width: 361.w,
                                  height: 147.h,
                                )
                              : InkWell(
                                  onTap: () async {
                                    // //print(_uploadedFileURL);
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => UserModify(
                                                loginOption: loginOption,
                                                userId: userId,
                                                recievedImage: _image == null
                                                    ? imageLink == ""
                                                        ? null
                                                        : imageLink
                                                    : _image,
                                                id: id,
                                                token: token,
                                              )),
                                    );
                                    if (result) {
                                      setState(() {
                                        _image = null;
                                      });
                                      getMyInfo();
                                    }
                                  },
                                  child: Image.asset(
                                    "./assets/myPage/button1_pink.png",
                                    width: 361.w,
                                    height: 147.h,
                                  ),
                                ),
                    )
                  ],
                ),
              ),

              //Gender
              Container(
                margin: EdgeInsets.fromLTRB(99.w, 35.h, 0, 0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 아이성별
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 24.h, 56.w, 0),
                      child: Text("아이성별",
                          style: TextStyle(
                              color: const Color(0xffff7292),
                              fontFamily: "NotoSansCJKkr_Medium",
                              fontSize: 57.sp),
                          textAlign: TextAlign.left),
                    ),
                    InkWell(
                      onTap: onEdit
                          ? () {
                              setState(() {
                                gender = "M";
                                genderImage[0] = !genderImage[0];
                                genderImage[1] = false;
                              });
                            }
                          : null,
                      child: Image.asset(
                        genderImage[0]
                            ? "./assets/myPage/boy_pink.png"
                            : "./assets/myPage/boy_grey.png",
                        height: 363.h,
                        width: 262.w,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 98.w),
                      child: InkWell(
                        onTap: onEdit
                            ? () {
                                setState(() {
                                  gender = "F";
                                  genderImage[1] = !genderImage[1];
                                  genderImage[0] = false;
                                });
                              }
                            : null,
                        child: Image.asset(
                          genderImage[1]
                              ? "./assets/myPage/girl_pink.png"
                              : "./assets/myPage/girl_grey.png",
                          height: 363.h,
                          width: 262.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Birthday

              Container(
                margin: EdgeInsets.fromLTRB(99.w, 5.h, 0, 0),
                child: Row(
                  children: [
                    // 아이생일
                    Text("아이생일",
                        style: TextStyle(
                          fontSize: 57.sp,
                          color: const Color(0xffff7292),
                          fontFamily: "NotoSansCJKkr_Medium",
                        ),
                        textAlign: TextAlign.left),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(82.w, 0, 121.w, 0),
                        child: Stack(
                          children: [
                            AbsorbPointer(
                              child: TextFormField(
                                readOnly: true,
                                controller: yController,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color(0xffff7292),
                                    fontSize: 57.sp,
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
                                  hintText: birthday == null
                                      ? '생년월일을 선택해주세요'
                                      : birthday,
                                  hintStyle: TextStyle(
                                      color: Color(0xffd4d4d4),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 57.0.sp),
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
              // Ages
              Container(
                margin: EdgeInsets.fromLTRB(155.w, 91.h, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 보호자 연령대
                    Text("보호자\n연령대",
                        style: TextStyle(
                          color: const Color(0xffff7292),
                          fontWeight: FontWeight.w500,
                          fontFamily: "NotoSansCJKkr_Medium",
                          fontSize: 57.sp,
                        ),
                        textAlign: TextAlign.right),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 59.w),
                                child: Image.asset(
                                  changeimage[0]
                                      ? './assets/registrationPage/10_pink.png'
                                      : './assets/registrationPage/10_grey.png',
                                  height: 194.h,
                                  width: 249.w,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 55.w),
                                child: Image.asset(
                                  changeimage[1]
                                      ? './assets/registrationPage/20_pink.png'
                                      : './assets/registrationPage/20_grey.png',
                                  height: 194.h,
                                  width: 249.w,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 55.w),
                                child: Image.asset(
                                  changeimage[2]
                                      ? './assets/registrationPage/30_pink.png'
                                      : './assets/registrationPage/30_grey.png',
                                  height: 194.h,
                                  width: 249.w,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 59.w, top: 45.h),
                                child: Image.asset(
                                  changeimage[3]
                                      ? './assets/registrationPage/40_pink.png'
                                      : './assets/registrationPage/40_grey.png',
                                  height: 194.h,
                                  width: 249.w,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 55.w, top: 45.h),
                                child: Image.asset(
                                  changeimage[4]
                                      ? './assets/registrationPage/50_pink.png'
                                      : './assets/registrationPage/50_grey.png',
                                  height: 194.h,
                                  width: 249.w,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 55.w, top: 45.h),
                                child: Image.asset(
                                  changeimage[5]
                                      ? './assets/registrationPage/others_pink.png'
                                      : './assets/registrationPage/others_grey.png',
                                  height: 194.h,
                                  width: 249.w,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Ok Button

              //logout

              userId != ""
                  ? Container(
                      margin: EdgeInsets.fromLTRB(
                          931.w, onEdit ? 88.h : 370.h, 0, 71.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  title: // 로그아웃 하시겠습니까?
                                      Text("로그아웃 하시겠습니까?",
                                          style: TextStyle(
                                              color: const Color(0xff4d4d4d),
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  "NotoSansCJKkr_Medium",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 55.sp),
                                          textAlign: TextAlign.left),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: // 아니요
                                          Text("아니요",
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xffff7292),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      "NotoSansCJKkr_Medium",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: _fontsize),
                                              textAlign: TextAlign.left),
                                    ),
                                    FlatButton(
                                      onPressed: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        // await prefs.remove("uahageUserEmail");
                                        // await prefs.remove("uahageLoginOption");
                                        await prefs.clear();
                                        Navigator.pop(context);

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  loginPage()),
                                          (Route<dynamic> route) => false,
                                        );
                                        // Navigator.of(context)
                                        //     .popUntil((route) => route.isFirst);
                                      },
                                      child: // 네
                                          Text("네",
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xffff7292),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      "NotoSansCJKkr_Medium",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: _fontsize),
                                              textAlign: TextAlign.left),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: // 로그아웃
                                Text(
                              "로그아웃",
                              style: textStyle52,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15.w, right: 15.w),
                            child: Text(
                              "|",
                              style: textStyle52,
                            ),
                          ),
                          InkWell(
                            onTap: loginOption == "login"
                                ? () {
                                    show_toast.showToast(context, "로그인해주세요!");
                                  }
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                        ),
                                        title: Text(
                                            "탈퇴하시겠습니까? 탈퇴 시 기존 데이터를 복구할 수 없습니다.",
                                            style: TextStyle(
                                                color: const Color(0xff4d4d4d),
                                                fontWeight: FontWeight.w500,
                                                fontFamily:
                                                    "NotoSansCJKkr_Medium",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 55.sp),
                                            textAlign: TextAlign.left),
                                        actions: [
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: // 아니요
                                                Text("아니요",
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xffff7292),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "NotoSansCJKkr_Medium",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: _fontsize),
                                                    textAlign: TextAlign.left),
                                          ),
                                          FlatButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.clear();

                                              //delete data in the database
                                              showDialog(
                                                context: context,
                                                builder: (_) => FutureBuilder(
                                                  future: withdrawalUser(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) async {
                                                        await prefs.clear();
                                                        Navigator.of(context).pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    withdrawal()));
                                                      });
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "${snapshot.error}"),
                                                      );
                                                    }

                                                    return Center(
                                                      child: SizedBox(
                                                          height: 200.h,
                                                          width: 200.w,
                                                          child:
                                                              buildSpinKitThreeBounce(
                                                                  80, 1500.w)
                                                          //     CircularProgressIndicator(
                                                          //   strokeWidth: 5.0,
                                                          //   valueColor:
                                                          //       new AlwaysStoppedAnimation<
                                                          //           Color>(
                                                          //     Colors.pinkAccent,
                                                          //   ),
                                                          // )
                                                          ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            child: // 네
                                                Text("네",
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xffff7292),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "NotoSansCJKkr_Medium",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: _fontsize),
                                                    textAlign: TextAlign.left),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                            child: // 로그아웃   |   회원탈퇴
                                Text("회원탈퇴",
                                    style: textStyle52,
                                    textAlign: TextAlign.left),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.fromLTRB(
                          931.w, onEdit ? 88.h : 370.h, 0, 71.h),
                      child: InkWell(
                          child: Text("로그인하기",
                              style: textStyle52, textAlign: TextAlign.left),
                          onTap: () {
                            Navigator.of(context).pop();
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  Text nickNameShow(String txt, double screenHeight) {
    return Text(txt,
        style: TextStyle(
            color: const Color(0xff3a3939),
            fontFamily: "NotoSansCJKkr_Bold",
            fontSize: 70.sp),
        textAlign: TextAlign.center);
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
    } else if (age == '60') {
      setState(() {
        userAge = ">60";
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
