import 'package:flutter/material.dart';
import 'package:uahage/Model/bottom_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uahage/Widget/icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/View/Navigations/HomeSub/listSub.dart';
import 'package:uahage/Widget/showPopupMenu.dart';
import 'dart:convert';
import 'dart:async';
import 'package:uahage/API/bookMark.dart';
import 'package:flutter_config/flutter_config.dart';

class map_list extends StatefulWidget {
  map_list(
      {Key key,
      this.latitude,
      this.longitude,
      this.list,
      this.userId,
      this.loginOption,
      this.place_code})
      : super(key: key);
  String loginOption;
  String userId;
  String latitude;
  String longitude;
  String list;
  var place_code;
  @override
  _map_listState createState() => _map_listState();
}

class _map_listState extends State<map_list> {
  String url;
  String loginOption;
  String userId;
  String latitude = "";
  String longitude = "";
  String list;
  var listrequest;
  var place_code;
  var index = 1;
  var Message;
  List<int> grey_image = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  var star_color = false;
  var place_id;
  Future searchCategory() async {
    controller.loadUrl(
       url+"/maps/show-place?lat=$latitude&lon=$longitude&type=filter&user_id=59&menu=${grey_image[0]}&bed=${grey_image[1]}&tableware=${grey_image[2]}&meetingroom=${grey_image[3]}&diapers=${grey_image[4]}&playroom=${grey_image[5]}&carriage=${grey_image[6]}&nursingroom=${grey_image[7]}&chair=${grey_image[8]}");
  }






  WebViewController controller;
  icon iconwidget = new icon();

  @override
  void initState() {
    setState(() {
      url = FlutterConfig.get('API_URL');
      list = widget.list;
      loginOption = widget.loginOption;
      userId = widget.userId ?? "";
      latitude = widget.latitude;
      longitude = widget.longitude;
      listrequest = widget.list;
      place_code = widget.place_code;
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

  showPopup showpopup = new showPopup();

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
                      longitude == '') {} else {
                    controller.loadUrl(
                        url+'/maps/show-place?lat=$latitude&lon=$longitude&type=allsearch&place_code=$place_code&user_id=59');
                  }
                },
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: Set.from([
                  JavascriptChannel(
                      name: 'Print',
                      onMessageReceived: (JavascriptMessage message) async {
                        var messages = message.message;
                        Message = messages.split("|");
                        var bookmark = await bookMark.bookmarkSelect(userId,Message[0]);
                         var JsonMessage = {
                          "id": Message[0],
                          "name":  Message[1],
                          "address":  Message[2],
                          "phone":  Message[3],
                          "carriage":  Message[4],
                          "bed":  Message[5],
                          "tableware":  Message[6],
                          "nursingroom":  Message[7],
                          "meetingroom":  Message[8],
                          "diapers":  Message[9],
                          "playroom":  Message[10],
                          "chair":  Message[11],
                          "menu":  Message[12],
                          "examination" : Message[13],
                          "fare" : Message[14],
                          "bookmark":  bookmark.toString()
                        };

                    await  showpopup.showPopUpbottomMenu(
                            context,
                            2667.h,
                            1501.w,
                            JsonMessage,
                            index,
                            userId,
                            loginOption,
                            "search",
                            "restaurant");

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
                grey_image = [0, 0, 0, 0, 0, 0, 0, 0, 0];
              });
              List okButton = await showpopup.showPopUpMenu(
                  context, 2667.h, 1501.w, latitude, longitude, grey_image);
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