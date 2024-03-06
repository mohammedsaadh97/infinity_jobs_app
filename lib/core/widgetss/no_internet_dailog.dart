import 'package:flutter/material.dart';
import 'package:infinityjobs_app/utilities/color_constant.dart';

class DialogUtils {
  static Future<void> showConnectionDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('No Internet Connection'),
        content: Text('Please connect to mobile data or WiFi to continue.'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.AppBluecolor,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding for the button size
            ),
            child: const Text(
              'Ok',
              style: TextStyle(
                color: ColorConstant.whiteshade,
                fontSize: 12, // Adjust the font size to make the button smaller
              ),
            ),
          )
        ],
      ),
    );
  }
}
