import 'package:Taayza/controllers/student_controller.dart';
import 'package:Taayza/controllers/teacher_controller.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/exit_dialog.dart';

class TeacherMainScreen extends StatelessWidget {
  final controller = Get.put(TeacherController());

  TeacherMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        showDialog(
          context: context,
          builder: (context) {
            return ExitDialog();
          },
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: secondaryColor,
          elevation: 0,
          title: const Text(
            "Taayza Teacher",
            style: TextStyle(
              color: whiteColor,
            ),
          ),
          actions: [
            Obx(
              () => controller.selectedIndex.value == 2
                  ? TextButton.icon(
                      onPressed: () {
                        if (controller.isEnabled.value) {
                          controller.updateProfile();
                        } else {
                          controller.isEnabled.value = true;
                          controller.unitCodeCtrlFocusNode.requestFocus();
                        }
                      },
                      icon: controller.isProfileUpdating.value
                          ? const CircularProgressIndicator(
                              color: whiteColor,
                            )
                          : Icon(
                              controller.isEnabled.value ? Icons.save : Icons.edit,
                              color: whiteColor,
                            ),
                      label: Text(
                        controller.isEnabled.value ? "Save" : "Edit",
                        style: const TextStyle(
                          color: whiteColor,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            SizedBox(
              width: 5.w,
            ),
          ],
        ),
        body: Obx(() {
          return IndexedStack(
            index: controller.selectedIndex.value,
            children: controller.screens(controller),
          );
        }),
        bottomNavigationBar: Obx(() {
          return BottomNavigationBar(
            selectedItemColor: secondaryColor,
            unselectedItemColor: greyColor,
            type: BottomNavigationBarType.shifting,
            onTap: (int index) {
              if (controller.selectedIndex.value != 2) {
                controller.isEnabled.value = false;
                controller.nameController.text = controller.profile.value!.name;
              }
              controller.selectedIndex.value = index;
            },
            currentIndex: controller.selectedIndex.value,
            items: const [
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.receipt_long),
                icon: Icon(Icons.receipt_long_outlined),
                label: 'Courses',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.person),
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          );
        }),
      ),
    );
  }
}
