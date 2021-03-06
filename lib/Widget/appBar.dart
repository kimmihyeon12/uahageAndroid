import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class appbar extends StatelessWidget {
  sub_appbar(String text, context, bookmark) {

    return PreferredSize(
      preferredSize: Size.fromHeight(180.h),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, centerTitle: true,
        // iconTheme: IconThemeData(
        //   color: Color(0xffff7292), //change your color here
        // ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xffff7292)),
          onPressed: () {
            Navigator.pop(context, bookmark);
            print(bookmark.toString());
          },
        ),
        title: Text(
          text,
          style: TextStyle(
              color: Color(0xffff7292),
              fontFamily: "NotoSansCJKkr_Medium",
              fontSize: 67.0.sp),
        ),
      ),
    );
  }

   static appBar(String text, context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(165.h),
      child:Container(

        child: Stack(
          children: [Image.asset('./assets/homePage/bar.png', fit: BoxFit.fill),
                    Center(
                      child: Text(
                        text
                            ,style: TextStyle(
                          color: Colors.white,
                          fontFamily: "NotoSansCJKkr_Bold",
                          fontSize: 73.0.sp
                      )
                      ),
                    )
  ],
        ),
      )


      // ),
    );
  }

  screen_appbar(String text, context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(178.h),
      child: Container(
        color: Color.fromRGBO(255, 114, 148, 1.0),
        height: 178.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Center(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Container(
                      height: 76.h,
                      width: 43.w,
                      margin: EdgeInsets.only(left: 31.w),
                      child: Image.asset("./assets/agreementPage/back.png"),
                    ),
                  ),
                ),
                Container(
                    height: 178.h,
                    width: 1500.w,
                    child: // ????????????
                        // ????????????????????? ????????????
                        Center(
                      child: Text(text,
                          style: TextStyle(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              fontFamily: "NotoSansCJKkr_Bold",
                              fontStyle: FontStyle.normal,
                              fontSize: 75.sp),
                          textAlign: TextAlign.left),
                    )),
              ],
            ),
          ],
        ),
      ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
