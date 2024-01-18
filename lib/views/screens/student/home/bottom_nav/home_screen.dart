import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/views/components/custom_container.dart';
import 'package:Taayza/views/components/custom_styles.dart';
import 'package:Taayza/views/components/rating_bar.dart';
import 'package:Taayza/views/screens/student/home/bottom_nav/courses/purchased_courses_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:Taayza/controllers/student_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../global/helpers.dart';
import '../../../../../model/profile_model.dart';
import 'courses/course_details_screen.dart';
import 'courses/recommend_courses_screen.dart';
import 'courses/teacher_view_profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final StudentController controller;

  const HomeScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    controller.getPurchasedCourses();
    controller.getProfileDetails();
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection(DBCollections.coursesCollection)
                .where(DBFields.isRecommend, isEqualTo: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null && snapshot.data!.docs.isNotEmpty ) {
                  final lists = snapshot.data!.docs;
                  return Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      ListTile(
                        title: Text(
                          "Recommend Courses 💡",
                          style: tealStyle(
                            fontSize: 19.sp,
                          ),
                        ),
                        trailing: FilledButton(
                          onPressed: () {
                            Get.to(() => RecommendCoursesScreen(controller: controller));
                          },
                          child: const Text(
                            'View All',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        height: 110.h,
                        child: ListView.builder(
                          itemCount: lists.length,
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final data = lists[index];
                            int indexOfUSer = controller.usersID.indexWhere(
                                    (element) =>
                                element == data[DBFields.uidField]);
                            String teacherName = '';
                            if (indexOfUSer != -1) {
                              teacherName = controller.users[indexOfUSer].name;
                            }
                            return Padding(
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
                                      SizedBox(
                                        height: 65.h,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                  imageUrl: data[
                                                  DBFields.imageUrlField],
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
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data[DBFields
                                                          .courseNameField],
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: tealStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 16.sp,
                                                      ),
                                                    ),
                                                    Text(
                                                      data[DBFields
                                                          .smallDescriptionField],
                                                      maxLines: 3,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: blackStyle(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: AutoSizeText(
                                              "Course By: $teacherName",
                                              maxLines: 1,
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
                                              stream: FirebaseFirestore
                                                  .instance
                                                  .collection(DBCollections
                                                  .coursesCollection)
                                                  .doc(data.id)
                                                  .collection(DBCollections
                                                  .ratingsCollection)
                                                  .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot<
                                                      QuerySnapshot<
                                                          Map<String,
                                                              dynamic>>>
                                                  snapShot) {
                                                if (snapShot.hasData) {
                                                  if (snapShot.data !=
                                                      null) {
                                                    var ratings = 0.0;
                                                    var ratingsSnap =
                                                        snapShot.data!.docs;
                                                    for (var data
                                                    in ratingsSnap) {
                                                      ratings = ratings +
                                                          (data[DBFields
                                                              .ratingField]
                                                          as double);
                                                    }
                                                    var averageRating =
                                                        ratings /
                                                            ratingsSnap
                                                                .length;
                                                    //logger.d(averageRating);
                                                    return Column(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: ratingsSnap
                                                              .isNotEmpty
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
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }else{
                  return Container();

                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),


          SizedBox(
            height: 30.h,
          ),
          Text(
            "All Courses",
            style: tealStyle(
              fontSize: 19.sp,
            ),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection(DBCollections.coursesCollection)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  final lists = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: lists.length,
                    itemBuilder: (context, index) {
                      final data = lists[index];
                      int indexOfUSer = controller.usersID.indexWhere(
                              (element) => element == data[DBFields.uidField]);
                      String teacherName = '';
                      String teacherUid = '';
                      if (indexOfUSer != -1) {
                        teacherName = controller.users[indexOfUSer].name;
                        teacherUid = controller.users[indexOfUSer].uid;

                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 5.w,
                        ),
                        child: InkWell(
                          onTap: () {
                            logger.d(data[DBFields.uidField]);
                            logger.d(data.id);
                            Get.to(
                                  () => CourseDetailsScreen(
                                courseId: data.id,
                                isStreaming:data[DBFields.isStreaming],
                                teacherId: data[DBFields.uidField],
                              ),
                            );
                          },
                          child: CustomContainer(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 10.w,
                            ),
                            child: Stack(
                              //      crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                    visible: data[DBFields.isStreaming] == true,
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset('assets/live.png',color: Colors.red.withOpacity(0.8),width: 30.w,height: 30.h,),
                                        SizedBox(width: 10.w,),
                                        AnimatedTextKit(
                                          isRepeatingAnimation: true,
                                          animatedTexts: [
                                            ColorizeAnimatedText('Live', textStyle:  blackStyle(fontSize: 16.sp), colors: colorizeColors),
                                            ColorizeAnimatedText('Streaming', textStyle:  blackStyle(fontSize: 16.sp), colors: colorizeColors),
                                            //    ColorizeAnimatedText('Streaming', textStyle:  blackStyle(fontSize: 16.sp), colors: colorizeColors),
                                          ],
                                        ),

                                      ],
                                    )
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 100.0,
                                            width: 50.0,
                                            child: CachedNetworkImage(
                                              imageUrl: data[DBFields.imageUrlField],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data[DBFields.courseNameField],
                                                    style: blackStyle(),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          'Price: ${data[DBFields.coursePriceField] + taka}',
                                                          maxLines: 1,
                                                          style: blackStyle(),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0, // Adjust the width as needed
                                                      ),
                                                      Expanded(
                                                        child: AutoSizeText(
                                                          'Discount: ${data[DBFields.courseDiscountPriceField] + taka}',
                                                          maxLines: 1,
                                                          style: blackStyle(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10.h,)
                                  ],
                                ),

                                Positioned(
                                  bottom: 0,
                                  child: Text(
                                    "Course By: $teacherName",
                                    style: blackStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
          SizedBox(
            height: 30.h,
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection(DBCollections.userCollection)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  final lists = snapshot.data!.docs;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Available Teachers",
                        style: tealStyle(
                          fontSize: 19.sp,
                        ),
                      ),
                      SizedBox(
                        height: 70.h,
                        child: ListView.builder(
                          itemCount: lists.length,
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final data = lists[index];
                            controller.users.add(
                              ProfileModel(
                                name: data[DBFields.nameField].toString(),
                                number: data[DBFields.numberField].toString(),
                                uid: data[DBFields.uidField].toString(),
                                type: data[DBFields.typeField]
                                    .toString()
                                    .capitalizeFirst!,
                                joiningDate: data[DBFields.joiningDateField],
                              ),
                            );
                            controller.usersID.add(data.id);
                            return Visibility(
                              visible: data[DBFields.typeField] == 'teacher',
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5.h,
                                  horizontal: 10.w,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    //Go to teacher profile
                                    Get.to(
                                          () => TeacherViewProfileScreen(
                                        uid: data.id,
                                        controller: controller,

                                      ),
                                    );
                                  },
                                  child: CustomContainer(
                                    width: 200.w,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        Expanded(
                                          flex:2,
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: CircleAvatar(
                                              radius: 30.r,
                                              child: const Icon(
                                                Icons.person,
                                              ),
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
                                              AutoSizeText(
                                                data[DBFields.nameField],
                                                maxLines: 1,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: tealStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                              Text(
                                                data[DBFields.numberField],
                                                maxLines: 3,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: blackStyle(),
                                              ),
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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
          /*Text(
            "Attended Quiz",
            style: tealStyle(
              fontSize: 19.sp,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text("Coming Soon")*/
        ],
      ),
    );
  }
}
