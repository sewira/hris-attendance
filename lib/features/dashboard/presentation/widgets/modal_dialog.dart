import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/features/dashboard/presentation/widgets/modal_widget.dart';

class ModalDialog {
  static Future<void> show({
    int maxLength = 50,
    Function(String)? onSubmit,
  }) {
    return Get.dialog(
      Material(
        color: Colors.black.withOpacity(0.2),
        child: Center(
          child: ModalWidget(
            maxLength: maxLength,
            onSubmit: onSubmit,
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
