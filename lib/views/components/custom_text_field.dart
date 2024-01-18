import 'package:Taayza/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../global/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final globalController = Get.find<GlobalController>();
  final TextEditingController? controller;
  final String hintText;
  final String? helperText;
  final String? labelText;
  final bool obscure;
  final TextInputType textInputType;
  final Widget? suffixIcon;
  final Color? borderColor;
  final int? designNumber;
  final bool? isEnabled;
  final bool? isMultilineEnabled;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final Color? textColor;

  CustomTextField({
    Key? key,
    this.controller,
    required this.hintText,
    this.helperText,
    this.obscure = false,
    this.textInputType = TextInputType.text,
    this.suffixIcon,
    this.borderColor,
    this.designNumber,
    this.onChanged,
    this.isEnabled,
    this.labelText,
    this.focusNode,
    this.isMultilineEnabled,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isMultilineEnabled == null
        ? TextField(
            focusNode: focusNode,
            onChanged: onChanged,
            controller: controller,
            obscureText: obscure,
            enabled: isEnabled,
            keyboardType: textInputType,
            style: TextStyle(
              color: textColor ??
                  (globalController.isStudent.value
                      ? tealColor
                      : secondaryColor),
            ),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintStyle: TextStyle(
                color: globalController.isStudent.value
                    ? tealColor.withOpacity(0.5)
                    : secondaryColor.withOpacity(
                        0.5,
                      ),
              ),
              labelStyle: TextStyle(
                color: globalController.isStudent.value
                    ? tealColor
                    : secondaryColor,
              ),
              helperStyle: TextStyle(
                color: globalController.isStudent.value
                    ? tealColor
                    : secondaryColor,
              ),
              hintText: hintText,
              helperText: helperText,
              labelText: labelText,
              suffixIcon: suffixIcon,
              border: _outlineDesignOne(),
              enabledBorder: _outlineDesignOne(),
              focusedBorder: _outlineDesignOne(),
              disabledBorder: _outlineDesignOne(),
            ),
          )
        : TextField(
            focusNode: focusNode,
            onChanged: onChanged,
            controller: controller,
            obscureText: obscure,
            enabled: isEnabled,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(
              color:
                  globalController.isStudent.value ? tealColor : secondaryColor,
            ),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintStyle: TextStyle(
                color: globalController.isStudent.value
                    ? tealColor.withOpacity(0.5)
                    : secondaryColor.withOpacity(
                        0.5,
                      ),
              ),
              labelStyle: TextStyle(
                color: globalController.isStudent.value
                    ? tealColor
                    : secondaryColor,
              ),
              helperStyle: TextStyle(
                color: globalController.isStudent.value
                    ? tealColor
                    : secondaryColor,
              ),
              hintText: hintText,
              helperText: helperText,
              labelText: labelText,
              suffixIcon: suffixIcon,
              border: _outlineDesignOne(),
              enabledBorder: _outlineDesignOne(),
              focusedBorder: _outlineDesignOne(),
              disabledBorder: _outlineDesignOne(),
            ),
          );
  }

  OutlineInputBorder _outlineDesignOne() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(
          10.r,
        ),
      ),
      borderSide: BorderSide(
        color: globalController.isStudent.value ? tealColor : secondaryColor,
      ),
    );
  }
}
