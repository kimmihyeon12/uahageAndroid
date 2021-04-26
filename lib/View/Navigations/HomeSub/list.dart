import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:uahage/Model/distance.dart';
import 'dart:convert';
import 'dart:async';
import 'listMap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/Widget/toast.dart';

import 'package:uahage/Model//Restaurant_helper.dart';
import 'package:uahage/Widget/icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/Model/Kids_cafe_helper.dart';
import 'package:uahage/Model/experience_center_helper.dart';
import 'package:uahage/Model/examination_institution_helper.dart';
import 'package:uahage/View/Navigations/HomeSub/listSub.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:uahage/API/bookMark.dart';
import 'package:uahage/API/places.dart';

class ListPage extends StatefulWidget {

  String userId;
  String latitude = "";
  String longitude = "";
  String Area = "";
  String Locality = "";
  String tableType = "";

  // String oldNickname;
  ListPage(
      {Key key,
      this.userId,

      this.latitude,
      this.longitude,
      this.Area,
      this.Locality,
      this.tableType});
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var indexcount = 0;
  String latitude = "";
  String longitude = "";
  String userId = "";

  String Area = "";
  String Locality = "";
  String tableType = "";
  String store_name1,
      address1,
      phone1,
      menu1,
      bed1,
      tableware1,
      meetingroom1,
      diapers1,
      playroom1,
      carriage1,
      nursingroom1,
      chair1;
  var list = true;
  toast show_toast = new toast();

  List<bool> star_color_list = [];
  var star_color = false;
  bool toggle = false;

