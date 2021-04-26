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

  const SubListPage(
      {Key key,
      this.index,
      this.data,
      this.loginOption,
      this.userId,
      this.tableType,
   })
      : super(key: key);
  @override
  _SubListPageState createState() => _SubListPageState();
}

class _SubListPageState extends State<SubListPage> {
  WebViewController controller;
  String url;
  var userId = "";
  var loginOption = "";
  var data ;
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
    appbar bar = new appbar();
    var index = widget.index;
    var data = widget.data;
    ScreenUtil.init(context, width: 1500, height: 2667);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, bookmark.toString());
        return;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: bar.sub_appbar(
              (() {
                if (tableType == 'restaurant') {
                  return "매장안내";
                } else if (tableType == "Examination_institution") {
                  return "영유아 검진 및 구강검진 병원 안내";
                } else if (tableType == "Experience_center") {
                  return "체험관 안내";
                } else {
                  return "키즈카페 안내";
                }
              }()),
              context,
              bookmark.toString()),
          body: ListView(
            //  controller: _scrollController,
            physics: enabled ? NeverScrollableScrollPhysics() : ScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 1501.w,
                    child: (() {
                      if (tableType == 'restaurant') {
                        if (index % 3 == 1) {
                          return mainImage(restaurantListImage[0], 1501.w);
                        } else if (index % 3 == 2) {
                          return mainImage(restaurantListImage[1], 1501.w);
                        } else
                          return mainImage(restaurantListImage[2], 1501.w);
                      } else if (tableType == 'Examination_institution') {
                        if (index % 2 == 1)
                          return mainImage(hospitalListImage[0], 1501.w);
                        else
                          return mainImage(hospitalListImage[1], 1501.w);
                      } else if (tableType == 'Experience_center') {
                        if (index % 4 == 1)
                          return mainImage(experienceListImage[0], 1501.w);
                        else if (index % 4 == 2)
                          return mainImage(experienceListImage[1], 1501.w);
                        else if (index % 4 == 3)
                          return mainImage(experienceListImage[2], 1501.w);
                        else
                          return mainImage(experienceListImage[3], 1501.w);
                      } else {
                        if (index % 2 == 1)
                          return mainImage(kidsCafeListImage[0], 1501.w);
                        else
                          return mainImage(kidsCafeListImage[1], 1501.w);
                      }
                    }()),
                  ),
                  Card(
                    elevation: 0.3,
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 75.w, top: 45.h, bottom: 45.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 1250.w,
                            child: Text("${data.name}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "NotoSansCJKkr_Bold",
                                    fontSize: 77.0.sp),
                                textAlign: TextAlign.left),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.w,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            constraints: BoxConstraints(
                                maxWidth: 170.w, maxHeight: 170.h),
                            icon: Image.asset(
                                bookmark == 0?
                                "./assets/listPage/star_grey.png" :
                                     "./assets/listPage/star_color.png",

                                height: 60.h),
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
                                    if ( bookmark == 0) {
                                      bookMark.bookmarkCreate(userId,place_id);
                                      setState(() {
                                        bookmark = 1;
                                      });

                                    } else {
                                      bookMark.bookmarkDelete(userId,place_id);
                                      setState(() {
                                        bookmark = 0;
                                      });
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0.3,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 75 / (1501 / MediaQuery.of(context).size.width),
                      ),
                      width: MediaQuery.of(context).size.width,
                      // alignment: Alignment.center,
                      //  height: 520 .h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                            top:
                                40 / (1501 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            "주소",
                            style: TextStyle(
                                color: Color(0xff4d4d4d),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 58.0.sp),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top:
                                10 / (1501 / MediaQuery.of(context).size.width),
                          )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 1065.w,
                                child: Text(
                                  data.address == null
                                      ? "정보 없음"
                                      : "${data.address}",
                                  style: TextStyle(
                                      color: Color(0xff808080),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 57.0.sp,
                                      height: 1.2),
                                ),
                              ),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "./assets/sublistPage/copy.png",
                                      width: 250.w,
                                      height: 56.h,
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
                            top:
                                30 / (1501 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            "연락처",
                            style: TextStyle(
                                color: Color(0xff4d4d4d),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 58.0.sp),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top:
                                10 / (1501 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            "${data.phone}",
                            style: TextStyle(
                                color: Color(0xff808080),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 57.0.sp,
                                height: 1.2),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top:
                                75 / (1501 / MediaQuery.of(context).size.width),
                          )),
                        ],
                      ),
                    ),
                  ),
                  (() {
                    if (tableType == 'restaurant') {
                      return Card(
                        elevation: 0.3,
                        child: Container(
                          height: 928.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 75.w,
                                  top: 50.h,
                                ),
                                child: Text(
                                  "편의시설",
                                  style: TextStyle(
                                      color: Color(0xff4d4d4d),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 58.0.sp,
                                      height: 1.2),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 50.h)),
                              Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(left: 67.w)),
                                    data.menu == "○"
                                        ? Image.asset(
                                            imagecolor[0],
                                            width: 218.w,
                                            height: 292.h,
                                          )
                                        : Image.asset(
                                            imagegrey[0],
                                            width: 218.w,
                                            height: 292.h,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 59.w)),
                                    data.bed == "○"
                                        ? Image.asset(
                                            imagecolor[1],
                                            width: 218.w,
                                            height: 292.h,
                                          )
                                        : Image.asset(
                                            imagegrey[1],
                                            width: 218.w,
                                            height: 292.h,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 59.w)),
                                    data.tableware == "○"
                                        ? Image.asset(
                                            imagecolor[2],
                                            width: 218.w,
                                            height: 292.h,
                                          )
                                        : Image.asset(
                                            imagegrey[2],
                                            width: 218.w,
                                            height: 292.h,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 59.w)),
                                    data.meetingroom == "○"
                                        ? Image.asset(
                                            imagecolor[3],
                                            width: 218.w,
                                            height: 292.h,
                                          )
                                        : Image.asset(
                                            imagegrey[3],
                                            width: 218.w,
                                            height: 292.h,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 59.w)),
                                    data.diapers == "○"
                                        ? Image.asset(
                                            imagecolor[4],
                                            width: 231.w,
                                            height: 284.h,
                                          )
                                        : Image.asset(
                                            imagegrey[4],
                                            width: 231.w,
                                            height: 284.h,
                                          ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 59.w)),
                                  ]),
                              Padding(padding: EdgeInsets.only(top: 50.h)),
                              Row(
                                children: [
                                  Padding(padding: EdgeInsets.only(left: 67.w)),
                                  data.playroom == "○"
                                      ? Image.asset(
                                          imagecolor[5],
                                          width: 218.w,
                                          height: 292.h,
                                        )
                                      : Image.asset(
                                          imagegrey[5],
                                          width: 218.w,
                                          height: 292.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 59.w)),
                                  data.carriage == "○"
                                      ? Image.asset(
                                          imagecolor[6],
                                          width: 218.w,
                                          height: 292.h,
                                        )
                                      : Image.asset(
                                          imagegrey[6],
                                          width: 218.w,
                                          height: 292.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 59.w)),
                                  data.nursingroom == "○"
                                      ? Image.asset(
                                          imagecolor[7],
                                          width: 218.w,
                                          height: 292.h,
                                        )
                                      : Image.asset(
                                          imagegrey[7],
                                          width: 218.w,
                                          height: 292.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 59.w)),
                                  data.chair == "○"
                                      ? Image.asset(
                                          imagecolor[8],
                                          width: 218.w,
                                          height: 292.h,
                                        )
                                      : Image.asset(
                                          imagegrey[8],
                                          width: 218.w,
                                          height: 292.h,
                                        )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (tableType == "Examination_institution") {
                      return Card(
                        elevation: 0.3,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            left: 75.w,
                            top: 20.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "검진항목",
                                style: TextStyle(
                                    color: Color(0xff4d4d4d),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 58.0.sp),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                top: 10 /
                                    (1501 / MediaQuery.of(context).size.width),
                              )),
                              Text(
                                "${data.Examination_item}",
                                style: TextStyle(
                                    color: Color(0xff808080),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 57.0.sp,
                                    height: 1.2),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                top: 50 /
                                    (1501 / MediaQuery.of(context).size.width),
                              )),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        elevation: 0.3,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            left: 75.w,
                            top: 20.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "관람 / 체험료",
                                style: TextStyle(
                                    color: Color(0xff4d4d4d),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 58.0.sp),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                top: 10 /
                                    (1501 / MediaQuery.of(context).size.width),
                              )),
                              Text(
                                data.fare == null ? "정보 없음" : "${data.fare}",
                                style: TextStyle(
                                    color: Color(0xff808080),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 57.0.sp,
                                    height: 1.2),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                top: 50 /
                                    (1501 / MediaQuery.of(context).size.width),
                              )),
                            ],
                          ),
                        ),
                      );
                    }
                  }()),
                  Card(
                      elevation: 0.3,
                      child: Container(
                        //  height: 1300 .h,
                        width: 1500.w,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: 75.w,
                                  top: 40.h,
                                ),
                                child: Text(
                                  "위치",
                                  style: TextStyle(
                                      color: Color(0xff4d4d4d),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 58.0.sp),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 50.h)),
                            ]),
                      ))
                ],
              ),
        /*      Container(
                height: 1100.h,
                child: WebView(
                  // gestureNavigationEnabled: true,
                  onWebViewCreated: (WebViewController webViewController) {
                    controller = webViewController;
                    controller.loadUrl(
                        'http://211.223.46.144:3000/map/storename?storename=${data.storename}&address=$fsysaddress');
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
