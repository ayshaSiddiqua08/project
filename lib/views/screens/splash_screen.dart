import 'package:Taayza/generated/assets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../global/app_constants.dart';
import '../../controllers/global_controller.dart';

class SplashScreen extends StatelessWidget {
  final controller = Get.put(GlobalController(), permanent: true);

  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.white,
      Colors.white,
    ];

    final colorizeTextStyle = TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.assetsSplash,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 150.h,
              width: 150.w,
              decoration: const BoxDecoration(
                  /*color: Colors.white.withOpacity(
                  0.8,
                ),
                borderRadius: BorderRadius.circular(
                  20.r,
                ),*/
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.assetsLogo,
                    height: 40.h,
                    width: 40.w,
                    //color: tealColor,
                    color: whiteColor,
                  ),
                  Text(
                    "Taayza",
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                      //color: tealColor.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                      color: whiteColor,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Assalamualaikum',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                      ColorizeAnimatedText(
                        'Welcome',
                        textStyle: colorizeTextStyle,
                        colors: colorizeColors,
                      ),
                    ],
                    isRepeatingAnimation: true,
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
