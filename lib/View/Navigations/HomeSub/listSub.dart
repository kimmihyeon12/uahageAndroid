import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uahage/Model/bottom_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uahage/Widget/appBar.dart';
import 'package:uahage/Widget/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_config/flutter_config.dart';
import 'package:uahage/API/bookMark.dart';

class SubListPage extends StatefulWidget {
  final index;
  final data;
  final loginOption;
  final userId;
  final tableType;

  const SubListPage({
    Key key,
    this.index,
    this.data,
    this.loginOption,
    this.userId,
    this.tableType,
  }) : super(key: key);
  @override
  _SubListPageState createState() => _SubListPageState();
}

class _SubListPageState extends State<SubListPage> {
  WebViewController controller;
  String url;
  var userId = "";
  var loginOption = "";
  var data;
  var bookmark;
  var tableType = "";
  int place_id;
  toast show_toast = new toast();

  ScrollController _scrollController = ScrollController();
  var enabled = false;
  @override
  void initState() {
    data = widget.data;
    url = FlutterConfig.get('API_URL');
    userId = widget.userId;
    loginOption = widget.loginOption;
    tableType = widget.tableType;
    bookmark = data.bookmark;

    super.initState();
  }

  var imagecolor = [
    "./assets/searchPage/image1.png",
    "./assets/searchPage/image2.png",
    "./assets/searchPage/image3.png",
    "./assets/searchPage/image4.png",
    "./assets/searchPage/image5.png",
    "./assets/searchPage/image6.png",
    "./assets/searchPage/image7.png",
    "./assets/searchPage/image8.png",
    "./assets/searchPage/image9.png",
  ];
  var imagegrey = [
    "./assets/searchPage/image1_grey.png",
    "./assets/searchPage/image2_grey.png",
    "./assets/searchPage/image3_grey.png",
    "./assets/searchPage/image4_grey.png",
    "./assets/searchPage/image5_grey.png",
    "./assets/searchPage/image6_grey.png",
    "./assets/searchPage/image7_grey.png",
    "./assets/searchPage/image8_grey.png",
    "./assets/searchPage/image9_grey.png",
  ];

