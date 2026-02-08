import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import '../organism/alert_widget.dart';

class AlertService {
  static void show({
    required String animasi,
    required String message,
    bool isQuestion = false,
    VoidCallback? onConfirm,
  }) {
    Get.dialog(
      Material(
        color: AppColor.netral2.withOpacity(0.2),
        child: Center(
          child: AlertDialogCustom(
            lottie: animasi,
            description: message,
            isQuestion: isQuestion,
            onConfirm: onConfirm,
            width: isQuestion ? 300 : 257,
            height: isQuestion ? 270 : 257,
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
