import 'package:Taayza/controllers/student_controller.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/exit_dialog.dart';

class StudentMainScreen extends StatelessWidget {
  final controller = Get.put(StudentController());

  StudentMainScreen({Key? key}) : super(key: key);

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
          backgroundColor: tealColor,
          elevation: 0,
          title: const Text(
            "Taayza",
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
                              controller.isEnabled.value
                                  ? Icons.save
                                  : Icons.edit,
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
          return NavigationBar(
            onDestinationSelected: (int index) {
              if (controller.selectedIndex.value != 2) {
                controller.isEnabled.value = false;
                if (controller.profile.value != null) {
                  controller.nameController.text = controller.profile.value!.name;
                }
              }
              controller.selectedIndex.value = index;
            },
            selectedIndex: controller.selectedIndex.value,
            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.receipt_long),
                icon: Icon(Icons.receipt_long_outlined),
                label: 'Courses',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.person),
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
/*
student : +8801911911911
OTP :123456
teacher : +8801911911922
OTP: 123456
admin : 0000
 */