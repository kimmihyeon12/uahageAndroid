import 'package:flutter/material.dart';
import 'package:uahage/Model/bottom_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:uahage/Widget/starManager.dart';
import 'package:uahage/Widget/icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/View/Navigations/HomeSub/listSub.dart';
import 'package:uahage/Widget/showPopupMenu.dart';

class map_list extends StatefulWidget {
  map_list(
      {Key key,
      this.latitude,
      this.longitude,
      this.list,
      this.userId,
      this.loginOption,
      this.Area,
      this.Locality})
      : super(key: key);
  String loginOption;
  String userId;
  String latitude;
  String longitude;
  String list;
  String Area = "";
  String Locality = "";
  @override
  _map_listState createState() => _map_listState();
}

class _map_listState extends State<map_list> {
  String loginOption;
  String userId;
  String latitude = "";
  String longitude = "";
  String searchKey = "";
  String Area = "";
  String Locality = "";
  String list;
  var listrequest;
  var index = 1;
  var Message;
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
  var star_color = false;

  StarManage starInsertDelete = new StarManage();
  showPopup showpopup = new showPopup();

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
        list);
  }

  Future searchCategory() async {
    print(grey_image);
    controller.loadUrl(
        "http://211.223.46.144:3000/map/searchCategory?lat=$latitude&long=$longitude&menu=${grey_image[0]}&bed=${grey_image[1]}&tableware=${grey_image[2]}&meetingroom=${grey_image[3]}&diapers=${grey_image[4]}&playroom=${grey_image[5]}&carriages=${grey_image[6]}&nursingroom=${grey_image[7]}&chair=${grey_image[8]}&Area=$Area&Locality=$Locality");
  }

  Future getSubStarColor() async {
    star_color =
        await starInsertDelete.getSubStarColor(userId, loginOption, Message[0]);
    setState(() {
      star_color = star_color;
    });
  }

  searchAddress(searchKey) async {
    // ignore: unnecessary_statements
    print(searchKey);
    searchKey != ""
        ? controller.loadUrl(
            'http://211.223.46.144:3000/map/getAddress?address=$searchKey')
        : null;
  }

  WebViewController controller;
  icon iconwidget = new icon();

  @override
  void initState() {
    setState(() {
      list = widget.list;
      loginOption = widget.loginOption;
      userId = widget.userId ?? "";
      latitude = widget.latitude;
      longitude = widget.longitude;
      Area = widget.Area;
      Locality = widget.Locality;
      listrequest = widget.list;
    });
    super.initState();
    print("latt in restaurant_sub : $latitude");
    print("long in restaurant_sub : $longitude");
    // getCurrentLocation();
  }

  int zoom = 4;
  int position = 1;
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          IndexedStack(
            index: position,
            children: [
              WebView(
                key: key,
                onPageFinished: doneLoading,
                onPageStarted: startLoading,
                onWebViewCreated: (WebViewController webViewController) {
                  controller = webViewController;

                  if (latitude == 'NaN' ||
                      longitude == 'NaN' ||
                      latitude == '' ||
                      longitude == '') {
                  } else {
                    controller.loadUrl(
                        'http://211.223.46.144:3000/map/listsearchmarker/$listrequest?lat=$latitude&long=$longitude&Area=$Area&Locality=$Locality');
                  }
                },
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: Set.from([
                  JavascriptChannel(
                      name: 'Print',
                      onMessageReceived: (JavascriptMessage message) async {
                        //This is where you receive message from
                        //javascript code and handle in Flutter/Dart
                        //like here, the message is just being printed
                        //in Run/LogCat window of android studio
                        var messages = message.message;
                        print("messages:" + messages);
                        print('userId:' + userId);
                        Message = messages.split("|");
                        print("Message: $Message");
                        await getSubStarColor();
                        showpopup.showPopUpbottomMenu(context, 2667.h, 1501.w,  Message,
                            index,
                            userId,
                            loginOption,
                            star_color,
                            "list");
                      }),
                ]),
              ),
              Container(
                color: Colors.white,
                child: Center(child: buildSpinKitThreeBounce(80, 1501.w)),
              ),
            ],
          ),
          listrequest == "restaurant"
              ? GestureDetector(
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
                    List okButton = await showpopup.showPopUpMenu(context,
                        2667.h, 1501.w, latitude, longitude, grey_image);
                    if (okButton != null) {
                      grey_image = okButton;
                      await searchCategory();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 1250.w, top: 30.h),
                    child: Image.asset(
                      "./assets/searchPage/cat_btn.png",
                      height: 158.h,
                    ),
                  ),
                )
              : Container(),
        ]),
      ),
    );
  }
}
