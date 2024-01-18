import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_button.dart';
import 'custom_styles.dart';


class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding:
        EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 10.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 150.h,width: 150.w,
              child: Lottie.network(
                'https://lottie.host/c615f10a-b8f1-451b-b615-be4b6ba20ef2/jR8ESrX97S.json',),
            ),
            AutoSizeText(
              "Are you sure you want to exit it?"
              ,style: blackStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold
            ),

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButton(
                  onPressed: () {
                    SystemNavigator.pop();



                  },
                  child:AutoSizeText(
                    "Yes",style: whiteStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700
                  )),
                ),

                CustomButton(
                  backgroundColor: Colors.red.withOpacity(0.7),

                  onPressed: () {
                    //  controller.pickImage();
                     Get.back();


                  },
                  child:AutoSizeText(
                    "No",style: redStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void sendMailForAdminSupport() {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'taayzag@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Account Approved Support',
      }),
    );
    Get.back();
    _launchUrl(emailLaunchUri);
  }
  Future<void> _launchUrl(Uri emailLaunchUri) async {

    if (!await launchUrl(emailLaunchUri)) {
      throw Exception('Could not launch $emailLaunchUri');
    }
  }
}