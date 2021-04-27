import 'package:flutter/material.dart';

class icon extends StatelessWidget {


  static menu(String menu, context) {
    var menus = menu.toString();

    return menus == "1"
        ? Container(
      child: Image.asset("./assets/listPage/menu.png", width: 30, height: 30),
      padding: EdgeInsets.only(
          right: 20 / (1501 / MediaQuery.of(context).size.width)),
    )
        : Container(
      child: Image.asset("./assets/listPage/menu.png", width: 0, height: 0),
      padding: EdgeInsets.only(
          right: 0 / (1501 / MediaQuery.of(context).size.width)),
    );
  }

  static bed(String bed, context) {
    var beds = bed.toString();

    return beds == "1"
        ? Container(
      child: Image.asset(  "./assets/listPage/bed.png", width: 30, height: 30),
      padding: EdgeInsets.only(
          right: 20 / (1501 / MediaQuery.of(context).size.width)),
    )
        : Container(
      child: Image.asset(  "./assets/listPage/bed.png", width: 0, height: 0),
      padding: EdgeInsets.only(
          right: 0 / (1501 / MediaQuery.of(context).size.width)),
    );
  }

  static  tableware(String tableware, context) {
    var tablewares = tableware.toString();

    return tablewares == "1"
        ? Container(
      child: Image.asset(    "./assets/listPage/tableware.png", width: 30, height: 30),
      padding: EdgeInsets.only(
          right: 20 / (1501 / MediaQuery.of(context).size.width)),
    )
        : Container(
      child: Image.asset(    "./assets/listPage/tableware.png", width: 0, height: 0),
      padding: EdgeInsets.only(
          right: 0 / (1501 / MediaQuery.of(context).size.width)),
    );
  }

  static meetingroom(String meetingroom, context) {
    var meetingrooms = meetingroom.toString();

    return meetingrooms == "1"
        ? Container(
      child: Image.asset( "./assets/listPage/meetingroom.png", width: 30, height: 30),
      padding: EdgeInsets.only(
          right: 20 / (1501 / MediaQuery.of(context).size.width)),
    )
        : Container(
      child: Image.asset( "./assets/listPage/meetingroom.png", width: 0, height: 0),
      padding: EdgeInsets.only(
          right: 0 / (1501 / MediaQuery.of(context).size.width)),
    );
  }

  static diapers(String diapers, context) {
    var diaperss = diapers.toString();

    return diaperss == "1"
        ? Container(
      child: Image.asset("./assets/listPage/diapers.png", width: 30, height: 30),
      padding: EdgeInsets.only(
          right: 20 / (1501 / MediaQuery.of(context).size.width)),
    )
        : Container(
      child: Image.asset("./assets/listPage/diapers.png",width: 0, height: 0),
      padding: EdgeInsets.only(
          right: 0 / (1501 / MediaQuery.of(context).size.width)),
    );
  }

  static playroom(String playroom, context) {
    var playrooms = playroom.toString();

    return playrooms == "1"
        ? Container(
      child: Image.asset( "./assets/listPage/playroom.png", width: 30, height: 30),
      padding: EdgeInsets.only(
          right: 20 / (1501 / MediaQuery.of(context).size.width)),
    )
        : Container(
      child: Image.asset( "./assets/listPage/playroom.png", width: 0, height: 0),
      padding: EdgeInsets.only(
          right: 0 / (1501 / MediaQuery.of(context).size.width)),
    );
  }

  static carriage(String carriage, context) {
    var carriages = carriage.toString();

    return carriages == "1"
        ? Container(
      child: Image.asset(    "./assets/listPage/carriage.png", width: 30, height: 30),
      padding: EdgeInsets.only(
          right: 20 / (1501 / MediaQuery.of(context).size.width)),
    )
        : Container(
      child: Image.asset(    "./assets/listPage/carriage.png", width: 0, height: 0),
    );
  }

  static nursingroom(String nursingroom, context) {
    var nursingrooms = nursingroom.toString();

    return nursingrooms == "1"
        ? Container(
      child: Image.asset(    "./assets/listPage/nursingroom.png", width: 30, height: 30),
      padding: EdgeInsets.only(
          right: 20 / (1501 / MediaQuery.of(context).size.width)),
    )
        : Container(
      child: Image.asset(    "./assets/listPage/nursingroom.png", width: 0, height: 0),
      padding: EdgeInsets.only(
          right: 0 / (1501 / MediaQuery.of(context).size.width)),
    );
  }

  static chair(String chair, context) {
    var chairs = chair.toString();

    return chairs == "1"
        ? Container(
      child: Image.asset(    "./assets/listPage/chair.png", width: 30, height: 30),
      padding: EdgeInsets.only(
          right: 20 / (1501 / MediaQuery.of(context).size.width)),
    )
        : Container(
      child: Image.asset(    "./assets/listPage/chair.png", width: 0, height: 0),
      padding: EdgeInsets.only(
          right: 0 / (1501 / MediaQuery.of(context).size.width)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
