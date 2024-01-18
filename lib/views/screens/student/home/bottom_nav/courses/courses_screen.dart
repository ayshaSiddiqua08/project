import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/model/profile_model.dart';
import 'package:Taayza/views/components/custom_container.dart';
import 'package:Taayza/views/components/custom_styles.dart';
import 'package:Taayza/views/screens/student/home/bottom_nav/courses/course_details_screen.dart';
import 'package:Taayza/views/screens/student/home/bottom_nav/courses/purchased_courses_screen.dart';
import 'package:Taayza/views/screens/student/home/bottom_nav/courses/teacher_view_profile_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:Taayza/controllers/student_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../components/rating_bar.dart';

class CoursesScreen extends StatelessWidget {
  final StudentController controller;

  const CoursesScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection(DBCollections.coursesCollection)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      final lists = snapshot.data!.docs;
                      return Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          ListTile(
                            title: Text(
                              "Purchased Courses",
                              style: tealStyle(
                                fontSize: 19.sp,
                              ),
                            ),
                            /*trailing: FilledButton(
                              onPressed: () {
                                Get.to(() => PurchasedCoursesScreen(
                                    controller: controller));
                              },
                              child: const Text(
                                'View All',
                              ),
                            ),*/
                          ),
                          ListView.builder(
                            itemCount: lists.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final data = lists[index];
                              int indexOfUSer = controller.usersID.indexWhere(
                                  (element) =>
                                      element == data[DBFields.uidField]);
                              String teacherName = '';
                              String teacherUid = '';
                              if (indexOfUSer != -1) {
                                teacherName =
                                    controller.users[indexOfUSer].name;
                                teacherUid = controller.users[indexOfUSer].uid;
                              }
                              return Obx(() {
                                return Visibility(
                                  visible: controller.purchasedCourses
                                      .contains(data.id),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5.h,
                                      horizontal: 10.w,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => CourseDetailsScreen(
                                            courseId: data.id,
                                            isStreaming:
                                                data[DBFields.isStreaming],
                                            teacherId: data[DBFields.uidField],
                                          ),
                                        );
                                      },
                                      child: CustomContainer(
                                        //     width: 280.w,
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: CachedNetworkImage(
                                                      imageUrl: data[DBFields
                                                          .imageUrlField],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20.w,
                                                ),
                                                Expanded(
                                                  flex: 6,
                                                  child: SizedBox(
                                                    height: 65.h,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        FittedBox(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                data[DBFields
                                                                    .courseNameField],
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    tealStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.sp,
                                                                ),
                                                              ),
                                                              Visibility(
                                                                  visible: data[
                                                                          DBFields
                                                                              .isStreaming] ==
                                                                      true,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        'assets/live.png',
                                                                        color: Colors
                                                                            .red
                                                                            .withOpacity(0.8),
                                                                        width:
                                                                            30.w,
                                                                        height:
                                                                            30.h,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10.w,
                                                                      ),
                                                                      AnimatedTextKit(
                                                                        isRepeatingAnimation:
                                                                            true,
                                                                        animatedTexts: [
                                                                          ColorizeAnimatedText(
                                                                              'Live',
                                                                              textStyle: blackStyle(fontSize: 16.sp),
                                                                              colors: colorizeColors),
                                                                          ColorizeAnimatedText(
                                                                              'Streaming',
                                                                              textStyle: blackStyle(fontSize: 16.sp),
                                                                              colors: colorizeColors),
                                                                          //    ColorizeAnimatedText('Streaming', textStyle:  blackStyle(fontSize: 16.sp), colors: colorizeColors),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          data[DBFields
                                                              .smallDescriptionField],
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: blackStyle(),
                                                        ),
                                                        AutoSizeText(
                                                          "Course By: $teacherName",
                                                          maxLines: 1,
                                                          style: blackStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ],
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
