import 'package:Taayza/controllers/teacher_controller.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../db_paths/db_collections.dart';
import '../../../../../db_paths/db_fields.dart';
import '../../../../../global/app_constants.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_styles.dart';
import '../../../../components/quote_card.dart';
import 'courses/add_course_details_screen.dart';
import 'courses/calling_page.dart';


class HomeScreen extends StatelessWidget {
  final TeacherController controller;

  HomeScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
        child: Column(

          children: [
            QuoteCard(
              quote: "Teaching kids to count is fine, but teaching them what counts is best.",
              author: "- Bob Talbert",
            ),
            QuoteCard(
              quote: "Teachers have three loves: love of learning, love of learners, and the love of bringing the first two loves together.",
              author: "- Scott Hayden",
            ),
            QuoteCard(
              quote: "Teachers can change lives with just the right mix of chalk and challenges.",
              author: "- Joyce Meyer",
            ),
          ],
        ),
      ),
    );
  }



}
