import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:uahage/Provider/locationProvider.dart';
import 'package:uahage/Provider/ConnectivityStatus.dart';

class IndexMap extends StatefulWidget {
  @override
  _IndexMapState createState() => _IndexMapState();
}

class _IndexMapState extends State<IndexMap> {
  WebViewController controller;
  LocationProvider lacationprovider;
  ConnectivityStatus connectionStatus;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1501, height: 2667);
    connectionStatus = Provider.of<ConnectivityStatus>(context);
    lacationprovider = Provider.of<LocationProvider>(context);
    var latitude = lacationprovider.getlatitude;
    var longitude = lacationprovider.getlongitude;

    return Scaffold(
      body: Stack(children: [
        WebView(
          onWebViewCreated: (WebViewController webViewController) {
            controller = webViewController;
            controller.loadUrl(
                'http:///121.147.203.126:8000/maps?lat=$latitude&lon=$longitude');
            print(controller.currentUrl().toString());
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
        Center(
            child: Image.network(
          'https://i.pinimg.com/originals/b6/b1/d6/b6b1d64609f266d8f236752d8551f26f.gif',
          width: 500.w,
        )),
      ]),
    );
  }
}