  var restaurantListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image3.png",
  ];
  var hospitalListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/hospital_image/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/hospital_image/image2.png",
  ];
  var kidsCafeListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/kids_cafe/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/kids_cafe/image2.png",
  ];
  var experienceListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image3.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image4.png",
  ];
  Future<List<dynamic>> myFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  List<dynamic> sortedListData = [];

  Map<double, dynamic> map = new Map();
  var sortedKeys;
  int pageNumber = 0;
  bool isLoading;
  var place_id;
  var place_code;
  String url;
  @override
  void initState() {
    url = FlutterConfig.get('API_URL');
    sortedListData = [];

    userId = widget.userId ?? "";
    latitude = widget.latitude ?? "";
    longitude = widget.longitude ?? "";
    tableType = widget.tableType ?? "";
    myFuture = _getDataList();
    super.initState();

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      if (currentScroll == maxScroll && !isLoading) {
        pageNumber++;
        isLoading = true;
        _getDataList();
      }
    });
  }





  Future<List<dynamic>> _getDataList() async {
    sortedListData  = await places.getList(tableType, latitude, longitude, pageNumber, userId);
    return sortedListData;
   }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  icon iconwidget = new icon();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  highlightColor: Colors.white,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "./assets/listPage/backbutton.png",
                        width: 44.w,
                        height: 76.h,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 45.w,
                      )),
                      Container(
                        // width: 310.w,
                        child: Text(
                          (() {
                            if (tableType == 'restaurant') {
                              return "식당·카페";
                            } else if (tableType == "Examination_institution") {
                              return "병원";
                            } else if (tableType == "Experience_center") {
                              return "체험관";
                            } else {
                              return "키즈카페";
                            }
                          }()),
                          style: TextStyle(
                              fontSize: 62.sp,
                              fontFamily: 'NotoSansCJKkr_Medium',
                              color: Color.fromRGBO(255, 114, 148, 1.0)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 30.w),
                  child: toggle
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              toggle = !toggle;
                              if (indexcount == 1)
                                indexcount = 0;
                              else
                                indexcount = 1;
                            });
                          },
                          child: Image.asset(
                            './assets/on.png',
                            width: 284.w,
                            height: 133.h,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              toggle = !toggle;
                              if (indexcount == 1)
                                indexcount = 0;
                              else
                                indexcount = 1;
                            });
                          },
                          child: Image.asset(
                            './assets/off.png',
                            width: 284.w,
                            height: 133.h,
                          ),
                        ),
                ),
              ],
            ),
          ),
          body: IndexedStack(index: indexcount, children: <Widget>[
            listView(context, 1501.w, 2667.h),
            map_list(
              userId: userId,

              latitude: latitude,
              longitude: longitude,
              list: tableType,
              place_code: place_code,
            ),
          ])),
    );
  }

  Widget listView(context, screenWidth, screenHeight) {
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
           return Scrollbar(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: sortedListData?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0.3,
                    child: Container(
                        height: 450.h,
                        padding: EdgeInsets.only(
                          top: 1.h,
                          left: 26.w,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              highlightColor: Colors.white,
                              onTap: () async {
                                var result = await Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: SubListPage(
                                        index: index,
                                        data: snapshot.data[index],
                                        userId: userId,
                                        tableType: tableType,
                                      ),
                                      duration: Duration(milliseconds: 250),
                                      reverseDuration:
                                          Duration(milliseconds: 100),
                                    ));
                                setState(() {
                                  snapshot.data[index].bookmark =
                                      int.parse(result);
                                });
                              },
                              child: Container(
                                width: 1280.w,
                                //     color:Colors.pink,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          // border: Border.all(width: 3.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              (() {
                                                if (tableType == 'restaurant') {
                                                  if (index % 3 == 1)
                                                    return restaurantListImage[
                                                        0];
                                                  else if (index % 3 == 2)
                                                    return restaurantListImage[
                                                        1];
                                                  else
                                                    return restaurantListImage[
                                                        2];
                                                } else if (tableType ==
                                                    'Examination_institution') {
                                                  if (index % 2 == 1)
                                                    return hospitalListImage[0];
                                                  else
                                                    return hospitalListImage[1];
                                                } else if (tableType ==
                                                    'Experience_center') {
                                                  if (index % 4 == 1)
                                                    return experienceListImage[
                                                        0];
                                                  else if (index % 4 == 2)
                                                    return experienceListImage[
                                                        1];
                                                  else if (index % 4 == 3)
                                                    return experienceListImage[
                                                        2];
                                                  else
                                                    return experienceListImage[
                                                        3];
                                                } else {
                                                  if (index % 2 == 1)
                                                    return kidsCafeListImage[0];
                                                  else
                                                    return kidsCafeListImage[1];
                                                }
                                              }()),
                                            ),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      height: 414.h,
                                      width: 413.w,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                      left: 53.w,
                                    )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.only(top: 10.h)),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(top: 20.h),
                                              width: 700.w,
                                              height: 82.h,
                                              child: Text(
                                                snapshot.data[index].name,
                                                style: TextStyle(
                                                  fontSize: 56.sp,
                                                  fontFamily:
                                                      'NotoSansCJKkr_Medium',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 135.h,
                                          width: 650.w,
                                          child: Text(
                                            snapshot.data[index].address,
                                            style: TextStyle(
                                              // fontFamily: 'NatoSans',
                                              color: Colors.grey,
                                              fontSize: 56.sp,
                                              fontFamily:
                                                  'NotoSansCJKkr_Medium',
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        tableType == 'restaurant'
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(top: 15.h),
                                                height: 120.h,
                                                width: 650.w,
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Row(
                                                  children: [
                                                    iconwidget.chair(
                                                        snapshot
                                                            .data[index].chair,
                                                        context),
                                                    iconwidget.carriage(
                                                        snapshot.data[index]
                                                            .carriage,
                                                        context),
                                                    iconwidget.menu(
                                                        snapshot
                                                            .data[index].menu,
                                                        context),
                                                    iconwidget.bed(
                                                        snapshot
                                                            .data[index].bed,
                                                        context),
                                                    iconwidget.tableware(
                                                        snapshot.data[index]
                                                            .tableware,
                                                        context),
                                                    iconwidget.meetingroom(
                                                        snapshot.data[index]
                                                            .meetingroom,
                                                        context),
                                                    iconwidget.diapers(
                                                        snapshot.data[index]
                                                            .diapers,
                                                        context),
                                                    iconwidget.playroom(
                                                        snapshot.data[index]
                                                            .playroom,
                                                        context),
                                                    iconwidget.nursingroom(
                                                        snapshot.data[index]
                                                            .nursingroom,
                                                        context),
                                                  ],
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30.w, top: 25.h),

                              //         color:Colors.yellow,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(
                                  maxWidth: 70.w,
                                  maxHeight: 70.h,
                                ),
                                icon: Image.asset(
                                  snapshot.data[index].bookmark == 0
                                      ? "./assets/listPage/star_grey.png"
                                      : "./assets/listPage/star_color.png",
                                  height: 60.h,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    print(snapshot.data[index].id);
                                    place_id = snapshot.data[index].id;
                                  });
                                  if (snapshot.data[index].bookmark == 0) {
                                    bookMark.bookmarkCreate(userId,place_id);
                                    snapshot.data[index].bookmark = 1;
                                  } else {
                                    bookMark.bookmarkDelete(userId,place_id);
                                    snapshot.data[index].bookmark = 0;
                                  }
                                },
                              ),
                            ),
                          ],
                        )),
                  );
                }),
          );
        }
        return Center(
          child: SizedBox(
              width: 60,
              height: 60,
              child: buildSpinKitThreeBounce(80, screenWidth)),
        );
      },
    );
  }
}
