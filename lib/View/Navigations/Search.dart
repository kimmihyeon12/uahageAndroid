import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:uahage/Provider/locationProvider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:uahage/Widget/toast.dart';
import 'package:uahage/Widget/icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/Widget/indexMap.dart';
import 'package:http/http.dart' as http;
import 'package:uahage/Widget/showPopupMenu.dart';
import 'package:flutter_config/flutter_config.dart';

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
  String url;
  var Message;
  LocationProvider lacationprovider;

  toast show_toast = new toast();
  List<String> star_color_list = List(2);

  List<int> grey_image = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  Future searchCategory() async {
    controller.loadUrl(url +
        "/maps/show-place?lat=$latitude&lon=$longitude&type=filter&menu=${grey_image[0]}&bed=${grey_image[1]}&tableware=${grey_image[2]}&meetingroom=${grey_image[3]}&diapers=${grey_image[4]}&playroom=${grey_image[5]}&carriage=${grey_image[6]}&nursingroom=${grey_image[7]}&chair=${grey_image[8]}");
  }

  bookmarkSelect(place_id) async {
    var response =
        await http.get(url + "/api/bookmarks?user_id=59&place_id=$place_id");
    return json.decode(response.body)["data"]["rowCount"];
  }

  // WebViewController _controller;
  WebViewController controller;
  icon iconwidget = new icon();

  @override
  void initState() {
    setState(() {
      url = FlutterConfig.get('API_URL');
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
  showPopup showpopup = new showPopup();
  @override
  Widget build(BuildContext context) {
    print("WB" + userId);
    if (latitude == "" || longitude == "") currentLocation();

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
                onWebViewCreated: (WebViewController webViewController) async {
                  controller = webViewController;
                  print(latitude + "  " + longitude);
                  await controller
                      .loadUrl(url + '/maps?lat=$latitude&lon=$longitude');
                  print(controller.currentUrl().toString());
                },
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: Set.from([
                  JavascriptChannel(
                      name: 'Print',
                      onMessageReceived: (JavascriptMessage message) async {
                        var messages = message.message;
                        Message = messages.split("|");
                        var bookmark = await bookmarkSelect(Message[0]);
                        var JsonMessage = {
                          "id": Message[0],
                          "name": Message[1],
                          "address": Message[2],
                          "phone": Message[3],
                          "lat": Message[4],
                          "lon": Message[5],
                          "carriage": Message[6],
                          "bed": Message[7],
                          "tableware": Message[8],
                          "nursingroom": Message[9],
                          "meetingroom": Message[10],
                          "diapers": Message[11],
                          "playroom": Message[12],
                          "chair": Message[13],
                          "menu": Message[14],
                          "bookmark": bookmark.toString()
                        };
                        await showpopup.showPopUpbottomMenu(
                            context,
                            2667.h,
                            1501.w,
                            JsonMessage,
                            index,
                            userId,
                            loginOption,
                            "search",
                            "restaurant");
                      })
                ]),
              ),
              IndexMap(),
            ],
          ),
          GestureDetector(
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

  currentLocation() async {
    lacationprovider = Provider.of<LocationProvider>(context);
    await lacationprovider.setCurrentLocation();
    print("object");
    setState(() {
      latitude = lacationprovider.getlatitude;
      longitude = lacationprovider.getlongitude;
      position = 0;
    });
  }
}
