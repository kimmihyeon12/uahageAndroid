import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
  return SpinKitThreeBounce(
    color: Color(0xffFF728E),
    size: size,
  );
}

Text buildText(double _fontsize) {
  return Text("확인",
      style: TextStyle(
          color: const Color(0xffff7292),
          fontWeight: FontWeight.w500,
          fontFamily: "NotoSansCJKkr_Medium",
          fontStyle: FontStyle.normal,
          fontSize: _fontsize),
      textAlign: TextAlign.center);
}

Future buildShowDialogOnOk(var function, BuildContext context, var heightSize,
    var widthSize, var height, var width, var _fontsize) {
  ScreenUtil.init(context, width: 1500, height: 2667);
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) => FutureBuilder(
      future: function,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Text(
              snapshot.data,
              style: TextStyle(
                  color: const Color(0xff4d4d4d),
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansCJKkr_Medium",
                  fontStyle: FontStyle.normal,
                  fontSize: 55.sp),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: // 확인
                      buildText(_fontsize))
            ],
          );
        } else if (snapshot.hasError) {
          return AlertDialog(
            title: Text(
              "${snapshot.error}",
              style: TextStyle(
                  color: const Color(0xff4d4d4d),
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansCJKkr_Medium",
                  fontStyle: FontStyle.normal,
                  fontSize: 55.sp),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: // 확인
                      buildText(_fontsize))
            ],
          );
        }
        return Center(
          child: SizedBox(
              height: heightSize,
              width: widthSize,
              child: buildSpinKitThreeBounce(height, width)),
        );
      },
    ),
  );
}
