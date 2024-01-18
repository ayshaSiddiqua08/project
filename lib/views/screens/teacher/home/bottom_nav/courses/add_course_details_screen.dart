import 'dart:io';
import 'package:Taayza/controllers/add_courses_controller.dart';
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
import 'package:Taayza/views/screens/student/home/bottom_nav/courses/all_rating_screen.dart';
import 'package:Taayza/views/screens/teacher/home/bottom_nav/courses/add_courses_screen.dart';
import 'package:Taayza/views/screens/teacher/home/bottom_nav/courses/add_resources_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:cached_video_preview/cached_video_preview.dart';

import 'assignment_screen.dart';
import 'calling_page.dart';

class AddCourseDetailsScreen extends StatelessWidget {
  final String? courseId;
  final controller = Get.put(AddCoursesController());


  AddCourseDetailsScreen({Key? key, this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (courseId != null) {
      controller.isEdit = true;
      controller.isImageFromFile.value = false;
      controller.getCourseDetails(courseId!);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          courseId == null ? "Add Course" : "Edit Course",
        ),
        actions: [
          Visibility(
            visible: courseId != null,
            child: TextButton.icon(
              onPressed: () {
                controller.saveCourse(controller, courseId);
              },
              icon: const Icon(
                Icons.save_rounded,
                color: secondaryColor,
              ),
              label: Obx(
                () {
                  return !controller.isCourseSaving.value
                      ? Text(
                          "Save Data",
                          style: secondaryStyle(),
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: secondaryColor,
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _courseDetails(context),
            SizedBox(
              height: 20.h,
            ),
            //_ongoingAssignmentList(courseId),
            SizedBox(
              height: 20.h,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection(DBCollections.coursesCollection)
                  .doc(courseId)
                  .collection(DBCollections.ratingsCollection)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapShot) {
                if (snapShot.hasData) {
                  if (snapShot.data != null) {
                    var ratings = 0.0;
                    var ratingsSnap = snapShot.data!.docs;
                    for (var data in ratingsSnap) {
                      ratings = ratings + (data[DBFields.ratingField] as double);
                    }
                    var averageRating = ratings / ratingsSnap.length;
                    logger.d(averageRating.toStringAsFixed(2));
                    if(ratingsSnap.length >= 3){
                      if(double.parse(averageRating.toStringAsFixed(2))>=4.00){
                        logger.d('Average rating is greater than 4.00');
                        _courseUpdateToRecommend();
                      }else{
                        logger.d('Average rating is not greater than 4.00');

                      }
                    }else{
                      logger.d('Not valid for recommendation');

                    }
                    return Visibility(
                      visible: ratingsSnap.isNotEmpty,
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text(
                              'Ratings And Reviews',
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                Get.to(
                                  () => AllRatingScreen(
                                    courseId: courseId,
                                  ),
                                );
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
                                itemCount: ratingsSnap.length,
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final data = ratingsSnap[index];
                                  return CustomContainer(
                                    width: 250.w,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                    ),
                                    margin: EdgeInsets.only(
                                      bottom: 10.h,
                                      left: 10.w,
                                      right: 10.w,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ListTile(
                                          leading: const CircleAvatar(
                                            child: Icon(
                                              Icons.person,
                                            ),
                                          ),
                                          title: AutoSizeText(
                                            data[DBFields.studentName],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: secondaryStyle(),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.w),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    RatingBarWidget(
                                                      rating: data[
                                                          DBFields.ratingField],
                                                    ),
                                                    Text(
                                                        '(${data[DBFields.ratingField].toString()})'),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  data[DBFields.feedbackField],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.start,
                                                  style: secondaryStyle(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                                      style: secondaryStyle(
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
                                              Get.to(
                                                () => ChewieVideoScreen(
                                                  videoUrl: imageUrl,
                                                  videoName: data[
                                                      DBFields.courseNameField],
                                                ),
                                              );
                                            },
                                            child: CustomContainer(
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
                                      style: secondaryStyle(
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
                                              launchUrl(
                                                Uri.parse(data[
                                                    DBFields.resourceLink]),
                                                mode: LaunchMode
                                                    .externalApplication,
                                              );
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
              height: 100.h,
            ),
          ],
        ),
      ),
      floatingActionButton: courseId != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  heroTag: "ABAC",
                  backgroundColor: secondaryColor,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return openCallDiaglog(context);
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.group_add_outlined,
                    color: whiteColor,
                  ),
                  label: Text(
                    "Group Call",
                    style: whiteStyle(),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                FloatingActionButton.extended(
                  heroTag: "ABAC",
                  backgroundColor: secondaryColor,
                  onPressed: () {
                    Get.to(
                      () => AddCoursesScreen(
                        controller: controller,
                        uid: courseId!,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.video_call_rounded,
                    color: whiteColor,
                  ),
                  label: Text(
                    "Add Videos",
                    style: whiteStyle(),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                FloatingActionButton.extended(
                  heroTag: "ABACas",
                  backgroundColor: secondaryColor,
                  onPressed: () {
                    Get.to(
                      () => AddResourcesScreen(
                        controller: controller,
                        uid: courseId!,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.description_rounded,
                    color: whiteColor,
                  ),
                  label: Text(
                    "Add Resource",
                    style: whiteStyle(),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                FloatingActionButton.extended(
                  backgroundColor: secondaryColor,
                  onPressed: () {
                    Get.to(
                          () => AssignmentScreen(
                        controller: controller,
                        uid: courseId!,
                      ),
                    );
                    logger.d(courseId!);
                  },
                  icon: const Icon(
                    Icons.assignment_add,
                    color: whiteColor,
                  ),
                  label: Text(
                    "Create Assignment",
                    style: whiteStyle(),
                  ),
                ),
              ],
            )
          : const SizedBox(),
    );
  }
  Widget openCallDiaglog(BuildContext context){
    final textController=TextEditingController();
   // controller.getProfileDetails();
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
            if(textController.text.isEmpty){
              errorToast(text: 'Enter Call Id');
            }else{
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return liveUpdate(context,textController.text);
                },
              );

            }

          },
          child: Text(
            "Join Group",
            style: whiteStyle(),
          ),
        ),
      ],
    );
  }

  Widget liveUpdate(BuildContext context,String callId){
    final textController=TextEditingController();
  //  controller.getProfileDetails();
    final userCollection = FirebaseFirestore.instance.collection(DBCollections.userCollection);
    final courseCollection = FirebaseFirestore.instance.collection(DBCollections.coursesCollection);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),

      content: SizedBox(
        height: 100.h,
        width: 300.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text('Live Update',style: blackStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 10.w,),
                  Image.asset('assets/live.png',color: Colors.red.withOpacity(0.8),width: 30.w,height: 30.h,)

                ],
              ),
            ),
            AutoSizeText(
              "When you started a group call,are the students able to receive updates?",style: blackStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w300
            ),
            ),

          ],
        ),
      ),
      actions: <Widget>[
        CustomButton(
          onPressed: () {
            //  controller.pickImage();
            DocumentReference docRefCourse=courseCollection.doc(courseId);
            docRefCourse.update({
              DBFields.isStreaming: true
            }).then((_) {
              logger.d('Document successfully updated');
             // Get.to(() => CallPage(callingId: callId.trim(),));
              DocumentReference docRef=userCollection.doc(controller.user?.uid).collection(DBCollections.coursesCollection).doc(courseId);
              docRef.update({
                DBFields.isStreaming: true
              }).then((_) {
                logger.d('Document successfully updated');

                Get.to(() => CallPage(callingId: callId.trim(),courseId: courseId.toString(),userType: 'teacher',));

              }).catchError((error) {
                print('Error updating document: $error');
              });
            }).catchError((error) {
              print('Error updating document: $error');
            });


          },
          child: Text(
            "Start",
            style: whiteStyle(),
          ),
        ),
        CustomButton(
          onPressed: () {
            //  controller.pickImage();
            //   Get.to(() => CallPage(callingId: textController.text.trim(),));
            Get.back();
          },
          child: Text(
            "Cancel",
            style: whiteStyle(),
          ),
        ),
      ],
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
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            color: secondaryColor.withOpacity(
              0.1,
            ),
            child: Obx(
              () => controller.imagePath.value.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.movie_outlined,
                          color: secondaryColor,
                        ),
                        Text(
                          "No Image Selected",
                          style: secondaryStyle(),
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
        CustomButton(
          onPressed: () {
            controller.pickImage();
          },
          child: Text(
            "Select Image",
            style: whiteStyle(),
          ),
        ),
        ListTile(
          title: Text(
            "Is Active?",
            style: secondaryStyle(),
          ),
          trailing: Obx(
            () {
              return Switch(
                activeColor: secondaryColor,
                onChanged: (value) {
                  controller.isActive.value = value;
                },
                value: controller.isActive.value,
              );
            },
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
            children: [
              CustomTextField(
                hintText: "Pick Expiry Date",
                helperText: "Keep it blank to make it available unlimited time",
                controller: controller.expiryDateController,
                textInputType: TextInputType.none,
                suffixIcon: IconButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100));
                    controller.pickedDate.value = pickedDate;
                    if (pickedDate != null) {
                      logger.d(pickedDate);
                      String formattedDate =
                          DateFormat('dd MMM, yyyy').format(pickedDate);
                      controller.expiryDateController.text = formattedDate;
                    } else {
                      controller.expiryDateController.clear();
                      controller.pickedDate.value = null;
                    }
                  },
                  icon: const Icon(
                    Icons.date_range_rounded,
                    color: secondaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomTextField(
                hintText: "Enter Course Name",
                helperText: "Course Name",
                controller: controller.courseNameController,
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomTextField(
                hintText: "Enter Price",
                helperText: "Price",
                controller: controller.priceController,
                textInputType: TextInputType.number,
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomTextField(
                hintText: "Enter Discount Price",
                helperText: "Discount Price",
                controller: controller.discountPriceController,
                textInputType: TextInputType.number,
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomTextField(
                hintText: "Enter Small Description",
                helperText: "Small Description",
                controller: controller.smallDescriptionController,
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomTextField(
                hintText: "Enter Large Description",
                helperText: "Large Description",
                controller: controller.largeDescriptionController,
                isMultilineEnabled: true,
              ),
              SizedBox(
                height: 20.h,
              ),
              Visibility(
                visible: courseId == null,
                child: CustomButton(
                  onPressed: () {
                    controller.saveCourse(controller, courseId);
                  },
                  child: Obx(
                    () {
                      return !controller.isCourseSaving.value
                          ? Text(
                              "Save Data",
                              style: whiteStyle(),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: whiteColor,
                              ),
                            );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _courseUpdateToRecommend() {
    final courseCollection = FirebaseFirestore.instance.collection(DBCollections.coursesCollection);
    DocumentReference docRefCourse=courseCollection.doc(courseId);
      docRefCourse.update({
        DBFields.isRecommend: true
      }).then((_) {
        logger.d('Document successfully updated');
      }).catchError((error) {
        logger.e('Error updating document: $error');
      });
  }

 Widget _ongoingAssignmentList(String? courseId) {
   return  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(DBCollections.userCollection)
          .doc(controller.user?.uid)
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
           /* for (var data in ratingsSnap) {
              ratings = ratings + (data[DBFields.ratingField] as double);
            }
            var averageRating = ratings / ratingsSnap.length;
            logger.d(averageRating.toStringAsFixed(2));
            if(ratingsSnap.length >= 3){
              if(double.parse(averageRating.toStringAsFixed(2))>=4.00){
                logger.d('Average rating is greater than 4.00');
                _courseUpdateToRecommend();
              }else{
                logger.d('Average rating is not greater than 4.00');

              }
            }else{
              logger.d('Not valid for recommendation');

            }*/
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
                          final data = assignmentsSnap[index];
                          return CustomContainer(
                            width: 250.w,
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,horizontal: 10.w
                            ),
                            margin: EdgeInsets.only(
                              left: 10.w,
                              right: 10.w,
                            ),
                            child: ListView(
                            //  crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
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
                                          fontSize: 14.sp,fontWeight: FontWeight.w500
                                      ),
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
                                    fontSize: 16.sp,fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  data[DBFields.assignmentDescription],
                                  maxLines: 3,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: commonStyle(
                                      color: secondaryColor.withOpacity(0.7),
                                      fontSize: 14.sp,fontWeight: FontWeight.w300
                                  ),
                                ),
                              ],
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
