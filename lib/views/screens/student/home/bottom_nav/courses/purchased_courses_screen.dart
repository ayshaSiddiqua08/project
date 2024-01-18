import 'package:Taayza/controllers/student_controller.dart';
import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/views/components/custom_container.dart';
import 'package:Taayza/views/components/custom_styles.dart';
import 'package:Taayza/views/components/rating_bar.dart';
import 'package:Taayza/views/screens/student/home/bottom_nav/courses/course_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PurchasedCoursesScreen extends StatelessWidget {
  final StudentController controller;

  const PurchasedCoursesScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Purchased Courses'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(DBCollections.coursesCollection)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              final lists = snapshot.data!.docs;
              return ListView.builder(
                itemCount: lists.length,
                /*physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,*/
                itemBuilder: (context, index) {
                  final data = lists[index];
                  int indexOfUSer = controller.usersID.indexWhere(
                      (element) => element == data[DBFields.uidField]);
                  String teacherName = '';
                  if (indexOfUSer != -1) {
                    teacherName = controller.users[indexOfUSer].name;
                  }
                  return Obx(
                    () {
                      return Visibility(
                        visible: controller.purchasedCourses.contains(data.id),
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
                                ),
                              );
                            },
                            child: CustomContainer(
                              width: 280.w,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                data[DBFields.imageUrlField],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data[DBFields.courseNameField],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: tealStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            Text(
                                              data[DBFields
                                                  .smallDescriptionField],
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: blackStyle(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "Course By: $teacherName",
                                          style: blackStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: StreamBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                          stream: FirebaseFirestore.instance
                                              .collection(DBCollections
                                                  .coursesCollection)
                                              .doc(data.id)
                                              .collection(DBCollections
                                                  .ratingsCollection)
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<
                                                      QuerySnapshot<
                                                          Map<String, dynamic>>>
                                                  snapShot) {
                                            if (snapShot.hasData) {
                                              if (snapShot.data != null) {
                                                var ratings = 0.0;
                                                var ratingsSnap =
                                                    snapShot.data!.docs;
                                                for (var data in ratingsSnap) {
                                                  ratings = ratings +
                                                      (data[DBFields
                                                              .ratingField]
                                                          as double);
                                                }
                                                var averageRating = ratings /
                                                    ratingsSnap.length;
                                                logger.d(averageRating);
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child:
                                                          ratingsSnap.isNotEmpty
                                                              ? RatingBarWidget(
                                                                  rating:
                                                                      averageRating,
                                                                )
                                                              : const Text(
                                                                  'No Ratings Yet',
                                                                ),
                                                    ),
                                                  ],
                                                );
                                              }
                                            }
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
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
                    },
                  );
                },
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
