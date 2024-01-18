import 'package:Taayza/global/helpers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../../controllers/list_courses_controller.dart';
import '../../../../../../controllers/student_controller.dart';
import '../../../../../../db_paths/db_fields.dart';
import '../../../../../../global/app_constants.dart';
import '../../../../../components/custom_button.dart';
import '../../../../../components/custom_styles.dart';

class SubmitAssignment extends StatelessWidget {
  final Map<String, dynamic> data;
  final String teacherId;
  final String courseId;

  const SubmitAssignment({super.key, required this.data, required this.teacherId, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ListCoursesController());
    final studentController = Get.put(StudentController());
    return WillPopScope(
      onWillPop: ()async {
        studentController.selectedFiles.value=[];
        return  true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Assignment Details'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: ListView(
            children: [
              AutoSizeText(
                "Due ${data[DBFields.assignmentDueDate]}, 12.00 am",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: commonStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 10.h,
              ),
              AutoSizeText(
                "Confirm due-date flexibility with your teacher",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: commonStyle(
                    color: Colors.black.withOpacity(0.9),
                    fontSize: 14.sp,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 15.h,
              ),
              AutoSizeText(
                "${data[DBFields.assignmentTitle]}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: commonStyle(
                    color: secondaryColor.withOpacity(0.7),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold),
              ),
              Divider(),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Dear Students,\nSubmit your assignment based on\n\n${data[DBFields.assignmentDescription]}",
                textAlign: TextAlign.start,
                style: commonStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: 20.h,
              ),
              _buildSelectFiles(studentController),
              SizedBox(
                height: 20.h,
              ),
              _buildShowSelectedFiles(studentController),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 60.h,
            width: double.maxFinite,
            child: CustomButton(
              buttonPadding: EdgeInsets.symmetric(
                vertical: 10.h,
              ),
              onPressed: () async {
                      if(studentController.selectedFiles.isEmpty){
                        errorToast(text: 'Please Select Files');
                      }else{
                        studentController.uploadAssignmentFile(
                            studentController.selectedFiles,teacherId,courseId,data[DBFields.assignmentId]);
                      }
              },
              child: Obx(
                    () => studentController.isUpload.value
                    ? const Center(
                  child: CircularProgressIndicator(
                    color: whiteColor,
                  ),
                )
                    : Text(
                  "Upload Files",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectFiles(StudentController studentController) {
    return DottedBorder(
      color: Colors.black,
      radius: Radius.circular(12),
      borderType: BorderType.RRect,
      strokeWidth: 1,
      child: InkWell(
        onTap: () {
          studentController.pickAssignmentFile();
        },
        child: Container(
          height: 80.h,
          width: double.maxFinite,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_file),
                      Text(
                        'Select File',
                        textAlign: TextAlign.start,
                        style: commonStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  FittedBox(
                    child: Text(
                      'Choose your file here. Supported file types: PDF, DOCX, PPTX.',
                      textAlign: TextAlign.start,
                      style: commonStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShowSelectedFiles(StudentController studentController) {
    return Obx(() => Visibility(
          visible: studentController.selectedFiles.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Files:',
                style: commonStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
              for (var file in studentController.selectedFiles.value)
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.file_present_outlined),
                        Text(
                          file.name,
                          style: commonStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
