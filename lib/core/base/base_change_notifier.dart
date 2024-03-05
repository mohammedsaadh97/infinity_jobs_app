import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:infinityjobs_app/core/remote/network/api_base_helper.dart';
import 'loading_state.dart';
abstract class BaseChangeNotifier with ChangeNotifier {
  String _countryBName = "";
  LoadingState _loadingState = LoadingState.Idle;
  ValueNotifier<String> showToast = ValueNotifier<String>('');
  ApiBaseHelper api = ApiBaseHelper();



  bool _isLoading = false;


  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _disposed = false;

  LoadingState get loadingState => this._loadingState;

  void setLoadingState(LoadingState loadingState) {
    _loadingState = loadingState;
    this.notify();
  }
  void notify() {
    notifyListeners();
  }

  void showToastMessage(String _stMessage) {
    showToast.value = '';
    showToast.value = _stMessage;
  }

  @override
  void notifyListeners() {
    //to avoid calling listeners after notifier is disposed
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  showSnackBar(context,String msg){
    var snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // showAlertDialog(context, msg);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

   void LogPrint(Object object) async {
    int defaultPrintLength = 1020;
    if (object == null || object.toString().length <= defaultPrintLength) {
    } else {
      String log = object.toString();
      int start = 0;
      int endIndex = defaultPrintLength;
      int logLength = log.length;
      int tmpLogLength = log.length;
      while (endIndex < logLength) {
        endIndex += defaultPrintLength;
        start += defaultPrintLength;
        tmpLogLength -= defaultPrintLength;
      }
      if (tmpLogLength > 0) {
      }
    }
  }

  showAlertDialog(context,msg) {
    return showDialog(
      context: context,
      barrierDismissible: true,
        // actionsAlignment: MainAxisAlignment.end
      builder: (ctx) => AlertDialog(
        title: const Text("Alert!"),
     /*   content: buildText(
          text: msg,
          //fontWeight: AppFontWeight.fontWeightMedium,
          fontSize: 14,
          fontColor: colorBlack,
          fontFamily: 'Montserrat',
        ),*/
        actions: [
          TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }
}
