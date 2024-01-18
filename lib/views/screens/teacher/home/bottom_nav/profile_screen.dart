import 'dart:ui';

import 'package:Taayza/controllers/teacher_controller.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/views/components/custom_button.dart';
import 'package:Taayza/views/components/custom_photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../components/custom_text_field.dart';

class ProfileScreen extends StatelessWidget {
  final TeacherController controller;

  const ProfileScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getProfileDetails();
    logger.d(controller.selectedIndex.value);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 20.w,
          ),
          child: Obx(() {
            return controller.profile.value != null
                ? Column(
                    children: [
                      _image(context),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomTextField(
                        controller: controller.nameController,
                        hintText: 'Enter Your Name',
                        helperText: "Your Full Name",
                        textInputType: TextInputType.name,
                        isEnabled: controller.isEnabled.value,
                        focusNode: controller.unitCodeCtrlFocusNode,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTextField(
                        controller: controller.phoneController,
                        hintText: 'Enter Your Phone',
                        helperText: "Your Phone Number",
                        textInputType: TextInputType.phone,
                        isEnabled: false,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTextField(
                        controller: controller.typeController,
                        hintText: 'Enter Your Phone',
                        helperText: "Your Type",
                        isEnabled: false,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      CustomTextField(
                        controller: controller.statusController,
                        hintText:controller.profile.value!.isAccountApproved!
                            ? 'Your account is approved ✔️ '
                            :'Your account is not approved 🚫',
                        helperText: "Account Status",
                        isEnabled: false,
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          }),
        ),
      ),
      bottomNavigationBar: CustomButton(
        onPressed: () {
          controller.globalController.logout();
        },
        child: Text(
          "Log Out",
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _image(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              "Choose Option",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: controller.profileUrl.value!='',
                  child: ListTile(
                    onTap: () {
                      Get.back();
                      Get.to(
                        () => CustomPhotoView(
                          url: controller.profileUrl.value,
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.photo,
                      color: secondaryColor,
                    ),
                    title: const Text(
                      "View Image",
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    controller.pickProfile(imageSource: ImageSource.gallery);
                  },
                  leading: const Icon(
                    Icons.collections,
                    color: secondaryColor,
                  ),
                  title: const Text(
                    "Pick Image",
                  ),
                ),
                ListTile(
                  onTap: () {
                    controller.pickProfile(imageSource: ImageSource.camera);
                  },
                  leading: const Icon(
                    Icons.camera_alt,
                    color: secondaryColor,
                  ),
                  title: const Text(
                    "Capture Image",
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: secondaryColor.withOpacity(0.5), // Border color with opacity
            width: 5.w,
          ),
        ),
        child: Stack(
          children: [
            ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
                child: Container(
                  color: secondaryColor
                      .withOpacity(0.1), // Background color with opacity
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Obx(
                () => controller.profileUrl.value != ''
                    ? CircleAvatar(
                        radius: 60.r,
                        backgroundImage: CachedNetworkImageProvider(
                          controller.profileUrl.value,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80.r,
                      ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: const Icon(
                  Icons.camera_alt,
                  color: secondaryColor,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
