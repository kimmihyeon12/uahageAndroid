import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uahage/Model/bottom_helper.dart';
import 'package:uahage/View/Navigations/HomeSub/listSub.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/Widget/toast.dart';
import 'package:uahage/Widget/starManager.dart';
import 'package:uahage/Widget/icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/Widget/indexMap.dart';
 
import 'package:uahage/Widget/showPopupMenu.dart';
class searchPage extends StatefulWidget {
  searchPage(
      {Key key,
        this.latitude,
        this.longitude,
        this.userId,
        this.loginOption,
        this.Area,
        this.Locality})
      : super(key: key);
  String latitude;
  String longitude;
  String loginOption;
  String userId;
  String Locality;
  String Area;
  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  var latitude;
  var longitude;
  String Area = "";
  String Locality = "";
  String searchKey = "";
  var star_color = false;
  String userId = "";
  String loginOption = "";
  int index = 1;
  var Message;

  toast show_toast = new toast();
  List<String> star_color_list = List(2);
  List<bool> grey_image = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];


  searchAddress(searchKey) async {
    // ignore: unnecessary_statements
    print(searchKey);
    searchKey != ""
        ? controller.loadUrl(
        'http://13.209.41.43/map/getAddress?address=$searchKey')
    // ignore: unnecessary_statements
        : null;
  }

  Future searchCategory(latitude, longitude) async {
    print(grey_image);
    controller.loadUrl(
        "http://13.209.41.43/map/searchCategory?lat=$latitude&long=$longitude&menu=${grey_image[0]}&bed=${grey_image[1]}&tableware=${grey_image[2]}&meetingroom=${grey_image[3]}&diapers=${grey_image[4]}&playroom=${grey_image[5]}&carriages=${grey_image[6]}&nursingroom=${grey_image[7]}&chair=${grey_image[8]}&Area=$Area&Locality=$Locality");
  }

  StarManage starInsertDelete = new StarManage();

  Future click_star() async {
    await starInsertDelete.click_star(
        userId + loginOption,
        Message[0],
        Message[1],
        Message[2],
        Message[3],
        Message[4],
        Message[5],
        Message[6],
        Message[7],
        Message[8],
        Message[9],
        Message[10],
        Message[11],
        null,
        null,
        star_color,
        "restaurant");
  }

  Future getSubStarColor() async {
    star_color =
    await starInsertDelete.getSubStarColor(userId, loginOption, Message[0]);
    setState(() {
      star_color = star_color;
    });
  }

  // WebViewController _controller;
  WebViewController controller;
  icon iconwidget = new icon();
  showPopup showpopup = new showPopup();
  @override
  void initState() {
    setState(() {
      longitude = widget.longitude ?? "";
      latitude = widget.latitude ?? "";
      loginOption = widget.loginOption ?? "";
      userId = widget.userId ?? "";
      Area = widget.Area ?? "";
      Locality = widget.Locality ?? "";
    });
  }


  int position = 0;
  final key = UniqueKey();

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  bool isIOS = Platform.isIOS;
  var isLoading = true;


  @override
  Widget build(BuildContext context) {
    latitude == "" && longitude == "" ? currentLocation() : "";

    ScreenUtil.init(context, width: 1500, height: 2667);
    return Scaffold(

      body: Stack(
        children: [
          IndexedStack(
            index: position,
            children: [
              WebView(
                key: key,
                onPageFinished: doneLoading,
                onPageStarted: startLoading,
                // initialUrl: 'http://13.209.41.43/map',
                onWebViewCreated: (WebViewController webViewController) {
                  controller = webViewController;
                  controller.loadUrl(latitude == 'NaN' ||
                      longitude == 'NaN' ||
                      latitude == '' ||
                      longitude == ''
                      ? 'http://13.209.41.43/map/'
                      : 'http://13.209.41.43/map/getPos?lat=$latitude&long=$longitude');
                },
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: Set.from([
                  JavascriptChannel(
                      name: 'Print',
                      onMessageReceived: (JavascriptMessage message) async {
                        var messages = message.message;
                        Message = messages.split("|");
                        await getSubStarColor();
                        print("star_color: $star_color");
                        print("Message: $Message");
                        showpopup.showPopUpbottomMenu(context, 2667.h, 1501.w,  Message,
                            index,
                            userId,
                            loginOption,
                            star_color,
                        "search");
                      })
                ]),
              ),
              IndexMap(),
            ],
          ),


          GestureDetector(
            onTap: () async {
              setState(() {
                grey_image = [
                  true,
                  true,
                  true,
                  true,
                  true,
                  true,
                  true,
                  true,
                  true,
                ];
              });
              List okButton = await showpopup.showPopUpMenu(
                  context,
                  2667.h,
                  1501.w,
                  latitude,
                  longitude,
                  grey_image);
              if (okButton != null) {
                grey_image = okButton;
                await searchCategory(latitude, longitude);
              }

            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              margin: EdgeInsets.fromLTRB(51.w, 161.h, 51.w, 0),
              height: 196.h,
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 53.w),
                    child: Image.asset(
                      "./assets/searchPage/arrow.png",
                      height: 68.h,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 41.w),
                    width: 1200.w,
                    child: // 검색 조건을 설정해주세요
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("검색 조건을 설정해주세요",
                            style: TextStyle(
                                color: const Color(0xffed7191),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontStyle: FontStyle.normal,
                                fontSize: 60.sp),
                            textAlign: TextAlign.left),
                        InkWell(
                          child: Image.asset(
                            "./assets/searchPage/cat_btn.png",
                            height: 158.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

  currentLocation() {}
}
