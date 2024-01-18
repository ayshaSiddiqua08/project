import 'package:Taayza/controllers/global_controller.dart';
import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/views/screens/auth/otp_screen.dart';
import 'package:Taayza/views/screens/student/home/main_screen.dart';
import 'package:Taayza/views/screens/teacher/home/teacher_main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';

enum Type { student, teacher }

enum Auths { login, registration }

class AuthController extends GetxController {
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final otpController = OtpFieldController();
  final parentsMailController = TextEditingController();
  final globalController = Get.find<GlobalController>();
  var obscure = false.obs;
  final selectedType = Type.student.obs;
  var isProcessing = false.obs;
  var isOTPProcessing = false.obs;
  var isLogin = true.obs;
  String initialText = '+880';
  /*Firebase Part*/
  final auth = FirebaseAuth.instance;
  var receivedID = '';
  final collection = FirebaseFirestore.instance.collection(DBCollections.userCollection);

  void verifyUserPhoneNumber(AuthController controller, Auths auths) {
    isProcessing.value = true;
    auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        isProcessing.value = false;
        logger.d("Here I am");
        //await auth.signInWithCredential(credential).then((value) => null); //Store firebase data in firestore
      },
      verificationFailed: (FirebaseAuthException e) {
        isProcessing.value = false;
        logger.d("Here I am");
        errorToast(text: e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        isProcessing.value = false;
        logger.d("Here I am");
        receivedID = verificationId;
        Get.to(() => OtpScreen(
              controller: controller,
              auth: auths,
            ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (auth.currentUser == null) {
          isProcessing.value = false;
          logger.d("Here I am");
          infoToast(text: "Timeout");
          Get.back();
        }
      },
    );
  }

  Future<void> verifyOTPCode(String otp, Auths auths) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: receivedID,
      smsCode: otp,
    );
    logger.d("Here I am");

    await auth.signInWithCredential(credential).then((value) async {
      if (auths == Auths.login) {
        final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance.collection(DBCollections.userCollection).where(DBFields.numberField, isEqualTo: phoneController.text).get();
        List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = result.docs;
        String type = documents.first.get("type").toString();
        successToast(text: "Successfully Logged In");
        globalController.user.value = value.user;
        if (type == Type.student.name) {
          globalController.isStudent.value = true;
          globalController.getProfileDetails();
          Get.offAll(StudentMainScreen());
        } else {
          globalController.isStudent.value = false;
          globalController.getProfileDetails();
          Get.offAll(TeacherMainScreen());
        }
      } else {
        collection.doc(value.user?.uid).set(
          {
            DBFields.nameField: nameController.text,
            DBFields.numberField: phoneController.text,
            DBFields.uidField: value.user?.uid,
            DBFields.joiningDateField: DateTime.now().millisecondsSinceEpoch,
            DBFields.typeField: selectedType.value.name,
            DBFields.parentsEmail: selectedType.value==Type.student?parentsMailController.text:'',
            DBFields.isAccountApproved: selectedType.value==Type.teacher ?false:true,
          },
          SetOptions(
            merge: true,
          ),
        ).then((values) {
          successToast(text: "Successfully Registered");
          globalController.user.value = value.user;
          if (selectedType.value == Type.student) {
            globalController.isStudent.value = true;
            globalController.getProfileDetails();
            Get.offAll(StudentMainScreen());
          } else {
            globalController.isStudent.value = false;
            globalController.getProfileDetails();
            Get.offAll(TeacherMainScreen());
          }
        });
      }
    });
    isOTPProcessing.value = false;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    phoneController.text = initialText;
  }
}
