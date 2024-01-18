import 'package:Taayza/controllers/add_courses_controller.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/views/components/custom_button.dart';
import 'package:Taayza/views/components/custom_styles.dart';
import 'package:Taayza/views/components/custom_text_field.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../global/helpers.dart';

class AssignmentScreen extends StatelessWidget {
  final String uid;
  final AddCoursesController controller;

  const AssignmentScreen({Key? key, required this.controller, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Assignment",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextField(
                    hintText: "Pick Expiry Date",
                    helperText: "Assignment Submission Date",
                    controller: controller.dueDateController,
                    textInputType: TextInputType.none,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100));
                        controller.dueDate.value = pickedDate;
                        if (pickedDate != null) {
                          logger.d(pickedDate);
                          String formattedDate =
                          DateFormat('dd MMM, yyyy').format(pickedDate);
                          controller.dueDateController.text = formattedDate;
                        } else {
                          controller.dueDateController.clear();
                          controller.dueDate.value = null;
                        }
                      },
                      icon: const Icon(
                        Icons.date_range_rounded,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                    hintText: "Enter Assignment Tittle",
                    helperText: "Assignment Tittle",
                    controller: controller.titleController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                    isMultilineEnabled: true,
                    hintText: "Enter Assignment Description",
                    helperText: "Assignment Description",
                    controller: controller.detailsController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomButton(
                    onPressed: () {
                      if(controller.dueDateController.text.isEmpty
                          && controller.titleController.text.isEmpty
                          && controller.descriptionController.text.isEmpty ){
                        errorToast(text: 'Field Cannot empty');
                      }else{
                          controller.createStudentAssignment(controller, uid);
                      }
                    },
                    child: Obx(
                          () {
                        return !controller.isVideoSaving.value
                            ? Text(
                          "Save Data",
                          style: whiteStyle(),
                        )
                            : const Center(
                          child: CircularProgressIndicator(
                            color: whiteColor,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _videoSelector() {
    return CustomButton(
      onPressed: () {
        controller.pickAndPlayVideo();
      },
      child: Text(
        "Select Video",
        style: whiteStyle(),
      ),
    );
  }

  Widget _videoSelection() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: secondaryColor.withOpacity(
          0.1,
        ),
        child: Obx(
              () {
            return (controller.chewieController.value != null) //&& controller.videoPlayerController.value!.
                ? Chewie(
              controller: controller.chewieController.value!,
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.movie_outlined,
                  color: secondaryColor,
                ),
                Text(
                  "No Videos Selected",
                  style: secondaryStyle(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
