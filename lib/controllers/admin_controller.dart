import 'package:Taayza/controllers/global_controller.dart';
import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/model/profile_model.dart';
import 'package:Taayza/views/screens/admin/admin_screen.dart';
import 'package:Taayza/views/screens/admin/children/dashboard_screen.dart';
import 'package:Taayza/views/screens/admin/children/students_list_screen.dart';
import 'package:Taayza/views/screens/admin/children/teachers_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  var selectedIndex = 0.obs;
  var totalTeachers = 0.obs;
  var teachersList = <ProfileModel>[].obs;
  var totalStudents = 0.obs;
  var studentsList = <ProfileModel>[].obs;
  var totalCourses = 0.obs;
  var totalActiveCourses = 0.obs;
  var totalInactiveCourses = 0.obs;
  var totalUsers = 0.obs;
  final globalController = Get.find<GlobalController>();

  List<Widget> screens({required AdminController controller}) {
    return [
      DashboardScreen(controller: controller),
      TeacherListScreen(controller: controller),
      StudentsListScreen(controller: controller),
    ];
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Teacher List';
        case 2:
        return 'Student List';
      default:
        return 'Admin';
    }
  }

  getTotalUsers() {
    FirebaseFirestore.instance
        .collection(DBCollections.userCollection)
        .snapshots()
        .listen((data) {
      if (data.size != 0) {
        final listOfData = data.docs;
        totalTeachers.value = 0;
        totalUsers.value = data.size;
        totalStudents.value = 0;
        teachersList.clear();
        studentsList.clear();
        for (var docs in listOfData) {
          final type = docs[DBFields.typeField];
          if (type == 'teacher') {
            totalTeachers.value++;
            FirebaseFirestore.instance
                .collection(DBCollections.userCollection)
                .doc(docs.id)
                .collection(DBCollections.coursesCollection)
                .snapshots()
                .listen(
              (event) {
                teachersList.add(
                  ProfileModel(
                    name: docs[DBFields.nameField].toString(),
                    number: docs[DBFields.numberField].toString(),
                    uid: docs[DBFields.uidField].toString(),
                    type: docs[DBFields.typeField].toString().capitalizeFirst!,
                    joiningDate: docs[DBFields.joiningDateField],
                    totalCourses: event.size,
                  ),
                );
              },
            );
          } else {
            totalStudents.value++;
            FirebaseFirestore.instance
                .collection(DBCollections.userCollection)
                .doc(docs.id)
                .collection(DBCollections.coursesCollection)
                .snapshots()
                .listen(
              (event) {
                studentsList.add(
                  ProfileModel(
                    name: docs[DBFields.nameField].toString(),
                    number: docs[DBFields.numberField].toString(),
                    uid: docs[DBFields.uidField].toString(),
                    type: docs[DBFields.typeField].toString().capitalizeFirst!,
                    joiningDate: docs[DBFields.joiningDateField],
                    totalCourses: event.size,
                  ),
                );
              },
            );
          }
        }
      }
    });
    FirebaseFirestore.instance
        .collection(DBCollections.coursesCollection)
        .snapshots()
        .listen((data) {
      if (data.size != 0) {
        totalCourses.value = data.size;
        totalActiveCourses.value = 0;
        for (var courses in data.docs) {
          final active = courses[DBFields.isActiveField] ?? false;
          if (active) {
            totalActiveCourses.value++;
          } else {
            totalInactiveCourses.value++;
          }
        }
      }
    });
  }

  @override
  void onInit() {
    getTotalUsers();
    super.onInit();
  }
}
