import 'package:Taayza/controllers/add_courses_controller.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/views/components/custom_button.dart';
import 'package:Taayza/views/components/custom_styles.dart';
import 'package:Taayza/views/components/custom_text_field.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddResourcesScreen extends StatelessWidget {
  final String uid;
  final AddCoursesController controller;

  const AddResourcesScreen({Key? key, required this.controller, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Resources",
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
                    hintText: "Enter Resources Name",
                    helperText: "Resources Name",
                    controller: controller.resourcesNameController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextField(
                    hintText: "Enter Resources Link",
                    helperText: "Resources Link",
                    controller: controller.resourcesLinkController,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomButton(
                    onPressed: () {
                      controller.saveResource(uid);
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
