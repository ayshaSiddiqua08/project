import 'package:flutter/material.dart';

import '../../global/app_constants.dart';

TextStyle whiteStyle({
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return TextStyle(
    color: whiteColor,
    fontWeight: fontWeight,
    fontSize: fontSize,
  );
}

TextStyle secondaryStyle({
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return TextStyle(
    color: secondaryColor,
    fontWeight: fontWeight,
    fontSize: fontSize,
  );
}
TextStyle tealStyle({
  double? fontSize,
  FontWeight? fontWeight,
  TextDecoration? textDecoration,
}) {
  return TextStyle(
    color: tealColor,
    fontWeight: fontWeight,
    fontSize: fontSize,
    decoration: textDecoration,
  );
}

TextStyle primaryStyle({
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return TextStyle(
    color: primaryColor,
    fontWeight: fontWeight,
    fontSize: fontSize,
  );
}

TextStyle blackStyle({
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return TextStyle(
    color: blackColor,
    fontWeight: fontWeight,
    fontSize: fontSize,
  );
}
TextStyle redStyle({
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return TextStyle(
    color: redColor,
    fontWeight: fontWeight,
    fontSize: fontSize,
  );
}
TextStyle commonStyle({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  FontStyle? fontStyle,
}) {
  return TextStyle(
    color: color,
    fontWeight: fontWeight,
    fontSize: fontSize,
    fontStyle: fontStyle
  );
}