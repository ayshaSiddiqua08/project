import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/views/components/custom_container.dart';
import 'package:Taayza/views/components/custom_styles.dart';
import 'package:Taayza/views/components/rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllRatingScreen extends StatelessWidget {
  final String? courseId;

  const AllRatingScreen({super.key, this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Ratings",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection(DBCollections.coursesCollection).doc(courseId).collection(DBCollections.ratingsCollection).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapShot) {
                if (snapShot.hasData) {
                  if (snapShot.data != null) {
                    var ratingsSnap = snapShot.data!.docs;
                    return ListView.builder(
                        itemCount: ratingsSnap.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final data = ratingsSnap[index];
                          return CustomContainer(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                            ),
                            margin: EdgeInsets.only(
                              bottom: 10.h,
                              left: 10.w,
                              right: 10.w,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(
                                      Icons.person,
                                    ),
                                  ),
                                  title: Text(
                                    data[DBFields.studentName],
                                    style: tealStyle(),
                                  ),
                                  trailing: Visibility(
                                    visible: FirebaseAuth.instance.currentUser?.uid==data[DBFields.uidField],
                                    child: const Chip(
                                      label: Text(
                                        'Your Review',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.w),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            RatingBarWidget(
                                              rating: data[DBFields.ratingField],
                                            ),
                                            Text('(${data[DBFields.ratingField].toString()})'),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data[DBFields.feedbackField],
                                          textAlign: TextAlign.start,
                                          style: tealStyle(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
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
    );
  }
}
