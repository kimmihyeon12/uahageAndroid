import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/Widget/icon.dart';
import 'package:uahage/Model/bottom_helper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/Widget/toast.dart';
import 'package:uahage/View/Navigations/HomeSub/listSub.dart';

import 'dart:async';
import 'package:uahage/API/bookMark.dart';

class showPopup extends StatelessWidget {
  icon iconwidget = new icon();
  toast show_toast = new toast();

  List<int> grey_image = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  var place_id;
  var star_color;




  Future<Object> showPopUpMenu(context, double screenHeight, double screenWidth,
      latitude, longitude, grey_image) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(builder: (context, setState) {
            return SafeArea(
              child: Builder(builder: (context) {
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 600.h, bottom: 0.h, left: 190.w, right: 0.w),
                      width: 1100.w,
                      height: 1060.h,
                      child: Card(
                        shadowColor: Colors.black54,
                        elevation: 1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 85.h, left: 50.w, right: 50.w),
                          child: SizedBox(
                            child: GridView.count(

                              crossAxisCount: 3,
                              children: List.generate(9, (index) {
                                return Scaffold(
                                  backgroundColor: Colors.white,
                                  body: Center(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          grey_image[index] = 1;
                                        });
                                        print(grey_image);
                                      },
                                      child: grey_image[index] == 0
                                          ? Image.asset(
                                              "./assets/searchPage/image" +
                                                  (index + 1).toString() +
                                                  "_grey.png",
                                              height: 293.h,
                                              width: 218.w,
                                            )
                                          : Image.asset(
                                              "./assets/searchPage/image" +
                                                  (index + 1).toString() +
                                                  ".png",
                                              height: 293.h,
                                              width: 218.w,
                                            ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1850.h,
                      left: 400.w,
                      right: 400.w,
                      child: SizedBox(
                        width: 611.w,
                        height: 195.h,
                        child: FlatButton(
                          onPressed: () async {
                            Navigator.pop(context, grey_image);
                            grey_image = [
                              0,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0,
                              0,
                            ];
                         },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          color: Color.fromRGBO(255, 114, 148, 1.0),
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'NotoSansCJKkr_Medium',
                              fontSize: 60.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            );
          });
        },
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: null,
        transitionDuration: const Duration(milliseconds: 150));
  }

  Future<Object> showPopUpbottomMenu(
      BuildContext context,
      double screenHeight,
      double screenWidth,
      Message,
      index,
      userId,
      loginOption,
       type,
      tableType) {
    print(Message);
    star_color = Message["bookmark"];
    place_id = Message["id"];
    return showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(builder: (context, setState) {
            return Builder(builder: (context) {
              return Stack(
                children: [
                  GestureDetector(
                    onPanDown: (a) {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: type == 'search' ? 1874.h : 2100.h,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: type == 'search' ? 1900.h : 2100.h,
                        bottom: type == 'search' ? 263.h : 50.h,
                        left: 33.w,
                        right: 33.w),
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shadowColor: Colors.black54,
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final btm = BottomButton(
                              storeName: Message["name"],
                              address1: Message["address"],
                              phone1: Message["phone"],
                              carriage1: Message["carriage"],
                              bed1: Message["bed"],
                              tableware1: Message["tableware"],
                              nursingroom1: Message["nursingroom"],
                              meetingroom1: Message["meetingroom"],
                              diapers1: Message["diapers"],
                              chair1: Message["chair"],
                              menu1: Message["menu"],
                              playroom1:Message["playroom"],
                              Examination_item1: Message["examination"],
                              fare1: Message["fare"],
                              bookmark1 :Message["bookmark"]
                          );

                          final result = await Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: SubListPage(
                                  index: index + 1,
                                  data: btm,
                                  userId: userId,
                                  loginOption: loginOption,
                                  tableType: tableType,
                                ),
                                duration: Duration(milliseconds: 100),
                                reverseDuration: Duration(milliseconds: 100),
                              ));
                          result
                              ? setState(() {
                                  star_color = true;
                                })
                              : setState(() {
                                  star_color = false;
                                });
                        },
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                              left: 30.w,
                            )),
                            Image.asset(
                              "./assets/listPage/clipGroup1.png",
                              height: 409.h,
                              width: 413.w,
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              left: 53.w,
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 50.h),
                                  width: 900.w,
                                  height: 82.h,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 700.w,
                                        child: Text(
                                            Message["name"].length <= 10
                                                ? Message["name"]
                                                : Message["name"].substring(0, 11),
                                            style: TextStyle(
                                              color: const Color(0xff010000),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "NotoSansCJKkr_Bold",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 58.sp,
                                            ),
                                            textAlign: TextAlign.left),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: Image.asset(
                                            star_color=="0"
                                                ? "./assets/listPage/star_grey.png"
                                                : "./assets/listPage/star_color.png",
                                            height: 60.h),
                                        onPressed: loginOption == "login"
                                            ? () {
                                                show_toast.showToast(
                                                    context, "로그인해주세요!");
                                              }
                                            : () async {
                                                setState(() {
                                                  if(star_color=="0"){
                                                    star_color = "1";
                                                    bookMark.bookmarkCreate(userId,place_id);
                                                  }

                                                  else {
                                                    star_color = "0";
                                                    bookMark.bookmarkDelete(userId,place_id);
                                                  }
                                                });

                                              },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10.h),
                                  width: 650.w,
                                  height: 135.h,
                                  child: Text(Message["address"],
                                      style: TextStyle(
                                          color: const Color(0xffb0b0b0),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "NotoSansCJKkr_Medium",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 56.sp,
                                          height: 1.3),
                                      textAlign: TextAlign.left),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15.h),
                                  height: 120.h,
                                  width: 650.w,
                                  alignment: Alignment.bottomRight,
                                  child: Row(children: [
                                    iconwidget.menu(Message["menu"], context),
                                    iconwidget.bed(Message["bed"], context),
                                    iconwidget.tableware(Message["tableware"], context),
                                    iconwidget.meetingroom(Message["meetingroom"], context),
                                    iconwidget.diapers(Message["diapers"], context),
                                    iconwidget.playroom(Message["playroom"], context),
                                    iconwidget.carriage(Message["carriage"], context),
                                    iconwidget.nursingroom(
                                        Message["nursingroom"], context),
                                    iconwidget.chair(Message["chiar"], context),
                                  ]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
          });
        },
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: null,
        transitionDuration: const Duration(milliseconds: 150));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
