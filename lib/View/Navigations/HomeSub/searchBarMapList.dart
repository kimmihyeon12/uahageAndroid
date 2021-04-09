
import 'package:uahage/Model/bottom_helper.dart';
import 'package:uahage/View/Navigations/HomeSub/listSub.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/Widget/starManager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uahage/Widget/icon.dart';
import 'package:uahage/Widget/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:uahage/Provider/ConnectivityStatus.dart';

import 'package:uahage/Widget/snackBar.dart';

import 'package:uahage/Widget/showPopupMenu.dart';
class Map_List_Toggle extends StatefulWidget {
  Map_List_Toggle(
      {Key key,
        this.latitude,
        this.longitude,
        this.searchkey,
        this.userId,
        this.loginOption})
      : super(key: key);
  String userId;
  String loginOption;
  String latitude;
  String longitude;
  var searchkey;
  @override
  _Map_List_ToggleState createState() => _Map_List_ToggleState();
}

class _Map_List_ToggleState extends State<Map_List_Toggle> {
  @override
  String userId = "";
  String loginOption = "";
  int position;
  var switchbtn = 1;
  WebViewController controller;
  var searchbtn = 0;
  var i = 0;
  var Message;

  var star_color = false;
  var index = 1;
  List<String> store_namelist = List(500);
  List<String> addresslist = List(500);

  void initState() {
    super.initState();
    loginOption = widget.loginOption;
    userId = widget.userId ?? "";
  }

  StarManage starInsertDelete = new StarManage();
  toast show_toast = new toast();
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

  doneLoading(String A) {
    setState(() {
      switchbtn = 1;
    });
  }

  Widget startLoading(String A) {
    setState(() {
      switchbtn = 2;
    });
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  icon iconwidget = new icon();
  showPopup showpopup = new showPopup();
  Widget build(BuildContext context) {
    ConnectivityStatus connectionStatus = Provider.of<ConnectivityStatus>(context);
    print(store_namelist[0]);
    var latitude = widget.latitude;
    var longitude = widget.longitude;
    var searchkey = widget.searchkey;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ScreenUtil.init(context, width: 1500, height: 2667);

    return
      IndexedStack(
        index: switchbtn,
        children: [

          WillPopScope(
            onWillPop: _onbackpressed,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 250.h,
                // automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_sharp,
                    color: Color(0xffff7292),
                  ),
                  iconSize: 100.w,
                  color: Colors.white,
                  onPressed: () {
                    // setState(() {
                    //   searchbtn = false;
                    //   print(searchbtn);
                    // });
                    Navigator.pop(context, 'closed');
                  },
                ),
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                          top: 500.h,
                        )),
                    // Padding(
                    //     padding: EdgeInsets.only(
                    //   left: 870 .w,
                    // )),
                    GestureDetector(
                      child: Image.asset(
                        './assets/off.png',
                        width: 290.w,
                        height: 183.h,
                      ),
                      onTap: () {
                        setState(() {
                          switchbtn = 1;
                          print(searchbtn);

                        });
                      },
                    ),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  connectionStatus != ConnectivityStatus.Offline ?
                  ListView.builder(
                      itemCount: i,
                      itemBuilder: (context, index) {
                        print('snapshot.data.length');
                        // print(snapshot.data.id[index]);
                        return Card(
                          elevation: 0.3,
                          child: GestureDetector(
                            child: Container(
                                height: 400.h,
                                padding: EdgeInsets.only(
                                  top: 30.h,
                                  left: 26.w,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                          top: 200 /
                                              (1501 / MediaQuery.of(context).size.width),
                                        )),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 1300.w,
                                          height: 100.h,
                                          child: Text(
                                            store_namelist[index],
                                            style: TextStyle(
                                              fontSize: 56.sp,
                                              fontFamily: 'NotoSansCJKkr_Medium',
                                            ),
                                          ),
                                        ),
                                        SafeArea(
                                          child: Container(
                                            height: 200.h,
                                            width: 800.w,
                                            child: Text(
                                              addresslist[index],
                                              style: TextStyle(
                                                // fontFamily: 'NatoSans',
                                                  color: Colors.grey,
                                                  fontSize: 56.sp,
                                                  fontFamily: 'NotoSansCJKkr_Medium',
                                                  height: 1.3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        );
                      }):SnackBarpage(),
                ],
              ),
            ),
          ),
          WillPopScope(
            onWillPop: _onbackpressed,
            child: Scaffold(
              body: Stack(
                children: [
                  connectionStatus != ConnectivityStatus.Offline ?
                  SafeArea(
                    child: Stack(children: [
                      WebView(
                        onPageFinished: doneLoading,
                        onPageStarted: startLoading,
                        onWebViewCreated:
                            (WebViewController webViewController) async {
                          controller = webViewController;
                          await controller.loadUrl(
                              "http://hohocompany.co.kr/map/homesearch?lat=$latitude&long=$longitude&address='$searchkey'");
                        },
                        javascriptMode: JavascriptMode.unrestricted,
                        javascriptChannels: Set.from([

                          JavascriptChannel(
                              name: 'Print',
                              onMessageReceived: (JavascriptMessage message) async {
                                var messages = message.message;
                                print("messages: $messages");
                                var ex = messages.split(",");
                                setState(() {

                                  for (int j = 0; j < 2; j++) {
                                    store_namelist[i] = ex[0];
                                    addresslist[i] = ex[1];
                                    print(i.toString() +
                                        "store_namelist" +
                                        store_namelist[i]);
                                    print(i.toString() +
                                        "addresslist" +
                                        addresslist[i]);
                                  }
                                  i++;

                                });
                              }),

                          JavascriptChannel(
                              name: 'Print1',
                              onMessageReceived: (JavascriptMessage message) async {
                                var messages = message.message;
                                print("Print1: $messages");
                                Message = messages.split("|");
                                await getSubStarColor();
                                showpopup.showPopUpbottomMenu(context, 2667.h, 1501.w,  Message,
                                    index,
                                    userId,
                                    loginOption,
                                    star_color,
                                    "list");
                              })
                        ]),
                      ),

                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                top: 250.h,
                              )),
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios_sharp),
                            iconSize: 100.w,
                            color: Color(0xffff7292),
                            onPressed: () {
                              setState(() {
                                searchbtn = 0;

                              });
                              Navigator.pop(context, 'Yep!');
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                left: 950.w,
                              )),
                          GestureDetector(
                            child: Image.asset(
                              './assets/on.png',
                              width: 290.w,
                              height: 183.h,
                            ),
                            onTap: () {
                              setState(() {
                                switchbtn = 0;

                              });
                            },

                          ),
                        ],
                      )
                    ]),
                  ):SnackBarpage(),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Center(
                child: buildSpinKitThreeBounce(80, 1500.w)),
          )

        ],
      ) ;
  }


  Future<bool> _onbackpressed() {
    setState(() {
      return Navigator.pop(context);
    });
  }
}
