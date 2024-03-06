import 'dart:io';

Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      // Internet connection is available
      return true;
    }
  } on SocketException catch (_) {
    // No internet connection
    return false;
  }
  return false;
}