import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_button.dart';
import 'custom_styles.dart';


class RoundedDialog extends StatelessWidget {
  const RoundedDialog({super.key});

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
                'https://lottie.host/82236da9-0a49-44a2-9bf0-1c7b05e74a84/PPviwbJynQ.json',),
            ),
            AutoSizeText(
              "Currently, your account is not approved!"
              ,style: blackStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold
            ),

            ),
            Align(
              alignment: Alignment.bottomRight,
              child: CustomButton(
                onPressed: () {
                  //  controller.pickImage();
                  sendMailForAdminSupport();


                },
                child: Row(
                  children: [
                    AutoSizeText(
                      "Get Support via mail",style: whiteStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w300
                    ),
                    ),
                    SizedBox(width: 10.w,),
                    Icon(Icons.mail_outline,color: Colors.white.withOpacity(0.9),)
                  ],
                ),
              ),
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
