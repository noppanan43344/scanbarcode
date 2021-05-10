import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog {
  final BuildContext context;
  final String title;
  final String message;
  CustomDialog({
    this.context,
    this.title,
    this.message,
  });
  void showLoadingDialog() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.loading,
      // text: title,
      backgroundColor: Colors.white,
      barrierDismissible: false,
      loopAnimation: true,
    );
  }

  void showWarningDialog(title) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      title: title,
      backgroundColor: Colors.white,
      barrierDismissible: false,
      loopAnimation: true,
    );
  }

  void showErrorDialog(title) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: title,
      backgroundColor: Colors.white,
      barrierDismissible: false,
      loopAnimation: true,
    );
  }

  void showSuccessDialog(title) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      title: title,
      backgroundColor: Colors.white,
      barrierDismissible: false,
      loopAnimation: true,
    );
  }

  void dismiss() {
    if (context != null) {
      Navigator.pop(context);
    }
  }
}
