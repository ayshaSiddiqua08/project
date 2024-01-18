import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'global_controller.dart';

class ListCoursesController extends GetxController {
  var videoPlayerController = Rx<VideoPlayerController?>(null);
  var chewieController = Rx<ChewieController?>(null);
  var filePath = "".obs;
  var imagePath = "".obs;
  var isImageFromFile = true.obs;
  var isEdit = false;
  final ImagePicker picker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser;
  final globalController = Get.find<GlobalController>();

  /*Add Course Details*/
  final courseName = "".obs;
  final price = "".obs;
  final discountPrice = "".obs;
  final smallDescription = "".obs;
  final largeDescription = "".obs;
  var teacherUID = "";
  var isActive = true.obs;
  var isLoading = false.obs;
  var isEnrolling = false.obs;
  var isAlreadyEnrolled = false.obs;
  var expiryDate = 0.obs;
  var isExpired = false.obs;

  getCourseDetails(String courseId) async {
    DateTime date = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 2,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second);
    logger.d(date.millisecondsSinceEpoch);
    isLoading.value = true;
    isImageFromFile.value = false;
    await FirebaseFirestore.instance
        .collection(DBCollections.coursesCollection)
        .doc(courseId)
        .get()
        .then((doc) {
      courseName.value = doc[DBFields.courseNameField];
      largeDescription.value = doc[DBFields.largeDescriptionField];
      smallDescription.value = doc[DBFields.smallDescriptionField];
      price.value = doc[DBFields.coursePriceField];
      discountPrice.value = doc[DBFields.discountPriceField];
      imagePath.value = doc[DBFields.imageUrlField];
      isActive.value = doc[DBFields.isActiveField];
      teacherUID = doc[DBFields.uidField];
      expiryDate.value = doc[DBFields.expiryDate];
    });
    int difference = getDifferenceInDays(expiryDate.value);
    isExpired.value = (expiryDate.value != 0) & (difference <= 0);
    logger.d(
        'Time ${expiryDate.value} and value ${isExpired.value} and difference $difference');
    isImageFromFile.value = false;
    isLoading.value = false;
    final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection(DBCollections.userCollection)
        .doc(user?.uid)
        .collection(DBCollections.coursesCollection)
        .limit(1)
        .get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = result.docs;
    if (documents.isNotEmpty) {
      final QuerySnapshot<Map<String, dynamic>> courses =
          await FirebaseFirestore.instance
              .collection(DBCollections.userCollection)
              .doc(user?.uid)
              .collection(DBCollections.coursesCollection)
              .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> courseList =
          courses.docs;
      logger.d('Courses: ${courseList.length}');
      List<String> ids = [];
      for (var data in courseList) {
        ids.add(data.id);
      }
      isAlreadyEnrolled.value = ids.contains(courseId);
      logger.d('Contains: ${ids.contains(courseId)}');
    } else {
      isAlreadyEnrolled.value = false;
    }
  }

  saveCourseForStudent({required String courseId, required String teacherId}) {
    isEnrolling.value = true;
    FirebaseFirestore.instance
        .collection(DBCollections.userCollection)
        .doc(user?.uid)
        .collection(DBCollections.coursesCollection)
        .doc(courseId)
        .set({
      DBFields.courseUIDField: courseId,
    }, SetOptions(merge: true)).then((value) {
      final doc = FirebaseFirestore.instance
          .collection(DBCollections.userCollection)
          .doc(teacherId)
          .collection(DBCollections.coursesCollection)
          .doc(courseId);
      doc.set(
        {
          DBFields.courseUIDField: courseId,
        },
        SetOptions(merge: true),
      ).then((value) {
        doc.collection(DBCollections.studentsCollection).doc(user?.uid).set({
          DBFields.coursePriceField:
              discountPrice.value != "" ? discountPrice.value : price.value,
          DBFields.purchaseDateField: DateTime.now().millisecondsSinceEpoch,
          DBFields.studentId: user?.uid,
          DBFields.studentName: globalController.profile.value?.name,
          DBFields.studentNumber: globalController.profile.value?.number,
          DBFields.parentsEmail: globalController.profile.value?.parentsMail,
        }, SetOptions(merge: true));
      });
    });
    successToast(text: "Enrolled Successfully");
    isEnrolling.value = false;
  }

  void showRatingDialog(BuildContext context, String? courseId) {
    var feedbackController = TextEditingController();
    var rating = 0.0.obs;
    var isRating = false.obs;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection(DBCollections.coursesCollection)
                .doc(courseId)
                .collection(DBCollections.ratingsCollection)
                .get(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  var listOfRatings = [];
                  var ratingsSnap = snapshot.data!.docs;
                  for (var data in ratingsSnap) {
                    listOfRatings.add(data.id);
                  }
                  int index = listOfRatings.indexWhere((element) =>
                      element == FirebaseAuth.instance.currentUser?.uid);
                  if (index != -1) {
                    feedbackController.text =
                        ratingsSnap[index][DBFields.feedbackField];
                    rating.value = ratingsSnap[index][DBFields.ratingField];
                  }
                  return AlertDialog(
                    title: const Text("Rate this app"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() {
                          return RatingBar.builder(
                            initialRating: rating.value,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rate) {
                              rating.value = rate;
                            },
                          );
                        }),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: feedbackController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: "Feedback",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          isRating.value = true;
                          if (rating.value == 0.0) {
                            errorToast(text: 'Enter Rating');
                            return;
                          }
                          if (feedbackController.text.isEmpty) {
                            errorToast(text: 'Enter Feedback');
                            return;
                          }

                          FirebaseFirestore.instance
                              .collection(DBCollections.coursesCollection)
                              .doc(courseId)
                              .collection(DBCollections.ratingsCollection)
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .set(
                            {
                              DBFields.uidField:
                                  FirebaseAuth.instance.currentUser?.uid,
                              DBFields.ratingField: rating.value,
                              DBFields.feedbackField: feedbackController.text,
                              DBFields.studentName:
                                  globalController.profile.value!.name,
                            },
                            SetOptions(merge: true),
                          ).then((value) {
                            successToast(text: 'Rated');
                            Get.back();
                          });
                          isRating.value = false;
                        },
                        child: Obx(
                          () => !isRating.value
                              ? const Text("Submit")
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      ),
                    ],
                  );
                }
              }
              return const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  int getDifferenceInDays(int timeStamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    //DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second);
    logger.d(date.millisecondsSinceEpoch);
    DateTime now = DateTime.now();
    Duration difference = date.difference(now);
    int differenceInDays = difference.inSeconds;
    logger.d('Difference: $differenceInDays');
    return differenceInDays;
  }

  String convertSecondsToDHMS(double seconds) {
    int days = (seconds / (24 * 3600)).floor();
    int hours = ((seconds % (24 * 3600)) / 3600).floor();
    int minutes = ((seconds % 3600) / 60).floor();
    int remainingSeconds = (seconds % 60).floor();

    String result = '$days d : $hours h : $minutes m : $remainingSeconds s';
    return result;
  }

  @override
  void dispose() {
    videoPlayerController.value?.dispose();
    chewieController.value?.dispose();
    super.dispose();
  }
}
