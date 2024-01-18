import 'dart:math';

import 'package:Taayza/controllers/auth_controller.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import '../../../global/helpers.dart';
import '../../components/custom_button.dart';
import 'components/top_decoration.dart';

class OtpScreen extends StatelessWidget {
  final Auths auth;
  final AuthController controller;

  const OtpScreen({Key? key, required this.controller, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeeeeee),
      body: Column(
        children: [
          const TopDecoration(
            isLogin: true,
            isOtp: true,
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  child: OTPTextField(
                    controller: controller.otpController,
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: 50.w,
                    style: const TextStyle(
                      fontSize: 17,
                      color: tealColor,
                    ),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.box,
                    otpFieldStyle: OtpFieldStyle(
                      borderColor: tealColor,
                      focusBorderColor: tealColor,
                      disabledBorderColor: tealColor,
                      enabledBorderColor: tealColor,
                    ),
                    onCompleted: (pin) {
                      controller.isOTPProcessing.value = true;
                      controller.verifyOTPCode(pin, auth);
                      logger.d(pin);
                    },
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: () {
                      controller.isOTPProcessing.value = true;
                    },
                    child: Obx(
                      () => controller.isOTPProcessing.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: whiteColor,
                              ),
                            )
                          : Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
