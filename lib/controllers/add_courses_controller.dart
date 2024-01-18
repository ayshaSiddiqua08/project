import 'dart:io';

import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/views/screens/teacher/home/bottom_nav/courses/add_courses_screen.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddCoursesController extends GetxController {
  var videoPlayerController = Rx<VideoPlayerController?>(null);
  var chewieController = Rx<ChewieController?>(null);
  var filePath = "".obs;
  var imagePath = "".obs;
  var isImageFromFile = true.obs;
  var isEdit = false;
  final ImagePicker picker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser;

  /*Add Course Details*/
  final courseNameController = TextEditingController();
  final priceController = TextEditingController();
  final expiryDateController = TextEditingController();
  final discountPriceController = TextEditingController();
  final smallDescriptionController = TextEditingController();
  final largeDescriptionController = TextEditingController();
  final videoUrlController = TextEditingController();
  /*Assignment Details*/
  final titleController = TextEditingController();
  final dueDateController = TextEditingController();
  final detailsController = TextEditingController();
  Rx<DateTime?> dueDate = Rx<DateTime?>(null);
  var expiryMilliSecond = 0;
  var isActive = true.obs;
  var isCourseSaving = false.obs;
  var isVideoSaving = false.obs;
  var isLoading = false.obs;
  Rx<DateTime?> pickedDate = Rx<DateTime?>(null);

  /*Add videos*/
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();
  final videoNameController = TextEditingController();

  /*Add Resources*/
  final resourcesNameController = TextEditingController();
  final resourcesLinkController = TextEditingController();

  Future<void> pickAndPlayVideo() async {
    String? videoPath = await _pickVideoFile();
    if (videoPath == null) {
      return;
    }
    filePath.value = videoPath;
    _initializePlayer(videoPath);
  }

  pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    imagePath.value = image.path;
    isImageFromFile.value = true;
  }

  Future<String?> _pickVideoFile() async {
    final XFile? galleryVideo =
        await picker.pickVideo(source: ImageSource.gallery);

    if (galleryVideo != null) {
      String filePath = galleryVideo.path;
      return filePath;
    } else {
      return null;
    }
  }

  void _initializePlayer(String videoPath) {
    videoPlayerController.value = VideoPlayerController.file(File(videoPath));
    chewieController.value = ChewieController(
        videoPlayerController: videoPlayerController.value!,
        autoPlay: true,
        looping: true,
        aspectRatio: 16 / 9);
  }

  saveResource(String? courseId) {
    isVideoSaving.value = true;
    var courseSetValue = FirebaseFirestore.instance
        .collection(DBCollections.coursesCollection)
        .doc(courseId)
        .collection(DBCollections.resourcesCollection)
        .doc();
    courseSetValue.set(
      {
        DBFields.resourceName: resourcesNameController.text,
        DBFields.resourceLink: resourcesLinkController.text,
      },
      SetOptions(merge: true),
    ).then((value) {
      successToast(text: "Video Listed");
      Get.back();
    });
    isVideoSaving.value = false;
  }

  saveVideo(String? courseId) async {
    if ((videoUrlController.text.isNotEmpty) &
        (!isValidVideoUrlPattern(videoUrlController.text))) {
      errorToast(text: 'Not a valid url');
      return;
    } else {
      if ((videoUrlController.text.isEmpty) & (filePath.value.isEmpty)) {
        isVideoSaving.value = false;
        errorToast(text: "No video selected");
        return;
      }
    }

    if (videoNameController.text.isEmpty |
        descriptionController.text.isEmpty |
        durationController.text.isEmpty) {
      errorToast(text: "Empty field");
      return;
    } else {
      isVideoSaving.value = true;
      var courseSetValue = FirebaseFirestore.instance
          .collection(DBCollections.coursesCollection)
          .doc(courseId)
          .collection(DBCollections.videosCollection)
          .doc();
      String? downloadURL;
      var videos = (await FirebaseFirestore.instance
              .collection(DBCollections.coursesCollection)
              .doc(courseId)
              .collection(DBCollections.videosCollection)
              .get())
          .docs
          .length;
      File file = File(filePath.value);
      String folderName =
          courseSetValue.id; // Replace with your desired folder name
      downloadURL = await uploadFile(file, folderName);
      logger.d('File uploaded successfully. Download URL: $downloadURL');
      courseSetValue.set(
        {
          DBFields.courseNameField: videoNameController.text,
          DBFields.videoUrlField: downloadURL,
          DBFields.descriptionField: descriptionController.text,
          DBFields.durationField: durationController.text,
          DBFields.videoID: videos++,
        },
        SetOptions(merge: true),
      ).then((value) {
        isVideoSaving.value = false;
        successToast(text: "Video Listed");
        Get.back();
      });
    }

    /*if (videoNameController.text.isEmpty) {

      if (downloadURL != null) {
        logger.d('File uploaded successfully. Download URL: $downloadURL');
      } else {
        logger.e('File upload failed.');
      }
    } else {
      downloadURL = videoUrlController.text;
    }

    isVideoSaving.value = false;*/
  }

  clearVideo() {
    descriptionController.clear();
    durationController.clear();
    videoNameController.clear();
    videoPlayerController.value = null;
    chewieController.value = null;
  }
  ///user/yysG51DgPXOziNZ33LQCvCpKeQ43/courses/RXqqPFIylPiAXvIt5uMO/assignment/eZ8uyuRsGQiFUNIh3rig
  createStudentAssignment(AddCoursesController controller, String? courseId) {
    var assignmentId = FirebaseFirestore.instance
        .collection(DBCollections.userCollection)
        .doc(user?.uid)
        .collection(DBCollections.coursesCollection)
        .doc(courseId)
         .collection(DBCollections.assignmentCollection).doc();
         assignmentId.set({
           DBFields.assignmentTitle:titleController.text,
           DBFields.assignmentDescription:detailsController.text,
           DBFields.assignmentDueDate:dueDateController.text,
           DBFields.assignmentId:assignmentId.id,
         }).then((value) => {
         successToast(text: "Created"),
         logger.d(assignmentId.id),
           titleController.clear(),
           detailsController.clear(),
           dueDateController.clear(),
         });

  }
  saveCourse(AddCoursesController controller, String? courseId) async {
    if (controller.imagePath.value.isEmpty) {
      errorToast(text: 'Select Image');
      return;
    }
    if (courseNameController.text.isEmpty |
        priceController.text.isEmpty |
        smallDescriptionController.text.isEmpty |
        largeDescriptionController.text.isEmpty) {
      errorToast(text: 'Fields can not be empty');
      return;
    }
    isCourseSaving.value = true;
    var courseSetValue = FirebaseFirestore.instance
        .collection(DBCollections.coursesCollection)
        .doc(courseId);
    String? downloadURL;
    if (isImageFromFile.value) {
      File file = File(imagePath.value);
      String folderName =
          courseSetValue.id; // Replace with your desired folder name
      downloadURL = await uploadFile(file, folderName);
      if (downloadURL != null) {
        logger.d('File uploaded successfully. Download URL: $downloadURL');
      } else {
        logger.e('File upload failed.');
      }
    }
    courseSetValue
        .set(
          {
            DBFields.courseNameField: courseNameController.text,
            DBFields.imageUrlField:
                isImageFromFile.value ? downloadURL : imagePath.value,
            DBFields.isActiveField: isActive.value,
            DBFields.largeDescriptionField: largeDescriptionController.text,
            DBFields.smallDescriptionField: smallDescriptionController.text,
            DBFields.coursePriceField: priceController.text,
            DBFields.discountPriceField: discountPriceController.text,
            DBFields.expiryDate: pickedDate.value != null
                ? pickedDate.value!.millisecondsSinceEpoch
                : 0,
            DBFields.teacherUIDField: user?.uid,
            DBFields.isStreaming: false,
            DBFields.isRecommend: false,
          },
          SetOptions(merge: true),
        )
        .then((value) => {
              FirebaseFirestore.instance
                  .collection(DBCollections.userCollection)
                  .doc(user?.uid)
                  .collection(DBCollections.coursesCollection)
                  .doc(courseSetValue.id)
                  .set(
                {
                  DBFields.courseUIDField: courseSetValue.id,
                },
                SetOptions(merge: true),
              )
            })
        .then(
          (value) {
            successToast(text: "Course Listed");
            if (!isEdit) {
              Get.to(() => AddCoursesScreen(
                  controller: controller, uid: courseSetValue.id));
            }
          },
        );

    isCourseSaving.value = false;
    if (!isEdit) {
      clearCourseData();
    }
  }

  getCourseDetails(String courseId) async {
    isLoading.value = true;
    isImageFromFile.value = false;
    await FirebaseFirestore.instance
        .collection(DBCollections.coursesCollection)
        .doc(courseId)
        .get()
        .then((doc) {
      courseNameController.text = doc[DBFields.courseNameField];
      largeDescriptionController.text = doc[DBFields.largeDescriptionField];
      smallDescriptionController.text = doc[DBFields.smallDescriptionField];
      priceController.text = doc[DBFields.coursePriceField];
      discountPriceController.text = doc[DBFields.discountPriceField];
      imagePath.value = doc[DBFields.imageUrlField];
      isActive.value = doc[DBFields.isActiveField];
      expiryMilliSecond = doc[DBFields.expiryDate];
    });
    expiryDateController.text = expiryMilliSecond != 0
        ? DateFormat('dd MMM, yyyy')
            .format(DateTime.fromMillisecondsSinceEpoch(expiryMilliSecond))
        : '';
    isImageFromFile.value = false;
    isLoading.value = false;
  }

  clearCourseData() {
    imagePath.value = "";
    isActive.value = true;
    courseNameController.clear();
    priceController.clear();
    discountPriceController.clear();
    largeDescriptionController.clear();
    smallDescriptionController.clear();
  }

  Future<String?> uploadFile(File file, String folderName) async {
    try {
      String fileName = path.basename(file.path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(folderName)
          .child(fileName);
      await ref.putFile(file);

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  @override
  void dispose() {
    videoPlayerController.value?.dispose();
    chewieController.value?.dispose();
    super.dispose();
  }

  bool isValidVideoUrlPattern(String url) {
    const pattern = r'^https?:\/\/.*\.(mp4|avi|mov|mkv|flv|wmv)$';
    final regExp = RegExp(pattern, caseSensitive: false);
    return regExp.hasMatch(url);
  }
}
