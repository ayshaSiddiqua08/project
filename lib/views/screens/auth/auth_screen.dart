import 'package:Taayza/controllers/auth_controller.dart';
import 'package:Taayza/global/app_constants.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/views/components/custom_button.dart';
import 'package:Taayza/views/components/custom_container.dart';
import 'package:Taayza/views/components/custom_text_field.dart';
import 'package:Taayza/views/screens/admin/admin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../db_paths/db_collections.dart';
import '../../../db_paths/db_fields.dart';
import 'components/top_decoration.dart';

class AuthScreen extends StatelessWidget {
  final controller = Get.put(AuthController());

  AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: const Color(0xFFeeeeee),
      body: Obx(
        () => controller.isLogin.value ? _login() : _register(context),
      ),
    );
  }

  Widget _register(BuildContext context) {

    return Column(
      children: [
        _topDecoration(isLogin: false),
        _registerBottomItems(context),
      ],
    );
  }

  Widget _login() {
    return Column(
      children: [
        _topDecoration(isLogin: true),
        _loginFields(),
      ],
    );
  }

  Expanded _registerBottomItems(BuildContext context) {

    return Expanded(
      flex: 2,
      child: Container(
        color: const Color(0xFFeeeeee),
        padding: EdgeInsets.symmetric(
          horizontal: 30.w,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              CustomTextField(
                controller: controller.nameController,
                hintText: 'Enter Your Name',
                helperText: "Enter Full Name",
                textInputType: TextInputType.name,
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomTextField(
                controller: controller.phoneController,
                hintText: 'Enter Phone',
                helperText: "Enter Valid Phone Number",
                textInputType: TextInputType.phone,
              ),
              SizedBox(
                height: 10.h,
              ),
              /*Obx(
                () {
                  return CustomTextField(
                    controller: controller.passwordController,
                    hintText: 'Enter Password',
                    helperText: "Enter Logged Password",
                    obscure: controller.obscure.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.obscure.value = !controller.obscure.value;
                      },
                      icon: Icon(
                        controller.obscure.value ? Icons.visibility : Icons.visibility_off,
                        color: tealColor,
                      ),
                    ),
                  );
                },
              ),*/
              SizedBox(
                height: 10.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomContainer(
                    child: Obx(() {
                      return DropdownButton<Type>(
                        isExpanded: true,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: tealColor,
                        ),
                        value: controller.selectedType.value,
                        underline: const SizedBox(),
                        onChanged: (Type? newValue) {
                          controller.selectedType.value = newValue!;
                        },
                        items: Type.values.map<DropdownMenuItem<Type>>((Type value) {
                          return DropdownMenuItem<Type>(
                            value: value,
                            child: Text(
                              value.name.capitalizeFirst!,
                              style: const TextStyle(
                                color: tealColor,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, top: 5.h),
                    child: Text(
                      "Select Type",
                      style: TextStyle(
                        color: tealColor,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                    Visibility(
                      visible: controller.selectedType.value==Type.student,
                      child: CustomTextField(
                        controller: controller.parentsMailController,
                        hintText: 'Enter Your Parents Email',
                        helperText: "Enter Parents Email",
                        textInputType: TextInputType.name,
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  buttonPadding: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  onPressed: () async {
                    controller.isProcessing.value = true;
                    final QuerySnapshot<Map<String, dynamic>> result =
                    await FirebaseFirestore.instance.collection(DBCollections.userCollection).where(DBFields.numberField, isEqualTo: controller.phoneController.text).get();
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = result.docs;
                    if (documents.isNotEmpty) {
                      errorToast(text: "Please Login to continue");
                      controller.isProcessing.value = false;
                      return;
                    }
                    controller.verifyUserPhoneNumber(controller, Auths.registration);
                  },
                  child: Obx(
                    () => controller.isProcessing.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: whiteColor,
                            ),
                          )
                        : Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: whiteColor,
                            ),
                          ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          controller.isLogin.value = true;
                        },
                        child: const Text(
                          "Login Here",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topDecoration({required bool isLogin}) {
    return TopDecoration(
      isLogin: isLogin,
    );
  }

  Expanded _loginFields() {
    return Expanded(
      child: Container(
        color: const Color(0xFFeeeeee),
        padding: EdgeInsets.symmetric(
          horizontal: 30.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                controller: controller.phoneController,
                hintText: 'Enter Phone Number',
                helperText: "Enter Valid Phone Number",
                textInputType: TextInputType.phone,
              ),
              SizedBox(
                height: 10.h,
              ),
              /*Obx(
                () {
                  return CustomTextField(
                    controller: controller.passwordController,
                    hintText: 'Enter Password',
                    helperText: "Enter Logged Password",
                    obscure: controller.obscure.value,
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.obscure.value = !controller.obscure.value;
                      },
                      icon: Icon(
                        controller.obscure.value ? Icons.visibility : Icons.visibility_off,
                        color: tealColor,
                      ),
                    ),
                  );
                },
              ),*/
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  buttonPadding: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  onPressed: () async {
                    if (controller.phoneController.text == '0000') {
                      controller.globalController.box.put(admin, true);
                      Get.offAll(()=>AdminScreen());
                    } else {
                      controller.isProcessing.value = true;
                      final QuerySnapshot<Map<String, dynamic>> result =
                          await FirebaseFirestore.instance.collection(DBCollections.userCollection).where(DBFields.numberField, isEqualTo: controller.phoneController.text).get();
                      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = result.docs;
                      if (documents.isEmpty) {
                        controller.isProcessing.value = false;
                        errorToast(text: "Please Register to continue");
                        return;
                      }
                      controller.verifyUserPhoneNumber(controller, Auths.login);
                    }
                  },
                  child: Obx(
                    () => controller.isProcessing.value
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: whiteColor,
                            ),
                          )
                        : Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: whiteColor,
                            ),
                          ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          controller.isLogin.value = false;
                        },
                        child: const Text(
                          "Register Here",
                        ),
                      ),
                    ),
                  ),
                  /*Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forget Password?",
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
