import 'package:Taayza/controllers/admin_controller.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdminScreen extends StatelessWidget {
  final controller = Get.put(AdminController());

  AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () {
            return Text(
              controller.getTitle(controller.selectedIndex.value),
            );
          },
        ),
      ),
      drawer: Obx(
        () {
          return NavigationDrawer(
            onDestinationSelected: (value) {
              if (value != 3) {
                controller.selectedIndex.value = value;
                Get.back();
                return;
              }
              controller.globalController.logout();
            },
            selectedIndex: controller.selectedIndex.value,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: tealColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(
                      10.r,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp,
                        ),
                      ),
                      const AutoSizeText(
                        'You are logged in as admin',
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              ),
              const NavigationDrawerDestination(
                icon: Icon(
                  Icons.dashboard,
                ),
                label: Text('Dashboard'),
              ),
              const NavigationDrawerDestination(
                icon: Icon(
                  Icons.assignment_ind_outlined,
                ),
                label: Text('Teacher List'),
              ),
              const NavigationDrawerDestination(
                icon: Icon(
                  Icons.school_outlined,
                ),
                label: Text('Student List'),
              ),
              const NavigationDrawerDestination(
                icon: Icon(
                  Icons.logout,
                ),
                label: Text('Logout'),
              ),
            ],
          );
        },
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.screens(controller: controller),
        ),
      ),
    );
  }
}
