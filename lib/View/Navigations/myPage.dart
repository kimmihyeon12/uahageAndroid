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
  String nickName = "";
  String oldNickname = "";
  String userId = "";
  String year, month, yearMonthDay, yearMonthDayTime;
  var changeimage = [false, false, false, false, false, false];
  var genderImage = [false, false];
  bool onEdit = false;
  bool isIdValid = false;
  String loginOption = "";
  String gender = "";
  String userAge = "";
  String _uploadedFileURL = "";
  File _image;
  String imageLink = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      loginOption = widget.loginOption;
      userId = widget.userId ?? "";
      // oldNickname = userId != "" ? getMyNickname().toString() : "";
    });
    // print("loginOption" + loginOption);
    // print("widgetID" + widget.userId);
    if (loginOption != "login") {
      getMyAvatar();
      getMyInfo();
    }
  }

  toast show_toast = new toast();
  getMyInfo() async {
    try {
      var response = await http.get(
          "http://211.223.46.144:3000/getMyInfo?userId=$userId$loginOption");
      var data = jsonDecode(response.body);
      print("printing info " + data.toString());
      if (data["gender"].toString() != "") {
        // var datee = data["birthday"].toString() == ""
        //     ? [""]
        //     : data["birthday"].toString().split('-');
        // dynamic dd = datee.length == 0
        //     ? data["birthday"].toString()
        //     : datee[0] + "년 " + datee[1] + "월 " + datee[2] + "일";
        if (data["gender"].toString() == "boy") {
          setState(() {
            genderImage[0] = true;
            genderImage[1] = false;
            birthday = data["birthday"].toString();
            yController.text = birthday;
          });
        } else {
          setState(() {
            genderImage[0] = false;
            genderImage[1] = true;
            birthday = data["birthday"].toString();
            yController.text = birthday;
          });
        }

        _change(data["age"].toString());
      }
    } catch (err) {
      print(err);
      // return err["message"];
    }
  }

  getMyAvatar() async {
    try {
      var response = await http.get(
          "http://211.223.46.144:3000/getAvatar/?email=$userId$loginOption");
      if (response.statusCode == 200) {
        String _imageLink = jsonDecode(response.body)["image"].toString();
        // print("response" + jsonDecode(response.body)["image"]);
        print("imgaLink " + _imageLink);
        if (_imageLink == null || _imageLink == "")
          setState(() {
            imageLink = "";
          });
        else
          setState(() {
            imageLink = _imageLink.toString();
          });
      }
    } catch (err) {
      print(err);
      return err["message"];
    }
  }

  Future deleteFile() async {
    try {
      await http
          .put(
            "http://211.223.46.144:3000/updateImage/$userId$loginOption",
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({"URL": ""}),
          )
          .then((value) => print(value.body))
          .catchError((err) => print(err));
    } catch (error) {}
  }

  Future updateNickname() async {
    Map<String, dynamic> ss = {
      "userId": userId + loginOption,
      // "oldNickname": oldNickname,
      "gender": gender,
      "birthday": birthday,
      "age": userAge,
    };
    // print(ss);
    var response = await http.post(
      "http://211.223.46.144:3000/updateNickname/$nickName",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ss),
    );
    return jsonDecode(response.body)["message"];
  }

  Future getMyNickname() async {
    var data;
    try {
      var response = await http.get(
          "http://211.223.46.144:3000/getMyNickname?userId=$userId$loginOption");
      // print("widgetID" + userId);
      if (response.statusCode == 200) {
        data = json.decode(response.body)["nickname"];

        // setState(() {
        //   userId = data.toString();
        // });
        // print("userID setst " + userId);
        return data.toString();
      }
    } catch (err) {
      print(err);
      //return data["nickname"];
    }
  }

  Future _imgFromCamera() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 20);

    setState(() {
      _image = File(image.path);
    });
    await uploadFile(_image);
  }

  Future _imgFromGallery() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 20);

    setState(() {
      _image = File(image.path);
    });
    await uploadFile(_image);
  }

  uploadFile(File file) async {
    if (imageLink != "") {
      try {
        // print(ss);
        await http.post(
          "http://211.223.46.144:3000/api/profile/deleteImage",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"fileName": imageLink}),
        );
      } catch (err) {
        print(err);
      }
    }

    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "profileImage":
            await MultipartFile.fromFile(file.path, filename: fileName),
      });
      Dio dio = new Dio();
      var response;
      try {
        response = await dio.post(
            'http://211.223.46.144:3000/api/profile/imgUpload/$userId$loginOption',
            data: formData);
        setState(() {
          _uploadedFileURL = response.data["location"];
          imageLink = _uploadedFileURL;
        });
        print("Printing after upload imagelink " + _uploadedFileURL);
        await _saveURL(_uploadedFileURL);
      } catch (err) {
        print(err);
      }
    } catch (err) {
      print(err);
    }
  }

  _saveURL(_uploadedFileURL) async {
    try {
      await http
          .put(
            "http://211.223.46.144:3000/updateImage/$userId$loginOption",
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({"URL": _uploadedFileURL}),
          )
          .then((value) => print(value.body))
          .catchError((err) => print(err));
    } catch (error) {}
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Color.fromRGBO(255, 114, 148, 1.0),
                      ),
                      title: new Text('겔러리'),
                      onTap: () async {
                        await _imgFromGallery();
                        // print("Calling upload func");

                        // print(_uploadedFileURL);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Color.fromRGBO(255, 114, 148, 1.0),
                    ),
                    title: new Text('카메라'),
                    onTap: () async {
                      await _imgFromCamera();
                      // print("Calling upload func");

                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(
                      Icons.delete_rounded,
                      color: Color.fromRGBO(255, 114, 148, 1.0),
                    ),
                    title: new Text('삭제'),
                    onTap: () async {
                      await deleteFile();
                      setState(() {
                        _image = null;
                        imageLink = "";
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future withdrawalUser() async {
    if (imageLink != "") {
      try {
        // print(ss);
        await http.post(
          "http://211.223.46.144:3000/api/profile/deleteImage",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"fileName": imageLink}),
        );
      } catch (err) {
        print(err);
      }
    }
    try {
      var res = await http
          .delete("http://211.223.46.144:3000/deleteStar/$userId$loginOption");
      print(jsonDecode(res.body));
    } catch (e) {}
    try {
      var res = await http.delete(
          "http://211.223.46.144:3000/deleteProfile/$userId$loginOption");
      print(jsonDecode(res.body));
      return jsonDecode(res.body)["message"];
    } catch (e) {}
  }

  bool isIOS = Platform.isIOS;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    FocusScopeNode currentFocus = FocusScope.of(context);
    isIOS
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
            .copyWith(
                statusBarBrightness:
                    Brightness.dark // Dark == white status bar -- for IOS.
                ))
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Color(0xffd9d4d5), // navigation bar color
            statusBarColor: Color(0xffd9d4d5), // status bar color
          ));
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

                          if (_image != null) {
                            print("1");
                            print("here " + imageLink);
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: FileImage(_image), //imageURL
                                    fit: BoxFit.cover),
                              ),
                            );
                          } else if (imageLink != "" && imageLink != null) {
                            print("2");
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(imageLink),
                                    fit: BoxFit.cover),
                              ),
                            );
                          } else {
                            print("3");
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
                          onTap: loginOption != "login"
                              ? () {
                                  _showPicker(context);
                                }
                              : () {
                                  show_toast.showToast(context, "로그인해주세요!");
                                },
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
                    Container(
                      // width: 320 .w,
                      child: userId == ""
                          ? nickNameShow("우아하게", 1500.w)
                          : FutureBuilder(
                              future: getMyNickname(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  // print("hasdata " + snapshot.data);
                                  return snapshot.data != ""
                                      ? nickNameShow(snapshot.data, 1500.w)
                                      : nickNameShow("우아하게", 1500.w);
                                } else if (snapshot.hasError) {
                                  // print("haserror " + snapshot.error);
                                  return nickNameShow(
                                      "${snapshot.error}", 1500.w);
                                }
                                return Center(
                                  child: SizedBox(
                                    height: 50.h,
                                    width: 50.w,
                                    child: buildSpinKitThreeBounce(30, 1500.w),
                                  ),
                                );
                              },
                            ),
                    ),
                    Container(
                      // margin: EdgeInsets.fromLTRB(
                      //     992 .w,
                      //     0,
                      //     148 .w,
                      //     0),
                      child:
                          loginOption == "login" // Change this on release to ==
                              ? Image.asset(
                                  "./assets/myPage/button1_grey.png",
                                  width: 361.w,
                                  height: 147.h,
                                )
                              : InkWell(
                                  onTap: () async {
                                    // print(_uploadedFileURL);
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
                                              )),
                                    );

                                    // ignore: unnecessary_statements
                                    if (result) {
                                      setState(() {
                                        _image = null;
                                      });

                                      getMyAvatar();
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
                                gender = "boy";
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
                                  gender = "girl";
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
                                  hintText: birthday == ""
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
                                        await prefs.remove("uahageUserId");
                                        await prefs.remove("uahageLoginOption");
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
                                              await prefs
                                                  .remove("uahageUserId");
                                              await prefs
                                                  .remove("uahageLoginOption");
                                              //delete data in the database
                                              showDialog(
                                                context: context,
                                                builder: (_) => FutureBuilder(
                                                  future: withdrawalUser(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      print("hasdata");
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        Navigator.of(context).pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    withdrawal()));
                                                      });
                                                    } else if (snapshot
                                                        .hasError) {
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        Navigator.of(context).pushReplacement(
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    withdrawal()));
                                                      });
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

                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => loginPage()));
                                              // Navigator.of(context)
                                              //     .popUntil((route) => route.isFirst);
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
        // maxLines: 3,
        // overflow: TextOverflow.clip,
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
    } else {
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
