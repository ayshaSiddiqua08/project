import 'package:Taayza/controllers/student_controller.dart';
import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/views/components/custom_container.dart';
import 'package:Taayza/views/components/custom_styles.dart';
import 'package:Taayza/views/screens/student/home/bottom_nav/courses/course_details_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../../components/custom_button.dart';
import '../../../../teacher/home/bottom_nav/courses/calling_page.dart';

class TeacherViewProfileScreen extends StatelessWidget {
  final String uid;
  final StudentController controller;


  const TeacherViewProfileScreen({super.key, required this.controller, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tealColor,
        elevation: 0,
        title: const Text(
          "Teacher Profile",
          style: TextStyle(
            color: whiteColor,
          ),
        ),
        actions: [
       //   isStreaming? buildGroupCall(context):SizedBox()
        ],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection(DBCollections.userCollection).doc(uid).snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshots) {
                  if (snapshots.hasData) {
                    if (snapshots.data != null) {
                      final data = snapshots.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.teal,
                              ),
                              borderRadius: BorderRadius.circular(
                                10.r,
                              ),
                            ),
                            padding: EdgeInsets.all(
                              10.r,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                    child: CircleAvatar(
                                      radius: 30.r,
                                      child: Icon(
                                        Icons.person,
                                        size: 30.r,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                customRichText(
                                  title: 'Name',
                                  data: data[DBFields.nameField].toString(),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                customRichText(
                                  title: 'Phone',
                                  data: data[DBFields.numberField].toString(),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: tealColor,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Courses",
                style: tealStyle(
                  fontSize: 19.sp,
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection(DBCollections.coursesCollection).snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      final lists = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: lists.length,
                        itemBuilder: (context, index) {
                          final data = lists[index];
                          return Visibility(
                            visible: uid == data[DBFields.uidField],
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 5.h,
                              ),
                              child: CustomContainer(
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Get.to(
                                          () => CourseDetailsScreen(
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
                                      subtitle: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: AutoSizeText(
                                              'Price: ${data[DBFields.coursePriceField] + taka}',
                                              maxLines: 1,
                                              style: blackStyle(),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          Expanded(
                                            child: AutoSizeText(
                                              'Discount: ${data[DBFields.courseDiscountPriceField] + taka}',
                                              maxLines: 1,
                                              style: blackStyle(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget customRichText({required String title, required String data}) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.poppins(),
        children: [
          TextSpan(
            text: "$title: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: Colors.teal,
            ),
          ),
          TextSpan(
            text: data,
            style: blackStyle(
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
  Widget buildGroupCall(BuildContext context) {

    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return openCallDiaglog();
            },
          );
        },
        child: SizedBox(
          child: Row(
            children: [
              Icon(
                Icons.group_add_outlined,
                color: whiteColor,
              ),
              SizedBox(width: 5.w,),
              Text("Join call", style: whiteStyle())

            ],
          ),
        ),
      ),
    );
  }
  Widget openCallDiaglog(){
    final textController=TextEditingController();
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text('Enter Text'),
      content: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: tealColor, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: 'Type group call id...',
        ),
      ),
      actions: <Widget>[
        CustomButton(
          onPressed: () {
            //  controller.pickImage();

            Get.to(() => CallPage(callingId: textController.text.trim(),courseId: '',));
        //    Zego

          },
          child: Text(
            "Join Group",
            style: whiteStyle(),
          ),
        ),
      ],
    );
  }

}
