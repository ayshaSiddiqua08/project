import 'package:Taayza/controllers/admin_controller.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/views/screens/admin/components/custom_list_view.dart';
import 'package:flutter/material.dart';

class TeacherListScreen extends StatelessWidget {
  final AdminController controller;

  const TeacherListScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomListView(
        users: controller.teachersList,
        color: greenColor.withOpacity(0.2),
        icon: Icons.person_outline,
        subtitle: 'Total Courses: ',
      ),
    );
  }
}
