import 'package:Taayza/controllers/admin_controller.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  final AdminController controller;

  const DashboardScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20.r),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.r,
                  mainAxisSpacing: 20.r,
                ),
                children: [
                  Card(
                    elevation: 0,
                    color: tealColor.withOpacity(
                      0.2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            controller.totalTeachers.value.toString(),
                            style: TextStyle(
                              color: tealColor,
                              fontSize: 40.sp,
                            ),
                          ),
                        ),
                        const ListTile(
                          leading: Icon(
                            Icons.school_outlined,
                          ),
                          title: AutoSizeText(
                            'Total Student',
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 0,
                    color: tealColor.withOpacity(
                      0.2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            controller.totalStudents.value.toString(),
                            style: TextStyle(
                              color: tealColor,
                              fontSize: 40.sp,
                            ),
                          ),
                        ),
                        const ListTile(
                          leading: Icon(
                            Icons.assignment_ind_outlined,
                          ),
                          title: AutoSizeText(
                            'Total Teacher',
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 0,
                    color: tealColor.withOpacity(
                      0.2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            controller.totalUsers.value.toString(),
                            style: TextStyle(
                              color: tealColor,
                              fontSize: 40.sp,
                            ),
                          ),
                        ),
                        const ListTile(
                          leading: Icon(
                            Icons.groups_outlined,
                          ),
                          title: AutoSizeText(
                            'Total Users',
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 0,
                    color: tealColor.withOpacity(
                      0.2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            controller.totalCourses.value.toString(),
                            style: TextStyle(
                              color: tealColor,
                              fontSize: 40.sp,
                            ),
                          ),
                        ),
                        const ListTile(
                          leading: Icon(
                            Icons.assignment_outlined,
                          ),
                          title: AutoSizeText(
                            'Total Courses',
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 0,
                    color: tealColor.withOpacity(
                      0.2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            controller.totalActiveCourses.value.toString(),
                            style: TextStyle(
                              color: tealColor,
                              fontSize: 40.sp,
                            ),
                          ),
                        ),
                        const ListTile(
                          leading: Icon(
                            Icons.toggle_on_outlined,
                          ),
                          title: AutoSizeText(
                            'Active Courses',
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 0,
                    color: tealColor.withOpacity(
                      0.2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            controller.totalInactiveCourses.value.toString(),
                            style: TextStyle(
                              color: tealColor,
                              fontSize: 40.sp,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.toggle_off_outlined,
                            color: Colors.red.shade200,
                          ),
                          title: const AutoSizeText(
                            'InActive Courses',
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
