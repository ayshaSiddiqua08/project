import 'package:Taayza/db_paths/db_collections.dart';
import 'package:Taayza/db_paths/db_fields.dart';
import 'package:Taayza/global/helpers.dart';
import 'package:Taayza/views/components/custom_container.dart';
import 'package:Taayza/views/components/custom_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class EnrolledStudentsScreen extends StatelessWidget {
  final String courseId;
  final auth = FirebaseAuth.instance.currentUser;

  EnrolledStudentsScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Enrolled Students",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection(DBCollections.userCollection)
                    .doc(auth?.uid)
                    .collection(DBCollections.coursesCollection)
                    .doc(courseId)
                    .collection(DBCollections.studentsCollection)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      final lists = snapshot.data!.docs;
                      int income = 0;
                      for (var data in lists) {
                        income = income + int.parse((data[DBFields.coursePriceField]).toString());
                      }
                      logger.d(courseId);
                      return lists.isEmpty
                          ? const Text("No Students enrolled")
                          : Column(
                              children: [
                                Text(
                                  "Total Income: $income$taka",
                                  style: secondaryStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                ListView.builder(
                                  itemCount: lists.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final data = lists[index];
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5.h,
                                        horizontal: 10.w,
                                      ),
                                      child: CustomContainer(
                                        child: ListTile(
                                          title: Text(
                                            data[DBFields.studentName],
                                          ),
                                          subtitle: Text(
                                            data[DBFields.studentNumber],
                                          ),
                                          trailing: InkWell(
                                              onTap: (){
                                                logger.d(data[DBFields.parentsEmail]);
                                                sendMailToParents(data[DBFields.parentsEmail]);

                                              },
                                              child: Icon(Icons.attach_email_outlined)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })
          ],
        ),
      ),
    );
  }

  void sendMailToParents(data) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: data,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Student Progressive Report',
      }),
    );

    _launchUrl(emailLaunchUri);
  }
  Future<void> _launchUrl(Uri emailLaunchUri) async {

    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch $emailLaunchUri');
    }
  }
}
