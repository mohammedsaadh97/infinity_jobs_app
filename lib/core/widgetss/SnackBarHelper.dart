import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showFailedSnackBar(BuildContext context, String getInPutText, dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$getInPutText $error'),
      ),
    );
  }
  static void showWarningSnackBar(BuildContext context, String getInPutText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(getInPutText),
      ),
    );
  }
  static void showSucessSnackBar(BuildContext context, String getInPutText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(getInPutText),
      ),
    );
  }
}
