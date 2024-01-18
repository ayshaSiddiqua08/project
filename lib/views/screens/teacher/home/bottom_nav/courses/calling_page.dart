
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'dart:math' as math;

import '../../../../../../controllers/teacher_controller.dart';
import '../../../../../../db_paths/db_collections.dart';
import '../../../../../../db_paths/db_fields.dart';
import '../../../../../../global/app_constants.dart';
import '../../../../../../global/helpers.dart';

final String userId = math.Random().nextInt(10000).toString() ;

class CallPage extends StatelessWidget {
  final controller = Get.put(TeacherController());
  final String callingId ;
  final String courseId ;
  final String? userType ;
   CallPage({Key? key , required this.callingId, required this.courseId, this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCollection = FirebaseFirestore.instance.collection(DBCollections.userCollection);
    final user = FirebaseFirestore.instance.collection(DBCollections.userCollection);
    final courseCollection = FirebaseFirestore.instance.collection(DBCollections.coursesCollection);

    DocumentReference docRef=userCollection.doc(controller.user?.uid).collection(DBCollections.coursesCollection).doc(courseId);
    DocumentReference docRefCourse=courseCollection.doc(courseId);

    return  SafeArea(
        child: ZegoUIKitPrebuiltCall(
          appID: appId,
          appSign: appSign,
          userID: userId ,
          userName: 'username_$userId' ,
          callID: callingId ,
          config: ZegoUIKitPrebuiltCallConfig.groupVideoCall(),
          onDispose: (){
            print('Call end');
            if(userType=='teacher'){
              docRefCourse.update({
                DBFields.isStreaming: false
              }).then((_) {
                logger.d('Document successfully updated');
                // Get.to(() => CallPage(callingId: callId.trim(),));
                Get.back();
                docRef.update({
                  DBFields.isStreaming: false
                }).then((_) {
                  logger.d('Document successfully updated');

                }).catchError((error) {
                  logger.e('Error updating document: $error');
                });

              }).catchError((error) {
                logger.e('Error updating document: $error');
              });
            }



          },
        )
    );
  }
}