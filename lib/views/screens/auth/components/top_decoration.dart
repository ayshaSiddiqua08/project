import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/assets.dart';
import '../../../../global/app_constants.dart';

class TopDecoration extends StatelessWidget {
  final bool isLogin;
  final bool? isOtp;

  const TopDecoration({
    super.key,
    required this.isLogin,
    this.isOtp,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.assetsSplash,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                Assets.assetsLogo,
                height: 40.h,
                width: 40.w,
                color: whiteColor,
              ),
              Text(
                isOtp == null ? "Welcome" : "OTP",
                style: TextStyle(
                  fontSize: 25.sp,
                  color: whiteColor,
                ),
              ),
              Text(
                isOtp == null
                    ? isLogin
                        ? "Sign in to continue"
                        : "Register to continue"
                    : "Enter OTP to continue",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
