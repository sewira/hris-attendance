import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/shared/widgets/loading_widget.dart';

class LoadingDialog {
  static void show({
    String message = "Mohon Menunggu",
  }) {
    Get.dialog(
      Material(
        color: AppColor.netral2.withOpacity(0.2),
        child: Center(
          child: LoadingDialogCustom(
            message: message,
          ),
        ),
      ),
      barrierDismissible: false, 
    );
  }

  static void close() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
