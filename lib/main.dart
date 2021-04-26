import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uahage/View/Auth/wrapper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/Provider/locationProvider.dart';
import 'package:uahage/Provider/connectivityservice.dart';
import 'package:uahage/Provider/ConnectivityStatus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        StreamProvider<ConnectivityStatus>.value(
          value: ConnectivityService().connectionStatusController.stream,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userId = "";
  String loginOption = "";
  String latitude = "";
  String longitude = "";
  @override
  void initState() {
    super.initState();
  }

  startTime() async {
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    await locationProvider.setCurrentLocation();
    var duration = new Duration(seconds: 2);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Wrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    startTime();
    double screenHeight;
    double screenWidth;

    screenHeight = 2667 / MediaQuery.of(context).size.height;
    screenWidth = 1501 / MediaQuery.of(context).size.width;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
        backgroundColor: Color(0xfffff1f0),
        body: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Image(
                image: AssetImage('./assets/firstPage/backfamily.png'),

                width: 1446 / screenWidth,
                // height: 50,
              ),
            ),
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                  left: 658 / screenWidth,
                )),
                Image(
                  image: AssetImage('./assets/firstPage/Lighting.png'),
                  height: 440 / screenHeight,
                  width: 143 / screenWidth,
                ),
                Image(
                  image: AssetImage('./assets/firstPage/logo.png'),
                  height: 88 / screenHeight,
                  width: 662 / screenWidth,
                ),
              ],
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 666 / screenHeight, 0, 0),
                    child: Image(
                      image: AssetImage('./assets/firstPage/group.png'),
                      height: 357 / screenHeight,
                      width: 325 / screenWidth,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 79 / screenHeight, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "우리아이",
                          style: TextStyle(
                              fontFamily: "S_CoreDream_8",
                              //   height: 1.0,
                              //   letterSpacing: -1.0,
                              fontSize: 71 / screenHeight,
                              // fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 114, 148, 1.0)),
                        ),
                        Text(
                          "와 함께하는",
                          style: TextStyle(
                              fontFamily: "S_CoreDream_4",
                              fontSize: 71 / screenHeight,
                              color: Color.fromRGBO(255, 114, 148, 1.0)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 49 / screenHeight, 0, 0),
                    child: Image(
                      image: AssetImage('./assets/firstPage/uahage.png'),
                      height: 113 / screenHeight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
