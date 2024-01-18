import 'package:Taayza/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../global/app_constants.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Widget child;
  final EdgeInsets? buttonPadding;
  final EdgeInsets? childPadding;
  final globalController = Get.find<GlobalController>();

  CustomButton({Key? key, required this.onPressed, this.backgroundColor = secondaryColor, required this.child, this.buttonPadding, this.childPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: buttonPadding ??
          EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 10.w,
          ),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: globalController.isStudent.value ? tealColor : secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Padding(
          padding: childPadding ??
              EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 10.w,
              ),
          child: child,
        ),
      ),
    );
  }
}
