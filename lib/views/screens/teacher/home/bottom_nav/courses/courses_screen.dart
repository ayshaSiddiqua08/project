import 'package:Taayza/controllers/teacher_controller.dart';
import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/views/components/custom_container.dart';
import 'package:Taayza/views/components/custom_styles.dart';
import 'package:Taayza/views/screens/teacher/home/bottom_nav/courses/add_course_details_screen.dart';
import 'package:Taayza/views/screens/teacher/home/bottom_nav/courses/enrolled_students_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../components/custom_button.dart';
import '../../../../../components/custom_dialog.dart';

class CoursesScreen extends StatelessWidget {
  final TeacherController controller;

  const CoursesScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(DBCollections.coursesCollection)
            .where(DBFields.teacherUIDField, isEqualTo: controller.user?.uid)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              final lists = snapshot.data!.docs;
              return ListView.builder(
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  final data = lists[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: 10.w,
                    ),
                    child: CustomContainer(
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Get.to(
                                () => AddCourseDetailsScreen(
                                  courseId: data.id,
                                ),
                              );
                            },
                            leading: SizedBox(
                              height: 100.h,
                              width: 50.w,
                              child: CachedNetworkImage(
                                imageUrl: data[DBFields.imageUrlField],
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              data[DBFields.courseNameField],
                            ),
                            subtitle: FittedBox(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Price: ${data[DBFields.coursePriceField] + taka}',
                                    style: blackStyle(),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    'Discount Price: ${data[DBFields.courseDiscountPriceField] + taka}',
                                    style: blackStyle(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              onPressed: () {
                                Get.to(
                                  () => EnrolledStudentsScreen(
                                    courseId: data.id,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.school_outlined,
                                color: secondaryColor,
                              ),
                              label: Text(
                                "See Enrolled Student",
                                style: secondaryStyle(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: secondaryColor,
        onPressed: () {
          controller.profile.value!.isAccountApproved!
              ? Get.to(() => AddCourseDetailsScreen())
              :showDialog(
            context: context,
            builder: (context) {
              return RoundedDialog();
            },
          );
        },
        icon: const Icon(
          Icons.add,
          color: whiteColor,
        ),
        label: Text("Add Course", style: whiteStyle()),
      ),
    );

  }

  AlertDialog openNotApprovedDialog(BuildContext context){

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),

      content: SizedBox(
        height: 300.h,
        width: 300.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           /* SizedBox(
          height: 200.h,width: 200.w,
              child: Lottie.network(
                  'https://lottie.host/82236da9-0a49-44a2-9bf0-1c7b05e74a84/PPviwbJynQ.json',),
            ),*/
            AutoSizeText(
              "Currently, your account is not approved?",style: blackStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w300
            ),
            ),
            AutoSizeText(
              "Currently, your account is not approved?",style: blackStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w300
            ),
            ),

          ],
        ),
      ),
      actions: <Widget>[
        CustomButton(
          onPressed: () {
            //  controller.pickImage();
            sendMailForAdminSupport();


          },
          child: AutoSizeText(
            "Get Support via mail",style: blackStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w300
          ),
          ),
        ),

      ],
    );
  }

  void sendMailForAdminSupport() {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'taayzag@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Student Progressive Report',
      }),
    );

    _launchUrl(emailLaunchUri);
  }
  Future<void> _launchUrl(Uri emailLaunchUri) async {

    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch $emailLaunchUri');
    }
  }
}
