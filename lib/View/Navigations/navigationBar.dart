import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uahage/View/Navigations/Home.dart';
import 'package:uahage/View/Navigations/MyPage.dart';
import 'package:uahage/View/Navigations/Search.dart';
import 'package:uahage/View/Navigations/Star.dart';
import 'package:uahage/Provider/ConnectivityStatus.dart';
import 'package:uahage/Provider/locationProvider.dart';
import 'package:uahage/Widget/SnackBar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class navigationPage extends StatefulWidget {
  String userId;
  String loginOption;
  String oldNickname;
  navigationPage({Key key, this.oldNickname, this.userId, this.loginOption})
      : super(key: key);
  @override
  _navigationPageState createState() => _navigationPageState();
}

class _navigationPageState extends State<navigationPage> {
  String latitude = "";
  String longitude = "";
  String userId = "";
  String loginOption = "";
  String oldNickname = "";
  var Area;
  var Locality;
  int _selectedTabIndex = 0;
  LocationProvider lacationprovider;
  ConnectivityStatus connectionStatus;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    // setState(() {
    userId = widget.userId ?? "";
    oldNickname = widget.oldNickname ?? "";
    loginOption = widget.loginOption;
    if (userId == "") {
      getTokenAndId();
    }
    // });
    super.initState();
  }

  Future getTokenAndId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.getString("uahageUserId");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void currentLocation() async {
    lacationprovider = Provider.of<LocationProvider>(context);
    await lacationprovider.setCurrentLocation();
    setState(() {
      latitude = lacationprovider.getlatitude;
      longitude = lacationprovider.getlongitude;
    });
  }

  bool isIOS = Platform.isIOS;
  @override
  Widget build(BuildContext context) {
    connectionStatus = Provider.of<ConnectivityStatus>(context);
    lacationprovider = Provider.of<LocationProvider>(context);
    //  print(latitude+","+longitude);
    latitude == "35.146076" && longitude == "126.9231225"
        ? currentLocation()
        : "";
    latitude = lacationprovider.getlatitude;
    longitude = lacationprovider.getlongitude;
    // print("latitude in nav provider: $latitude");
    // print("longitude in nav provider: $longitude");
    // print("userID in nav provider: $userId");

    ScreenUtil.init(context, width: 1500, height: 2667);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    isIOS
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
            .copyWith(
                statusBarBrightness:
                    Brightness.dark // Dark == white status bar -- for IOS.
                ))
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Color(0xffd9d4d5), // navigation bar color
            statusBarColor: Color(0xffd9d4d5), // status bar color
          ));
    return WillPopScope(
      onWillPop: () {
        if (loginOption == 'login') {
          Navigator.pop(context, true);
        } else if (_selectedTabIndex >= 1) {
          setState(() {
            _selectedTabIndex = 0;
          });
        } else
          SystemNavigator.pop();
        // Navigator.pop(context, true);
      },
      child: SafeArea(
          child: Scaffold(
              body: Stack(
                children: [
                  IndexedStack(
                    index: _selectedTabIndex,
                    children: <Widget>[
                      homePage(
                        userId: userId,
                        loginOption: loginOption,
                        latitude: latitude,
                        longitude: longitude,
                      ),
                      searchPage(
                          latitude: latitude,
                          longitude: longitude,
                          userId: userId,
                          loginOption: loginOption,
                          Area: Area,
                          Locality: Locality),
                      starPage(userId: userId, loginOption: loginOption),
                      myPage(userId: userId, loginOption: loginOption),
                    ],
                  ),
                  connectionStatus == ConnectivityStatus.Offline
                      ? SnackBarpage()
                      : Container(),
                ],
              ),
              bottomNavigationBar:
                  (connectionStatus != ConnectivityStatus.Offline)
                      ? BottomNavigationBar(
                          currentIndex: _selectedTabIndex,
                          showSelectedLabels: false, // <-- HERE
                          showUnselectedLabels: false,
                          elevation: 15,
                          backgroundColor: Colors.white,
                          onTap: (value) {
                            setState(() {
                              _selectedTabIndex = value;
                            });
                          },
                          type: BottomNavigationBarType.fixed,
                          items: [
                            BottomNavigationBarItem(
                              icon: Image.asset(
                                "assets/NavigationbarPage/home_grey.png",
                                width: 79.w,
                                height: 144.h,
                              ),
                              label: "home",
                              activeIcon: Image.asset(
                                "assets/NavigationbarPage/home_pink.png",
                                width: 79.w,
                                height: 144.h,
                              ),
                              // title: Text("home"),
                            ),
                            BottomNavigationBarItem(
                              label: "",
                              icon: Image.asset(
                                "assets/NavigationbarPage/search_grey.png",
                                width: 79.w,
                                height: 139.h,
                              ),
                              activeIcon: Image.asset(
                                "assets/NavigationbarPage/search_pink.png",
                                width: 79.w,
                                height: 139.h,
                              ),
                              // title: Text("search"),
                            ),
                            BottomNavigationBarItem(
                              label: "",
                              icon: Image.asset(
                                "assets/NavigationbarPage/star_grey.png",
                                width: 162.w,
                                height: 147.h,
                              ),
                              activeIcon: Image.asset(
                                "assets/NavigationbarPage/star_pink.png",
                                width: 162.w,
                                height: 147.h,
                              ),
                              // title: Text("star"),
                            ),
                            BottomNavigationBarItem(
                              label: "",

                              icon: Image.asset(
                                "assets/NavigationbarPage/mypage_grey.png",
                                width: 132.w,
                              ),
                              activeIcon: Image.asset(
                                "assets/NavigationbarPage/mypage_pink.png",
                                width: 132.w,
                                height: 141.h,
                              ),
                              // title: Text("mypage"),
                            ),
                          ],
                        )
                      : null)),
    );
  }
}
