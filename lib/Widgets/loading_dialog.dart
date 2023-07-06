import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrgio_remedies/Constant/assets.dart';
import 'package:scrgio_remedies/Constant/constants.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class LoadingDialog extends StatelessWidget {
  LoadingDialog({super.key}) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              // decoration:  BoxDecoration(
              //   color: Colors.black54,
              //   // shape: BoxShape.circle,
              // ),
              child: SizedBox(
                // height: 6.h,
                // width: 24,
                child: Shimmer.fromColors(
                  baseColor: Constants.primaryColor,
                  highlightColor: Constants.secondaryColor,
                  child: Image.asset(
                    Assets.logo,
                    color: Constants.primaryColor,
                    scale: 2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
