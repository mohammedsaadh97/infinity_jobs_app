import 'dart:io';
import 'package:flutter/material.dart';
import 'package:infinityjobs_app/core/config/config.dart';

class AppService {

  Future<bool?> checkInternet() async {
    bool? internet;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        internet = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      internet = false;
    }
    return internet;
  }
  //
  // Future openLink(context, String url) async {
  //   final uri = Uri.parse(url);
  //   if (await urlLauncher.canLaunchUrl(uri)) {
  //     urlLauncher.launchUrl(uri);
  //   } else {
  //     openToast1(context, "Can't launch the url");
  //   }
  // }


  //
  // Future openEmailSupport(context) async {
  //
  //   final Uri uri = Uri(
  //     scheme: 'mailto',
  //     path: Config().supportEmail,
  //     query: 'subject=Inquiry from ${Config().appName} App - Job Seeker&body=Hello ${Config().appName} Team,%0D%0A%0D%0AI have the following inquiry or requirement:%0D%0A%0D%0A',
  //   );
  //
  //   if (await urlLauncher.canLaunchUrl(uri)) {
  //     await urlLauncher.launchUrl(uri);
  //   } else {
  //     openToast1(context, "Can't open the email app");
  //   }
  // }




  //
  //
  // Future launchAppReview(context) async {
  //   await LaunchReview.launch(
  //       androidAppId: sb.packageName,
  //       iOSAppId: Config().iOSAppId,
  //       writeReview: false);
  //   if (Platform.isIOS) {
  //     if (Config().iOSAppId == '000000') {
  //       openToast1(context, 'The iOS version is not available on the AppStore yet');
  //     }
  //   }
  // }

}