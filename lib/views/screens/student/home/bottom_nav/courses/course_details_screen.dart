import 'dart:io';
import 'package:Taayza/controllers/add_courses_controller.dart';
import 'package:Taayza/controllers/list_courses_controller.dart';
import 'package:Taayza/controllers/student_controller.dart';
import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/views/components/custom_button.dart';
import 'package:Taayza/views/components/custom_container.dart';
import 'package:Taayza/views/components/custom_styles.dart';
import 'package:Taayza/views/components/custom_text_field.dart';
import 'package:Taayza/views/components/rating_bar.dart';
import 'package:Taayza/views/screens/chewie_video_screen.dart';
import 'package:Taayza/views/screens/demo/payment_demo.dart';
import 'package:Taayza/views/screens/student/home/bottom_nav/courses/all_rating_screen.dart';
import 'package:Taayza/views/screens/student/home/bottom_nav/courses/submit_assignment_screen.dart';
import 'package:Taayza/views/screens/teacher/home/bottom_nav/courses/add_courses_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_preview/cached_video_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../teacher/home/bottom_nav/courses/calling_page.dart';

class CourseDetailsScreen extends StatelessWidget {
  final String? courseId;
  final String? teacherId;
  final bool? isStreaming;
  final controller = Get.put(ListCoursesController());
  final _controller = Get.put(StudentController());

  CourseDetailsScreen(
      {Key? key, this.courseId, this.isStreaming, this.teacherId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (courseId != null) {
      controller.isEdit = true;
      controller.isImageFromFile.value = false;
      controller.getCourseDetails(courseId!);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Course Details",
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!controller.isAlreadyEnrolled.value) {
                errorToast(text: 'Enroll before rate');
                return;
              }
              controller.showRatingDialog(context, courseId);
            },
            child: Text(
              'Rate This Course',
              style: tealStyle(),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _courseDetails(context),
            SizedBox(
              height: 20.h,
            ),
            courseId != null
                ? _buildAssignment(teacherId, courseId)
                : const SizedBox(),
            SizedBox(
              height: 20.h,
            ),
            courseId != null
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(DBCollections.coursesCollection)
                        .doc(courseId)
                        .collection(DBCollections.videosCollection)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          final lists = snapshot.data!.docs;
                          return lists.isEmpty
                              ? const Text(
                                  "No Videos are added",
                                )
                              : Column(
                                  children: [
                                    Text(
                                      "Videos",
                                      style: tealStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: lists.length,
                                      itemBuilder: (context, index) {
                                        final data = lists[index];
                                        final imageUrl =
                                            data[DBFields.videoUrlField];

                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5.h,
                                            horizontal: 10.w,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              if (!controller.isExpired.value) {
                                                if (controller
                                                    .isAlreadyEnrolled.value) {
                                                  if (controller
                                                      .isActive.value) {
                                                    Get.to(
                                                      () => ChewieVideoScreen(
                                                        videoUrl: imageUrl,
                                                        videoName: data[DBFields
                                                            .courseNameField],
                                                      ),
                                                    );
                                                  } else {
                                                    errorToast(
                                                        text:
                                                            'This course is not currently active');
                                                  }
                                                } else {
                                                  infoToast(
                                                      text:
                                                          "Please Enroll Before Watch Video");
                                                }
                                              } else {
                                                errorToast(
                                                    text: 'Course is expired');
                                              }
                                            },
                                            child: CustomContainer(
                                              padding: EdgeInsets.zero,
                                              child: ListTile(
                                                leading: SizedBox(
                                                  height: 100.h,
                                                  width: 50.w,
                                                  child:
                                                      CachedVideoPreviewWidget(
                                                    path: imageUrl,
                                                    type: SourceType.remote,
                                                    remoteImageBuilder:
                                                        (BuildContext context,
                                                                url) =>
                                                            CachedNetworkImage(
                                                      imageUrl: url,
                                                    ),
                                                  ),
                                                ),
                                                title: Text(data[
                                                    DBFields.courseNameField]),
                                                trailing: Text(data[
                                                    DBFields.durationField]),
                                                subtitle: Text(data[
                                                    DBFields.descriptionField]),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                        }
                      }
                      return const CircularProgressIndicator();
                    },
                  )
                : const SizedBox(),
            SizedBox(
              height: 20.h,
            ),
            courseId != null
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(DBCollections.coursesCollection)
                        .doc(courseId)
                        .collection(DBCollections.resourcesCollection)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          final lists = snapshot.data!.docs;
                          return lists.isEmpty
                              ? const Text(
                                  "No resources available",
                                )
                              : Column(
                                  children: [
                                    Text(
                                      "Resources",
                                      style: tealStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: lists.length,
                                      itemBuilder: (context, index) {
                                        final data = lists[index];
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5.h,
                                            horizontal: 10.w,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              if (!controller.isExpired.value) {
                                                launchUrl(
                                                  Uri.parse(data[
                                                      DBFields.resourceLink]),
                                                  mode: LaunchMode
                                                      .externalApplication,
                                                );
                                              } else {
                                                errorToast(
                                                    text: 'Course is expired');
                                              }
                                            },
                                            child: CustomContainer(
                                              padding: EdgeInsets.zero,
                                              child: ListTile(
                                                leading: const Icon(
                                                  Icons.description_rounded,
                                                  color: secondaryColor,
                                                ),
                                                title: Text(data[
                                                    DBFields.resourceName]),
                                                subtitle: Text(data[
                                                    DBFields.resourceLink]),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                        }
                      }
                      return const CircularProgressIndicator();
                    },
                  )
                : const SizedBox(),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        return Visibility(
          visible: !controller.isAlreadyEnrolled.value,
          child: FloatingActionButton.extended(
            backgroundColor: tealColor,
            onPressed: () {
              if (!controller.isExpired.value) {
                if ((controller.discountPrice.value == '0') |
                    (controller.price.value == '0')) {
                  /*This item is free*/
                  controller.saveCourseForStudent(
                      courseId: courseId!, teacherId: controller.teacherUID);
                  controller.getCourseDetails(courseId!);
                } else {
                  Get.to(
                    () => PaymentScreen(
                      courseId: courseId,
                    ),
                  );
                }
              } else {
                errorToast(text: 'Course is expired');
              }
              //controller.discountPrice.value
              /*controller.saveCourseForStudent(courseId: courseId!, teacherId: controller.teacherUID);
              controller.getCourseDetails(courseId!);*/
            },
            icon: !controller.isEnrolling.value
                ? const Icon(
                    Icons.video_call_rounded,
                    color: whiteColor,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            label: Text(
              "Enroll Course",
              style: whiteStyle(),
            ),
          ),
        );
      }),
    );
  }

  Future<Widget> generateThumbnail(String videoUrl) async {
    final uint8list = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );

    return Image.file(File(uint8list!));
  }

