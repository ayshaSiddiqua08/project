import 'dart:io';

import 'package:Taayza/controllers/global_controller.dart';
import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/model/profile_model.dart';
import 'package:Taayza/views/screens/auth/auth_screen.dart';
import 'package:Taayza/views/screens/teacher/home/bottom_nav/courses/courses_screen.dart';
import 'package:Taayza/views/screens/teacher/home/bottom_nav/home_screen.dart';
import 'package:Taayza/views/screens/teacher/home/bottom_nav/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TeacherController extends GetxController {
  final globalController = Get.find<GlobalController>();
  Stream<QuerySnapshot<Map<String, dynamic>>> models =
      FirebaseFirestore.instance.collection("models").snapshots();
  final user = FirebaseAuth.instance.currentUser;
  final profile = Rx<ProfileModel?>(null);
  final userCollection =
      FirebaseFirestore.instance.collection(DBCollections.userCollection);
  var selectedIndex = 0.obs;
  var isEnabled = false.obs;
  var isProfileUpdating = false.obs;

  /*Profile Section*/
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final statusController = TextEditingController();
  var profileUrl = ''.obs;
  final FocusNode unitCodeCtrlFocusNode = FocusNode();

  List<Widget> screens(TeacherController controller) {
    return [
      HomeScreen(controller: controller),
      CoursesScreen(controller: controller),
      ProfileScreen(controller: controller),
    ];
  }

  getProfileDetails() {
    if (user == null) {
      errorToast(text: "No User Found");
      Get.offAll(() => AuthScreen());
      return;
    }
    userCollection.doc(user?.uid).get().then((value) {
      if (!value.exists) {
        errorToast(text: "No User Found");
        Get.offAll(() => AuthScreen());
        return;
      }
      profile.value = ProfileModel(
        name: value[DBFields.nameField].toString(),
        number: value[DBFields.numberField].toString(),
        uid: value[DBFields.uidField].toString(),
        type: value[DBFields.typeField].toString().capitalizeFirst!,
        joiningDate: value[DBFields.joiningDateField],
        profilePicture: value.data()![DBFields.profilePic],
        isAccountApproved: value.data()![DBFields.isAccountApproved]
      );
      nameController.text = profile.value!.name;
      phoneController.text = profile.value!.number;
      typeController.text = profile.value!.type;
      profileUrl.value = profile.value!.profilePicture!;
    });
  }

  updateProfile() async {
    if (nameController.text == profile.value!.name) {
      isEnabled.value = false;
      errorToast(text: "Same Name");
      return;
    }
    isProfileUpdating.value = true;
    await userCollection.doc(user?.uid).set(
      {
        DBFields.nameField: nameController.text,
      },
      SetOptions(merge: true),
    ).then((value) {
      isEnabled.value = false;
      isProfileUpdating.value = false;
      profile.value = null;
      getProfileDetails();
      successToast();
    });
  }

  pickProfile({required ImageSource imageSource}) async {
    XFile? result = await ImagePicker().pickImage(
      source: imageSource,
      preferredCameraDevice: CameraDevice.front,
    );
    if (result != null) {
      Get.back();
      isProfileUpdating.value = true;
      String uid = globalController.profile.value!.uid;
      File file = File(result.path);
      String folderName = uid;
      String? downloadURL = await uploadFile(file, folderName);
      if (downloadURL != null) {
        logger.d('File uploaded successfully. Download URL: $downloadURL');
        FirebaseFirestore.instance
            .collection(DBCollections.userCollection)
            .doc(uid)
            .set(
          {DBFields.profilePic: downloadURL},
          SetOptions(
            merge: true,
          ),
        ).then((value) {
          globalController.profile.value!.profilePicture = downloadURL;
          profileUrl.value = downloadURL;
          successToast(text: 'Picture uploaded successfully');
        }).onError((error, stackTrace) {
          errorToast();
        });
      } else {
        logger.e('File upload failed.');
      }
    }
    isProfileUpdating.value = false;
  }

  Future<String?> uploadFile(File file, String folderName) async {
    try {
      String fileName = 'profilepic';
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
  void onInit() {
    getProfileDetails();
    super.onInit();
  }
}
