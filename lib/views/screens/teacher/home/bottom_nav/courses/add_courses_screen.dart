import 'package:Taayza/controllers/add_courses_controller.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/views/components/custom_button.dart';
import 'package:Taayza/views/components/custom_styles.dart';
import 'package:Taayza/views/components/custom_text_field.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddCoursesScreen extends StatelessWidget {
  final String uid;
  final AddCoursesController controller;

  const AddCoursesScreen(
      {Key? key, required this.controller, required this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Video",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _videoSelection(),
            _videoSelector(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'OR',
                    style: tealStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                    hintText: "Enter Video URL",
                    helperText:
                        "Video URL must be a valid url. Youtube url is not supported.",
                    controller: controller.videoUrlController,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  const Divider(),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomTextField(
                    hintText: "Enter Video Name",
                    helperText: "Video Name",
                    controller: controller.videoNameController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                    hintText: "Enter Description",
                    helperText: "Video Description",
                    controller: controller.descriptionController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                    hintText: "Enter Video Duration",
                    helperText: "Video Duration",
                    controller: controller.durationController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomButton(
                    onPressed: () {
                      controller.saveVideo(uid);
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
            ),
            SizedBox(
              height: 200.h,
            ),
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
            return (controller.chewieController.value !=
                    null) //&& controller.videoPlayerController.value!.
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