  Column _courseDetails(BuildContext context) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: tealColor.withOpacity(
              0.1,
            ),
            child: Obx(
              () => controller.imagePath.value.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.movie_outlined,
                          color: tealColor,
                        ),
                        Text(
                          "No Image Selected",
                          style: tealStyle(),
                        ),
                      ],
                    )
                  : controller.isImageFromFile.value
                      ? Image.file(
                          File(controller.imagePath.value),
                        )
                      : CachedNetworkImage(
                          imageUrl: controller.imagePath.value,
                        ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return Text(
                      controller.courseName.value,
                      style: tealStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.sp,
                      ),
                    );
                  }),
                  Visibility(
                      visible: isStreaming == true,
                      child: GestureDetector(
                        onTap: () {
                          logger.d('tap');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return openCallDialog(context);
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: secondaryColor),
                              borderRadius: BorderRadius.circular(10.r)),
                          child: FittedBox(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Row(
                                //
                                //  mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    'assets/live.png',
                                    color: Colors.red.withOpacity(0.8),
                                    width: 30.w,
                                    height: 30.h,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  AnimatedTextKit(
                                    isRepeatingAnimation: true,
                                    animatedTexts: [
                                      ColorizeAnimatedText('Join Streaming',
                                          textStyle:
                                              blackStyle(fontSize: 16.sp),
                                          colors: colorizeColors),
                                      //    ColorizeAnimatedText('Streaming', textStyle:  blackStyle(fontSize: 16.sp), colors: colorizeColors),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Obx(() {
                          return Text(
                            "Price: ${controller.discountPrice.value.isEmpty ? controller.price.value : controller.discountPrice.value}$taka",
                            style: tealStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                        SizedBox(
                          width: 10.w,
                        ),
                        Obx(() {
                          return Visibility(
                            visible: controller.discountPrice.value != "",
                            child: Text(
                              controller.price.value + taka,
                              style: tealStyle(
                                textDecoration: TextDecoration.lineThrough,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Get.to(
                          () => AllRatingScreen(
                            courseId: courseId,
                          ),
                        );
                      },
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection(DBCollections.coursesCollection)
                            .doc(courseId)
                            .collection(DBCollections.ratingsCollection)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapShot) {
                          if (snapShot.hasData) {
                            if (snapShot.data != null) {
                              var ratings = 0.0;
                              var ratingsSnap = snapShot.data!.docs;
                              for (var data in ratingsSnap) {
                                ratings = ratings +
                                    (data[DBFields.ratingField] as double);
                              }
                              var averageRating = ratings / ratingsSnap.length;
                              logger.d(averageRating);
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Rating',
                                    textAlign: TextAlign.end,
                                    style: tealStyle(),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ratingsSnap.isNotEmpty
                                        ? RatingBarWidget(
                                            rating: averageRating,
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
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(() {
                return Visibility(
                  visible: controller.expiryDate.value != 0,
                  child: CustomContainer(
                    child: Align(
                      child: !controller.isExpired.value
                          ? Column(
                              children: [
                                Text(
                                  'This course expires in',
                                  style: secondaryStyle(),
                                ),
                                Countdown(
                                  seconds: controller.getDifferenceInDays(
                                      controller.expiryDate.value),
                                  build: (BuildContext context, double time) =>
                                      Text(
                                    controller.convertSecondsToDHMS(time),
                                    textAlign: TextAlign.center,
                                    style: secondaryStyle(),
                                  ),
                                  onFinished: () {
                                    controller.isExpired.value = true;
                                  },
                                  interval: const Duration(milliseconds: 100),
                                ),
                              ],
                            )
                          : Text(
                              'Course is expired',
                              style: redStyle(),
                            ),
                    ),
                  ),
                );
              }),
              SizedBox(
                height: 10.h,
              ),
              Obx(() {
                return Text(
                  controller.smallDescription.value,
                  style: tealStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
              SizedBox(
                height: 10.h,
              ),
              Obx(() {
                return Text(
                  controller.largeDescription.value,
                  style: tealStyle(),
                );
              }),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget openCallDialog(BuildContext context) {
    final textController = TextEditingController();
    final userCollection =
        FirebaseFirestore.instance.collection(DBCollections.userCollection);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text('Enter Text'),
      content: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: tealColor, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: 'Type group call id...',
        ),
      ),
      actions: <Widget>[
        CustomButton(
          onPressed: () {
            //  controller.pickImage();
            /* var ref=  FirebaseFirestore.instance
                .collection(DBCollections.userCollection)
                .doc(teacherId)
                .collection(DBCollections.coursesCollection)
                .doc(courseId)
                .collection(DBCollections.studentsCollection)*/
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('yyyy-MM-dd')
                .format(now); // Format the date as needed
            String formattedTime = DateFormat('HH:mm:ss').format(now);
            Map<String, dynamic> attendanceData = {
              'time': formattedTime,
              'date': formattedDate,
              'courseId': courseId,
              'studentId': _controller.profile.value!.uid,
              'studentName': _controller.profile.value!.name,
              // Replace courseId with the actual course ID
            };
            DocumentReference docRef = userCollection
                .doc(teacherId)
                .collection(DBCollections.coursesCollection)
                .doc(courseId)
                .collection(DBCollections.attendanceCollection)
                .doc();

            docRef.set(attendanceData).then((_) {
              logger.d('Attendance data added successfully.');
              Get.to(() => CallPage(
                    callingId: textController.text.trim(),
                    courseId: courseId.toString(),
                    userType: 'student',
                  ));
            }).catchError((error) {
              logger.d('Error adding attendance data: $error');
            });

            //    Zego
          },
          child: Text(
            "Join Group",
            style: whiteStyle(),
          ),
        ),
      ],
    );
  }

  Widget _buildAssignment(String? teacherId, String? courseId) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(DBCollections.userCollection)
          .doc(teacherId)
          .collection(DBCollections.coursesCollection)
          .doc(courseId)
          .collection(DBCollections.assignmentCollection)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapShot) {
        if (snapShot.hasData) {
          if (snapShot.data != null) {
            var ratings = 0.0;
            var assignmentsSnap = snapShot.data!.docs;
            return Visibility(
              visible: assignmentsSnap.isNotEmpty,
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Ongoing Assignment',
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        /*Get.to(
                              () => AllRatingScreen(
                            courseId: courseId,
                          ),
                        );*/
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120.h,
                    width: double.infinity,
                    child: ListView.builder(
                        itemCount: assignmentsSnap.length,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = assignmentsSnap[index].data();
                          final dateFormat = DateFormat('d MMM, yyyy');

                          final dueDate = data[DBFields.assignmentDueDate];
                          final dueDateString  = dateFormat.parse(dueDate);

                          // Check if the assignment is due or overdue
                          final isAssignmentDue = DateTime.now().isBefore(dueDateString);
                          return InkWell(
                            onTap: () {
                              if (isAssignmentDue) {
                                Get.to(() => SubmitAssignment(
                                      data: data,
                                      courseId: courseId.toString(),
                                      teacherId: teacherId.toString(),
                                    ));
                              }else{
                                successToast(text: "This assignment date is expired");
                              }
                            },
                            child: CustomContainer(
                              width: 250.w,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 10.w),
                              margin: EdgeInsets.only(
                                left: 10.w,
                                right: 10.w,
                              ),
                              child: ListView(
                                //  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const CircleAvatar(
                                        child: Icon(
                                          Icons.assignment_sharp,
                                        ),
                                      ),
                                      AutoSizeText(
                                        "Due Date: ${data[DBFields.assignmentDueDate]}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: commonStyle(
                                            color: redColor.withOpacity(0.7),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  AutoSizeText(
                                    "${data[DBFields.assignmentTitle]}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: commonStyle(
                                        color: secondaryColor.withOpacity(0.7),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    data[DBFields.assignmentDescription],
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: commonStyle(
                                        color: secondaryColor.withOpacity(0.7),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
