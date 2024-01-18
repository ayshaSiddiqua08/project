import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/model/profile_model.dart';
import 'package:Taayza/views/screens/admin/admin_screen.dart';
import 'package:Taayza/views/screens/student/home/main_screen.dart';
import 'package:Taayza/views/screens/auth/auth_screen.dart';
import 'package:Taayza/views/screens/teacher/home/teacher_main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../db_paths/db_collections.dart';
import '../db_paths/db_fields.dart';
import '../global/app_constants.dart';

enum Type { student, teacher }

class GlobalController extends GetxController {
  final box = Hive.box(hiveBox);
  var user = Rx<User?>(null);
  final profile = Rx<ProfileModel?>(null);
  final userCollection = FirebaseFirestore.instance.collection(DBCollections.userCollection);
  final isStudent = false.obs;

  @override
  void onInit() {
    gotoHome();
    super.onInit();
  }

  gotoHome() async {
    final isAdmin = box.get(admin) ?? false;
    if (isAdmin) {
      Future.delayed(const Duration(seconds: 3), () {
        Get.offAll(() => AdminScreen());
      });
    } else {
      user.value = FirebaseAuth.instance.currentUser;
      final auth = FirebaseAuth.instance.currentUser;
      Future.delayed(const Duration(seconds: 6), () async {
        if (auth != null) {
          final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance.collection(DBCollections.userCollection).where(DBFields.uidField, isEqualTo: auth.uid).get();
          List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = result.docs;
          String type = documents.first.get("type").toString();
          getProfileDetails();
          if (type == Type.student.name) {
            isStudent.value = true;
            Get.offAll(StudentMainScreen());
          } else {
            isStudent.value = false;
            Get.offAll(TeacherMainScreen());
          }
        } else {
          isStudent.value = true;
          Get.offAll(AuthScreen());
        }
      });
    }
  }

  logout() {
    FirebaseAuth.instance.signOut();
    isStudent.value = true;
    box.clear();
    Get.offAll(() => AuthScreen());
  }

  getProfileDetails() {
    final auth = FirebaseAuth.instance.currentUser;
    userCollection.doc(auth?.uid).get().then((value) {
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
        parentsMail: value[DBFields.parentsEmail],
      );
    });
  }
}
