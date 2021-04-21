import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:uahage/View/Navigations/Navigationbar.dart';
import 'package:uahage/View/Auth/announce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:uahage/Widget//showDialog.dart';
import 'registrationPage.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/Widget//appBar.dart';

class agreementPage extends StatefulWidget {
  agreementPage({Key key, this.loginOption}) : super(key: key);

  final String loginOption;
  @override
  _agreementPageState createState() => _agreementPageState();
}

class _agreementPageState extends State<agreementPage> {
  //kakao login----------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------
  bool _isKakaoTalkInstalled = false;
  String _accountEmail = "";

  bool isAlreadyRegistered = false;

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao Install : ' + installed.toString());

    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  // check for nickname whether registered
  // if true navigate to Navigation.dart
  // else navigate to registration.dart
  Future checkNickname() async {
    var data;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uahageUserId") ?? "";
    String userId = "$id";
    // Map<String, dynamic> ss =;
    try {
      var response = await http.post(
        "http://121.147.203.126:8000/api/auth/check",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"userId": userId}),
      );
      // print("length " + jsonDecode(response.body).toString());
      data = jsonDecode(response.body)["data"];
      return data == false ? false : true;
    } catch (err) {
      print(err);
      return Future.error(err);
    }
  }

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);

      await _initTexts();
      // await _create();
      // await _saveUserId();
      isAlreadyRegistered = await checkNickname();
      if (isAlreadyRegistered) {
        await _saveUserId();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => navigationPage(
                  userId: _accountEmail, loginOption: loginOption),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => registrationPage(
                userId: _accountEmail,
                loginOption: loginOption,
              ),
            ));
      }
      //push는 쌓임 , pushreplacement는 교체!
    } catch (e) {
      print(e.toString());
    }
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  Future _loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  _initTexts() async {
    final User user = await UserApi.instance.me();

    print(
        "=========================[kakao account]=================================");
    print(user.kakaoAccount.toString());
    print(
        "=========================[kakao account]=================================");

    setState(() {
      _accountEmail = user.kakaoAccount.email ?? "";
    });
  }

  // _accounteamail 내부 db 저장
  _saveUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uahageUserEmail', _accountEmail);
    await prefs.setString("uahageLoginOption", loginOption);
    // setState(() {
    //   //userId = (prefs.getString('userId') ?? "");

    // });
  }

  // ************************************Naver Login ******************
  var accesToken;
  var tokenType;

  Future naverLogin() async {
    try {
      await FlutterNaverLogin.logIn();
      NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
      setState(() {
        accesToken = res.accessToken;
        tokenType = res.tokenType;
      });
      NaverAccountResult resAccount = await FlutterNaverLogin.currentAccount();
      setState(() {
        _accountEmail = resAccount.email;
      });
      print(_accountEmail);
      // await _saveUserId();
      isAlreadyRegistered = await checkNickname();
      // create database
      if (isAlreadyRegistered) {
        await _saveUserId();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => navigationPage(
                    userId: _accountEmail,
                    loginOption: loginOption,
                  )),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => registrationPage(
                    userId: _accountEmail,
                    loginOption: loginOption,
                  )),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  String loginOption = "";

  @override
  void initState() {
    _initKakaoTalkInstalled();
    // setState(() {
    loginOption = widget.loginOption;
    // });
    super.initState();
  }

  bool isAllSelected = false;
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;

  appbar bar = new appbar();
  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = "581f27a7aed8a99e5b0a78b33c855dab";

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xffd9d4d5), // navigation bar color
      statusBarColor: Color(0xffd9d4d5), // status bar color
    ));

    ScreenUtil.init(context, width: 1501, height: 2667);

    if (check2 && check3 && check4) {
      setState(() {
        check1 = true;
      });
    } else {
      setState(() {
        check1 = false;
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: bar.screen_appbar('약관동의', context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(),

            Container(
              margin: EdgeInsets.only(top: 441.h),
              child: // 서비스 약관에 동의해주세요.
                  Text("서비스 약관에 동의해주세요.",
                      style: TextStyle(
                          color: const Color(0xffff7292),
                          fontWeight: FontWeight.w700,
                          fontFamily: "NotoSansCJKkr_Bold",
                          fontStyle: FontStyle.normal,
                          fontSize: 78.sp),
                      textAlign: TextAlign.left),
            ),

            // Agreement
            Container(
              margin: EdgeInsets.only(top: 156.h),
              width: 1296.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(width: 0.1),
              ),
              child: // 모두 동의합니다.
                  Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 91.h,
                        margin: EdgeInsets.only(
                            left: 37.w, top: 65.h, bottom: 65.h),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              check1 = check2 = check3 = check4 = !check1;
                            });
                          },
                          child: check1
                              ? Image.asset(
                                  "./assets/agreementPage/checked.png")
                              : Image.asset(
                                  "./assets/agreementPage/unchecked.png"),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 30.w,
                        ),
                        child: Text("모두 동의합니다.",
                            style: TextStyle(
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w700,
                                fontFamily: "NotoSansCJKkr_Bold",
                                fontStyle: FontStyle.normal,
                                fontSize: 62.5.sp),
                            textAlign: TextAlign.left),
                      ),
                    ],
                  ),
                  Divider(thickness: 0.1, height: 0, color: Color(0xff000000)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 91.h,
                        margin: EdgeInsets.only(
                            left: 37.w, top: 65.h, bottom: 65.h),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                check2 = !check2;
                              });
                            },
                            child: check2
                                ? Image.asset(
                                    "./assets/agreementPage/checked.png")
                                : Image.asset(
                                    "./assets/agreementPage/unchecked.png")),
                      ),
                      Container(
                        width: 1100.w,
                        margin: EdgeInsets.only(left: 34.w, right: 0),
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => announce(
                                        choice: "check2",
                                      )),
                            );
                            if (result == "check2")
                              setState(() {
                                check2 = true;
                              });
                          },
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("[필수] 이용약관 동의",
                                  style: TextStyle(
                                      color: const Color(0xff666666),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 62.5.sp),
                                  textAlign: TextAlign.left),
                              Container(
                                height: 74.h,
                                margin: EdgeInsets.only(right: 20.w),
                                child: Image.asset(
                                    "./assets/agreementPage/next.png"),
                              ),
                            ],
                          ),
                        ), // [필수] 이용약관 동의
                      ),
                    ],
                  ),
                  Divider(thickness: 0.1, height: 0, color: Color(0xff000000)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 91.h,
                        margin: EdgeInsets.only(
                            left: 37.w, top: 65.h, bottom: 65.h),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                check3 = !check3;
                              });
                            },
                            child: check3
                                ? Image.asset(
                                    "./assets/agreementPage/checked.png")
                                : Image.asset(
                                    "./assets/agreementPage/unchecked.png")),
                      ),
                      Container(
                        width: 1100.w,
                        margin: EdgeInsets.only(left: 34.w, right: 0),
                        child: // [필수] 이용약관 동의
                            InkWell(
                          onTap: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => announce(
                                        choice: "check3",
                                      )),
                            );
                            if (result == "check3")
                              setState(() {
                                check3 = true;
                              });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("[필수] 개인정보처리방침 동의",
                                  style: TextStyle(
                                      color: const Color(0xff666666),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 62.5.sp),
                                  textAlign: TextAlign.left),
                              Container(
                                height: 74.h,
                                margin: EdgeInsets.only(right: 20.w),
                                child: Image.asset(
                                    "./assets/agreementPage/next.png"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 0.1, height: 0, color: Color(0xff000000)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 91.h,
                        margin: EdgeInsets.only(
                            left: 37.w, top: 65.h, bottom: 65.h),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                check4 = !check4;
                              });
                            },
                            child: check4
                                ? Image.asset(
                                    "./assets/agreementPage/checked.png")
                                : Image.asset(
                                    "./assets/agreementPage/unchecked.png")),
                      ),
                      Container(
                        width: 1100.w,
                        margin: EdgeInsets.only(
                          left: 34.w,
                        ),
                        child: // [필수] 이용약관 동의
                            InkWell(
                          onTap: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => announce(
                                        choice: "check4",
                                      )),
                            );
                            if (result == "check4")
                              setState(() {
                                check4 = true;
                              });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 1000.w,
                                height: 100.h,
                                child: Text("[필수] 위치기반서비스 이용약관 동의",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: const Color(0xff666666),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 62.5.sp),
                                    textAlign: TextAlign.left),
                              ),
                              Container(
                                height: 74.h,
                                margin: EdgeInsets.only(right: 20.w),
                                child: Image.asset(
                                    "./assets/agreementPage/next.png"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Ok button
            Container(
              margin: EdgeInsets.only(top: 243.h),
              child: SizedBox(
                height: 194.h,
                width: 1193.w,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  color: check1 ? const Color(0xffff7292) : Color(0xffcacaca),
                  onPressed: () {
                    if (!check1) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          title: // 이용약관에 동의하셔야 합니다.
                              Text("이용약관에 동의하셔야 합니다.",
                                  style: TextStyle(
                                      color: const Color(0xff4d4d4d),
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
                                    Text("확인",
                                        style: TextStyle(
                                            color: const Color(0xffff7292),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "NotoSansCJKkr_Medium",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 62.5.sp),
                                        textAlign: TextAlign.center))
                          ],
                        ),
                      );
                    } else {
                      switch (loginOption) {
                        case "kakao":
                          if (_isKakaoTalkInstalled)
                            buildShowDialogOnOk(_loginWithTalk(), context,
                                200.h, 200.w, 80.w, 100.w, 62.5.sp);
                          else {
                            buildShowDialogOnOk(_loginWithKakao(), context,
                                200.h, 200.w, 80.w, 100.w, 62.5.sp);
                          }
                          break;
                        case "naver":
                          buildShowDialogOnOk(naverLogin(), context, 200.h,
                              200.w, 80.w, 100.w, 62.5.sp);
                          break;
                        case "login":
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) =>
                                    navigationPage(loginOption: loginOption)),
                          );
                          break;
                        default:
                          break;
                      }
                    }
                  },
                  child: // 중복확인
                      Text("OK",
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w500,
                              fontFamily: "NotoSansCJKkr_Medium",
                              fontStyle: FontStyle.normal,
                              fontSize: 62.5.sp),
                          textAlign: TextAlign.left),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
