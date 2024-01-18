import 'dart:io';

import 'package:Taayza/controllers/global_controller.dart';
import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/model/profile_model.dart';
import 'package:Taayza/views/screens/auth/auth_screen.dart';
import 'package:Taayza/views/screens/student/home/bottom_nav/courses/courses_screen.dart';
import 'package:Taayza/views/screens/student/home/bottom_nav/home_screen.dart';
import 'package:Taayza/views/screens/student/home/bottom_nav/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StudentController extends GetxController {
  final globalController = Get.find<GlobalController>();

  //Stream<QuerySnapshot<Map<String, dynamic>>> models = FirebaseFirestore.instance.collection("models").snapshots();
  final user = FirebaseAuth.instance.currentUser;
  final profile = Rx<ProfileModel?>(null);
  final userCollection = FirebaseFirestore.instance.collection(DBCollections.userCollection);

  var selectedIndex = 0.obs;
  var isEnabled = false.obs;
  var isProfileUpdating = false.obs;
  var purchasedCourses = <String>[].obs;
  var users = <ProfileModel>[];
  var usersID = <String>[];
  RxList<PlatformFile> selectedFiles = <PlatformFile>[].obs;

  /*Profile Section*/
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final typeController = TextEditingController();

  /*
 if you want to add new field must initialized new  TextEditingController

  final newController=TextEditingController();
  */

  var profileUrl = ''.obs;
  final FocusNode unitCodeCtrlFocusNode = FocusNode();

  var isUpload=false.obs;

  List<Widget> screens(StudentController controller) {
    return [
      HomeScreen(controller: controller),
      CoursesScreen(controller: controller),
      ProfileScreen(controller: controller),
    ];
  }

  getProfileDetails() async {
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
      );
      nameController.text = profile.value!.name;
      phoneController.text = profile.value!.number;
      typeController.text = profile.value!.type;
      profileUrl.value = profile.value!.profilePicture??'';
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

  getPurchasedCourses() async {
    FirebaseFirestore.instance.collection(DBCollections.userCollection)
        .doc(FirebaseAuth.instance.currentUser?.uid).collection(DBCollections.coursesCollection).get().then((value) {
      purchasedCourses.clear();
      for (var data in value.docs) {
        purchasedCourses.add(data.id);
      }
      logger.d(purchasedCourses);
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

  pickAssignmentFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'pptx'],
    );
    if (result != null) {
      selectedFiles.assignAll(result.files);

    }
  }
  Future<void> uploadAssignmentFile(RxList<PlatformFile> selectedFiles
      ,String? teacherId, String? courseId,String? filesId)async {
     isUpload.value=true;
    //String? teacherId, String? courseId
    try{
      List<String> uploadedFiles = [];

      for(var file in selectedFiles){
        String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
        String filePath = 'filesId/$fileName';
        firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance
            .ref().child('Assignment').child(filePath);
        await storageReference.putFile(File(file.path.toString()));

        String downloadURL = await storageReference.getDownloadURL();
        uploadedFiles.add(downloadURL);
        logger.d(downloadURL);
      }
      var assignmentInfo = FirebaseFirestore.instance
          .collection(DBCollections.userCollection)
          .doc(teacherId)
          .collection(DBCollections.coursesCollection)
          .doc(courseId)
          .collection(DBCollections.assignmentCollection)
          .doc(filesId)
          .collection(DBCollections.submittedAssignment).doc();
      assignmentInfo.set({
        DBFields.submittedStudentName:profile.value!.name,
        DBFields.submittedStudentID:profile.value!.uid,
        DBFields.submittedFiles: FieldValue.arrayUnion(uploadedFiles),

      }).then((value) => {
        successToast(text: "Submitted"),
        isUpload.value=false,
        selectedFiles.value=[],
        Get.back()

      });

    }catch(e){
      logger.e(e.toString());
      isUpload.value=false;
      return;
    }

  }

  @override
  void onInit() {
    getProfileDetails();
    super.onInit();
  }
}
