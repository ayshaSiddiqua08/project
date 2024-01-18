import 'package:Taayza/controllers/global_controller.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomContainer extends StatelessWidget {
  final globalController = Get.find<GlobalController>();
  final double? width;
  final double? height;
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  CustomContainer({Key? key, required this.child, this.width, this.padding, this.margin, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10.r,
        ),
        //color: secondaryColor,
        border: Border.all(
          color: globalController.isStudent.value?tealColor: secondaryColor,
        ),
      ),
      width: width??double.infinity,
      padding: padding?? EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 4.h,
      ),
      margin: margin,
      child: child,
    );
  }
}
