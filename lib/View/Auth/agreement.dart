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
import 'package:uahage/Widget//appBar.dart';import 'package:flutter_config/flutter_config.dart';
import 'package:uahage/API/auth.dart';

class agreementPage extends StatefulWidget {
  agreementPage({Key key, this.loginOption}) : super(key: key);

  final String loginOption;
  @override
  _agreementPageState createState() => _agreementPageState();
}

class _agreementPageState extends State<agreementPage> {
  String url;
  String Email = "";
  String userId = "";

  //kakao login----------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------
  bool _isKakaoTalkInstalled = false;
  bool isAlreadyRegistered = false;

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao Install : ' + installed.toString());

    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }



  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      await kakaoGetEmail();
      isAlreadyRegistered = await auth.checkEmail(Email,loginOption);

      if (!isAlreadyRegistered) {
       userId = await auth.signIn(Email,loginOption);
         Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => navigationPage(
                  userId: userId, loginOption: loginOption),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => registrationPage(
                Email: Email,
                loginOption: loginOption,
              ),
            ));
      }

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

  kakaoGetEmail() async {
    final User user = await UserApi.instance.me();

    print(user.kakaoAccount.toString());

    setState(() {
      Email = user.kakaoAccount.email ?? "";
    });
  }

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
        Email = resAccount.email;
      });

      isAlreadyRegistered = await auth.checkEmail(Email, loginOption);
      // create database
      if (isAlreadyRegistered) {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => navigationPage(
                    userId: userId,
                    loginOption: loginOption,
                  )),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => registrationPage(
                    Email: Email,
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

    loginOption = widget.loginOption;
    url = FlutterConfig.get('API_URL');
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