  var mainimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image3.png"
  ];

  var restaurantListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image3.png"
  ];
  var hospitalListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_exam_sublist_/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_exam_sublist_/image1.png",
  ];
  var kidsCafeListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_kidscafe_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_kidscafe_sublist/image2.png",
  ];
  var experienceListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image3.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image4.png",
  ];

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  mainImage(image, screenWidth) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.fitWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    var index = widget.index;
    var data = widget.data;
    ScreenUtil.init(context, width: 720, height: 1280);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, bookmark.toString());
        return;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.h),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Color(0xffff7292)),
                onPressed: () {
                  Navigator.pop(context, bookmark);
                  print(bookmark.toString());
                },
              ),
              title: Text(
                '${data.name}',
                style: TextStyle(
                    color: Color(0xffff7292),
                    fontFamily: "NotoSansCJKkr_Medium",
                    fontSize: 30.0.sp),
              ),
            ),
          ),
          body: ListView(
            //  controller: _scrollController,
            physics: enabled ? NeverScrollableScrollPhysics() : ScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 720.w,
                    child: (() {
                      if (tableType == 'restaurant') {
                        if (index % 3 == 1) {
                          return mainImage(restaurantListImage[0], 720.w);
                        } else if (index % 3 == 2) {
                          return mainImage(restaurantListImage[1], 720.w);
                        } else
                          return mainImage(restaurantListImage[2], 720.w);
                      } else if (tableType == 'Examination_institution') {
                        if (index % 2 == 1)
                          return mainImage(hospitalListImage[0], 720.w);
                        else
                          return mainImage(hospitalListImage[1], 720.w);
                      } else if (tableType == 'Experience_center') {
                        if (index % 4 == 1)
                          return mainImage(experienceListImage[0], 720.w);
                        else if (index % 4 == 2)
                          return mainImage(experienceListImage[1], 720.w);
                        else if (index % 4 == 3)
                          return mainImage(experienceListImage[2], 720.w);
                        else
                          return mainImage(experienceListImage[3], 720.w);
                      } else {
                        if (index % 2 == 1)
                          return mainImage(kidsCafeListImage[0], 720.w);
                        else
                          return mainImage(kidsCafeListImage[1], 720.w);
                      }
                    }()),
                  ),
                  Container(
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 35.w, top: 26.h, bottom: 10.h),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 590.w,
                                child: Text("${data.name}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "NotoSansCJKkr_Bold",
                                        fontSize: 39.0.sp),
                                    textAlign: TextAlign.left),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 29.w,
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(
                                    maxWidth: 33.w, maxHeight: 33.h),
                                icon: Image.asset(
                                    bookmark == 0
                                        ? "./assets/listPage/love_grey.png"
                                        : "./assets/listPage/love_color.png",
                                    height: 33.h),
                                onPressed: loginOption == "login"
                                    ? () {
                                        Fluttertoast.showToast(
                                          msg: "  로그인 해주세요!  ",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black45,
                                          textColor: Colors.white,
                                          fontSize: 56.sp,
                                        );
                                      }
                                    : () async {
                                        setState(() {
                                          place_id = data.id;
                                        });
                                        if (bookmark == 0) {
                                          bookMark.bookmarkCreate(
                                              userId, place_id);
                                          setState(() {
                                            bookmark = 1;
                                          });
                                        } else {
                                          bookMark.bookmarkDelete(
                                              userId, place_id);
                                          setState(() {
                                            bookmark = 0;
                                          });
                                        }
                                      },
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 3.3.h,
                          )),
                          Row(
                            children: [
                              Image.asset(
                                "./assets/listPage/star_color.png",
                                width: 38.w,
                              ),
                              Padding(padding: EdgeInsets.only(left: 12.w)),
                              Image.asset(
                                "./assets/listPage/star_color.png",
                                width: 38.w,
                              ),
                              Padding(padding: EdgeInsets.only(left: 12.w)),
                              Image.asset(
                                "./assets/listPage/star_color.png",
                                width: 38.w,
                              ),
                              Padding(padding: EdgeInsets.only(left: 12.w)),
                              Image.asset(
                                "./assets/listPage/star_color.png",
                                width: 38.w,
                              ),
                              Padding(padding: EdgeInsets.only(left: 12.w)),
                              Image.asset(
                                "./assets/listPage/star_color.png",
                                width: 38.w,
                              ),
                              Padding(padding: EdgeInsets.only(left: 12.w)),
                              Text('3.5',
                                  style: TextStyle(
                                    color: Color(0xff4d4d4d),
                                    fontSize: 30.sp,
                                    fontFamily: "NotoSansCJKkr_Medium",
                                  )),
                              Padding(padding: EdgeInsets.only(left: 12.w)),
                              Text('3명이 평가에 참여했습니다',
                                  style: TextStyle(
                                    color: Color(0xffc6c6c6),
                                    fontSize: 25.sp,
                                    fontFamily: "NotoSansCJKkr_Medium",
                                  ))
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 26 / (720 / MediaQuery.of(context).size.width),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 2.h,
                    color: Color(0xfff7f7f7),
                  ),
                  Container(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 35 / (720 / MediaQuery.of(context).size.width),
                      ),
                      width: MediaQuery.of(context).size.width,
                      // alignment: Alignment.center,
                      //  height: 520 .h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                            top: 18.3 /
                                (720 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            "주소",
                            style: TextStyle(
                                color: Color(0xff4d4d4d),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 30.0.sp),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 10 / (720 / MediaQuery.of(context).size.width),
                          )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 530.w,
                                child: Text(
                                  data.address == null
                                      ? "정보 없음"
                                      : "${data.address}",
                                  style: TextStyle(
                                      color: Color(0xff808080),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 30.0.sp,
                                      height: 1.2),
                                ),
                              ),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "./assets/sublistPage/copy.png",
                                      width: 120.w,
                                      height: 37.h,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  FlutterClipboard.copy(data.address);
                                  show_toast.showToast(context, "주소가 복사되었습니다");
                                },
                              )
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 31 / (720 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            "연락처",
                            style: TextStyle(
                                color: Color(0xff4d4d4d),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 30.0.sp),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 10 / (720 / MediaQuery.of(context).size.width),
                          )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 530.w,
                                child: Text(
                                  data.address == null
                                      ? "정보 없음"
                                      : "${data.phone}",
                                  style: TextStyle(
                                      color: Color(0xff808080),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 30.0.sp,
                                      height: 1.2),
                                ),
                              ),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "./assets/sublistPage/call.png",
                                      width: 120.w,
                                      height: 37.h,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  FlutterClipboard.copy(data.address);
                                  show_toast.showToast(context, "주소가 복사되었습니다");
                                },
                              )
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 30 / (720 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            "영업시간",
                            style: TextStyle(
                                color: Color(0xff4d4d4d),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 30.0.sp),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 10 / (720 / MediaQuery.of(context).size.width),
                          )),
                          Container(
                            width: 550.w,
                            child: Text(
                              "오전 11:30 ~ 21:00(샐러드바 마감 20:30) 브레이크타임 15:00~17:00",
                              style: TextStyle(
                                  color: Color(0xff808080),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 30.0.sp,
                                  height: 1.2),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 30 / (720 / MediaQuery.of(context).size.width),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 26.h,
                    color: Color(0xfff7f7f7),
                  ),
                  Container(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 35 / (720 / MediaQuery.of(context).size.width),
                      ),
                      width: MediaQuery.of(context).size.width,
                      // alignment: Alignment.center,
                      //  height: 520 .h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                            top: 30.8 /
                                (720 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            "매장정보",
                            style: TextStyle(
                                color: Color(0xff4d4d4d),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 30.0.sp),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 10 / (720 / MediaQuery.of(context).size.width),
                          )),
                          Row(
                            children: [
                              Container(
                                width: 530.w,
                                child: Text(
                                  "OO 평일런치",
                                  style: TextStyle(
                                      color: Color(0xff808080),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 30.0.sp,
                                      height: 1.2),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "15,900원",
                                  style: TextStyle(
                                      color: Color(0xffc6c6c6),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 30.0.sp,
                                      height: 1.2),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 10 / (720 / MediaQuery.of(context).size.width),
                          )),
                          Row(
                            children: [
                              Container(
                                width: 530.w,
                                child: Text(
                                  "OO 평일디너",
                                  style: TextStyle(
                                      color: Color(0xff808080),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 30.0.sp,
                                      height: 1.2),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "22,900원",
                                  style: TextStyle(
                                      color: Color(0xffc6c6c6),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 30.0.sp,
                                      height: 1.2),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 10 / (720 / MediaQuery.of(context).size.width),
                          )),
                          Row(
                            children: [
                              Container(
                                width: 530.w,
                                child: Text(
                                  "OO 주말/공휴일",
                                  style: TextStyle(
                                      color: Color(0xff808080),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 30.0.sp,
                                      height: 1.2),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "25,900원",
                                  style: TextStyle(
                                      color: Color(0xffc6c6c6),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 30.0.sp,
                                      height: 1.2),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 30 / (720 / MediaQuery.of(context).size.width),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 26.h,
                    color: Color(0xfff7f7f7),
                  ),
                  (() {
                    if (tableType == 'restaurant') {
                      return Container(
                        child: Container(
                          height: 446.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 35.w,
                                  top: 33.h,
                                ),
                                child: Text(
                                  "편의시설",
                                  style: TextStyle(
                                      color: Color(0xff4d4d4d),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 30.0.sp,
                                      height: 1.2),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 28.h)),
                              Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 33.w)),
                                    data.menu == "1"
                                        ? Image.asset(
                                            imagecolor[0],
                                            width: 102.w,
                                            height: 143.h,
                                          )
                                        : Image.asset(
                                            imagegrey[0],
                                            width: 102.w,
                                            height: 143.h,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 33.w)),
                                    data.bed == "1"
                                        ? Image.asset(
                                            imagecolor[1],
                                            width: 102.w,
                                            height: 143.h,
                                          )
                                        : Image.asset(
                                            imagegrey[1],
                                            width: 102.w,
                                            height: 143.h,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 33.w)),
                                    data.tableware == "1"
                                        ? Image.asset(
                                            imagecolor[2],
                                            width: 102.w,
                                            height: 143.h,
                                          )
                                        : Image.asset(
                                            imagegrey[2],
                                            width: 102.w,
                                            height: 143.h,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 33.w)),
                                    data.meetingroom == "1"
                                        ? Image.asset(
                                            imagecolor[3],
                                            width: 102.w,
                                            height: 143.h,
                                          )
                                        : Image.asset(
                                            imagegrey[3],
                                            width: 102.w,
                                            height: 143.h,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 33.w)),
                                    data.diapers == "1"
                                        ? Image.asset(
                                            imagecolor[4],
                                            width: 102.w,
                                            height: 143.h,
                                          )
                                        : Image.asset(
                                            imagegrey[4],
                                            width: 102.w,
                                            height: 143.h,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 33.w)),
                                  ]),
                              Padding(padding: EdgeInsets.only(top: 24.h)),
                              Row(
                                children: [
                                  Padding(padding: EdgeInsets.only(left: 33.w)),
                                  data.playroom == "1"
                                      ? Image.asset(
                                          imagecolor[5],
                                          width: 102.w,
                                          height: 143.h,
                                        )
                                      : Image.asset(
                                          imagegrey[5],
                                          width: 102.w,
                                          height: 143.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 33.w)),
                                  data.carriage == "1"
                                      ? Image.asset(
                                          imagecolor[6],
                                          width: 102.w,
                                          height: 143.h,
                                        )
                                      : Image.asset(
                                          imagegrey[6],
                                          width: 102.w,
                                          height: 143.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 33.w)),
                                  data.nursingroom == "1"
                                      ? Image.asset(
                                          imagecolor[7],
                                          width: 102.w,
                                          height: 143.h,
                                        )
                                      : Image.asset(
                                          imagegrey[7],
                                          width: 102.w,
                                          height: 143.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 33.w)),
                                  data.chair == "1"
                                      ? Image.asset(
                                          imagecolor[8],
                                          width: 102.w,
                                          height: 143.h,
                                        )
                                      : Image.asset(
                                          imagegrey[8],
                                          width: 102.w,
                                          height: 143.h,
                                        )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (tableType == "Examination_institution") {
                      return Container(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            left: 35.w,
                            top: 30.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "검진항목",
                                style: TextStyle(
                                    color: Color(0xff4d4d4d),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 30.0.sp),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                top: 10 /
                                    (720 / MediaQuery.of(context).size.width),
                              )),
                              Text(
                                "${data.Examination_item}",
                                style: TextStyle(
                                    color: Color(0xff808080),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 30.0.sp,
                                    height: 1.2),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                top: 30 /
                                    (720 / MediaQuery.of(context).size.width),
                              )),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            left: 35.w,
                            top: 30.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "관람 / 체험료",
                                style: TextStyle(
                                    color: Color(0xff4d4d4d),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 30.0.sp),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                top: 10 /
                                    (720 / MediaQuery.of(context).size.width),
                              )),
                              Text(
                                data.fare == null ? "정보 없음" : "${data.fare}",
                                style: TextStyle(
                                    color: Color(0xff808080),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 30.0.sp,
                                    height: 1.2),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                top: 30 /
                                    (720 / MediaQuery.of(context).size.width),
                              )),
                            ],
                          ),
                        ),
                      );
                    }
                  }()),
                  Container(
                    height: 26.h,
                    color: Color(0xfff7f7f7),
                  ),
                  Container(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 35 / (720 / MediaQuery.of(context).size.width),
                      ),
                      width: MediaQuery.of(context).size.width,
                      // alignment: Alignment.center,
                      //  height: 520 .h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                            top: 30 / (720 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            "방문자 평가분석",
                            style: TextStyle(
                                color: Color(0xff4d4d4d),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 30.0.sp),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 10 / (720 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            "3명이 평가에 참여했습니다",
                            style: TextStyle(
                                color: Color(0xffc6c6c6),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 30.0.sp),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top: 30 / (720 / MediaQuery.of(context).size.width),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 26.h,
                    color: Color(0xfff7f7f7),
                  ),
                  Container(
                      child: Container(
                    //  height: 1300 .h,
                    width: 750.w,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 35.w,
                              top: 30.h,
                            ),
                            child: Text(
                              "위치",
                              style: TextStyle(
                                  color: Color(0xff4d4d4d),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 30.0.sp),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 50.h)),
                          Container(
                            height: 567.h,
                            child: WebView(
                              // gestureNavigationEnabled: true,
                              onWebViewCreated:
                                  (WebViewController webViewController) {
                                controller = webViewController;
                                controller.loadUrl(url +
                                    '/maps/show-place-name?placeName=${data.name}&placeAddress=${data.address}');
                                print(data.name);
                              },
                              javascriptMode: JavascriptMode.unrestricted,
                            ),
                          ),
                        ]),
                  )),
                  Container(
                    child: Container(
                      height: 87.h,
                      child: Center(
                        child: Image.asset(
                          "./assets/sublistPage/modify.png",
                          height: 45.h,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 26.h,
                    color: Color(0xfff7f7f7),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        left: 87.w,
                        top: 36.h,
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: 210.h,
                                  child: Column(
                                    children: [
                                      Text('${data.name}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "NotoSansCJKkr_Bold",
                                              fontSize: 26.0.sp)),
                                      Text(' 다녀오셨나요?',
                                          style: TextStyle(
                                              color: Color(0xff939393),
                                              fontFamily:
                                                  "NotoSansCJKkr_Medium",
                                              fontSize: 26.0.sp)),
                                    ],
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 60.w,
                                ),
                              ),
                              Image.asset(
                                "./assets/sublistPage/reviewbutton.png",
                                height: 54.h,
                              ),
                            ],
                          ),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 36.w, top: 37.h),
                    child: Stack(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 6.0,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            height: 193.h,
                            width: 648.w),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 22.h),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 22.h),
                                ),
                                Text("고객만족도",
                                    style: TextStyle(
                                        color: Color(0xff939393),
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontSize: 24.0.sp)),
                                Text("5.0",
                                    style: TextStyle(
                                        color: Color(0xff3a3939),
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontSize: 60.0.sp)),
                                Row(
                                  children: [
                                    Image.asset(
                                      "./assets/listPage/star_color.png",
                                      width: 38.w,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 12.w)),
                                    Image.asset(
                                      "./assets/listPage/star_color.png",
                                      width: 38.w,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 12.w)),
                                    Image.asset(
                                      "./assets/listPage/star_color.png",
                                      width: 38.w,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 12.w)),
                                    Image.asset(
                                      "./assets/listPage/star_color.png",
                                      width: 38.w,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 12.w)),
                                    Image.asset(
                                      "./assets/listPage/star_color.png",
                                      width: 38.w,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 12.w)),
                                  ],
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 36.w)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 36.w)),
                      Image.asset(
                        "./assets/sublistPage/55.png",
                        width: 149.w,
                      ),
                      Padding(padding: EdgeInsets.only(left: 18.w)),
                      Image.asset(
                        "./assets/sublistPage/44.png",
                        width: 149.w,
                      ),
                      Padding(padding: EdgeInsets.only(left: 18.w)),
                      Image.asset(
                        "./assets/sublistPage/33.png",
                        width: 149.w,
                      ),
                      Padding(padding: EdgeInsets.only(left: 18.w)),
                      Image.asset(
                        "./assets/sublistPage/55.png",
                        width: 149.w,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 36.w)),
                  Container(
                    height: 26.h,
                    color: Color(0xfff7f7f7),
                  ),
                  Container(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top: 80.w, left: 35.w)),
                          Text(
                            "리뷰",
                            style: TextStyle(
                                color: Color(0xff4d4d4d),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 30.0.sp),
                          ),
                          Container(
                            width: 180.w,
                            child: Text(
                              "54",
                              style: TextStyle(
                                  color: Color(0xffe9718d),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 31.0.sp),
                            ),
                          ),
                          Text(
                            "최신순",
                            style: TextStyle(
                                color: Color(0xff4d4d4d),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 30.0.sp),
                          ),
                          Text(
                            " | ",
                            style: TextStyle(
                                color: Color(0xffdddddd),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 30.0.sp),
                          ),
                          Text(
                            "평점높은순",
                            style: TextStyle(
                                color: Color(0xff939393),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 30.0.sp),
                          ),
                          Text(
                            " | ",
                            style: TextStyle(
                                color: Color(0xffdddddd),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 30.0.sp),
                          ),
                          Text(
                            "평점낮은순",
                            style: TextStyle(
                                color: Color(0xff939393),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 30.0.sp),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 28.w)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(left: 38.w)),
                          Image.asset(
                            "./assets/sublistPage/image1.png",
                            width: 80.w,
                          ),
                          Padding(padding: EdgeInsets.only(left: 15.w)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "하나뿐인쥬이",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontSize: 26.0.sp),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 20.w)),
                                  Text(
                                    "2021.06.20",
                                    style: TextStyle(
                                        color: Color(0xff939393),
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontSize: 26.0.sp),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 180.w)),
                                  Text(
                                    "신고",
                                    style: TextStyle(
                                        color: Color(0xff939393),
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontSize: 26.0.sp),
                                  ),
                                ],
                              ),
                              Padding(padding: EdgeInsets.only(top: 5.w)),
                              Row(
                                children: [
                                  Stack(

                                    children: [
                                      Image.asset(
                                        "./assets/sublistPage/boarder.png",
                                        width: 109.w,
                                      ),
                                      Row(
                                        children: [

                                          Padding(
                                              padding: EdgeInsets.only(left: 5.w)),
                                          Text(
                                            "맛",
                                            style: TextStyle(
                                                color: Color(0xff939393),
                                                fontFamily: "NotoSansCJKkr_Medium",
                                                fontSize: 24.0.sp),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(left: 5.w)),
                                          Image.asset(
                                            "./assets/listPage/star_color.png",
                                            width: 23.w,
                                          ),
                                          Padding(
                                              padding:
                                              EdgeInsets.only(left: 5.w)),
                                          Text(
                                            "4.5",
                                            style: TextStyle(
                                                color: Color(0xff939393),
                                                fontFamily: "NotoSansCJKkr_Medium",
                                                fontSize: 26.0.sp),
                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 9.w)),
                                  Stack(

                                    children: [
                                      Image.asset(
                                        "./assets/sublistPage/boarder.png",
                                        width: 109.w,
                                      ),
                                      Row(
                                        children: [

                                          Padding(
                                              padding: EdgeInsets.only(left: 5.w)),
                                          Text(
                                            "가격",
                                            style: TextStyle(
                                                color: Color(0xff939393),
                                                fontFamily: "NotoSansCJKkr_Medium",
                                                fontSize: 24.0.sp),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(left: 5.w)),
                                          Image.asset(
                                            "./assets/listPage/star_color.png",
                                            width: 23.w,
                                          ),
                                          Padding(
                                              padding:
                                              EdgeInsets.only(left: 5.w)),
                                          Text(
                                            "2",
                                            style: TextStyle(
                                                color: Color(0xff939393),
                                                fontFamily: "NotoSansCJKkr_Medium",
                                                fontSize: 26.0.sp),
                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 9.w)),
                                  Stack(

                                    children: [
                                      Image.asset(
                                        "./assets/sublistPage/boarder.png",
                                        width: 140.w,
                                        height:39.h,
                                      ),
                                      Row(
                                        children: [

                                          Padding(
                                              padding: EdgeInsets.only(left: 5.w)),
                                          Text(
                                            "서비스",
                                            style: TextStyle(
                                                color: Color(0xff939393),
                                                fontFamily: "NotoSansCJKkr_Medium",
                                                fontSize: 24.0.sp),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(left: 5.w)),
                                          Image.asset(
                                            "./assets/listPage/star_color.png",
                                            width: 23.w,
                                          ),
                                          Padding(
                                              padding:
                                              EdgeInsets.only(left: 5.w)),
                                          Text(
                                            "5",
                                            style: TextStyle(
                                                color: Color(0xff939393),
                                                fontFamily: "NotoSansCJKkr_Medium",
                                                fontSize: 26.0.sp),
                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  )),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xfff7f7f7),
                        border: Border.all(
                          color: Color(0xfff7f7f7),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    margin: EdgeInsets.all(40.5.w),
                    padding: EdgeInsets.all(20.w),
                    child: Text(
                      "직원이 많아서 접시 치워주는 것도 빠르고 음식이 비어있는건 바로 채워주셔서 먹기 편했어요!",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "NotoSansCJKkr_Medium",
                          fontSize: 26.0.sp),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
