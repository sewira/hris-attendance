import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/features/main/presentation/controller/main_controller.dart';
import 'package:hr_attendance/shared/widgets/alert_widget.dart';

class Alertdialog {
  static void show({
    required String animasi,
    required String message,
    bool isQuestion = false,
    bool showButton = true,
    Duration? autoCloseDuration,
    VoidCallback? onConfirm,
    String? redirectRoute,
    bool replaceRoute = false,
    int? changeMainIndex,
  }) {
    Get.dialog(
      Material(
        color: AppColor.netral2.withOpacity(0.2),
        child: Center(
          child: AlertDialogCustom(
            lottie: animasi,
            description: message,
            isQuestion: isQuestion,
            showButton: showButton,
            onConfirm: onConfirm,
            width: isQuestion ? 300 : 257,
            height: isQuestion ? 270 : 257,
          ),
        ),
      ),
      barrierDismissible: false,
    );

    final duration = autoCloseDuration ?? const Duration(seconds: 4);

    if (!showButton) {
      Future.delayed(duration, () {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        if (changeMainIndex != null && Get.isRegistered<MainController>()) {
          final mainController = Get.find<MainController>();
          mainController.changeIndex(changeMainIndex);
        }

        if (redirectRoute != null) {
          if (replaceRoute) {
            Get.offAllNamed(redirectRoute);
          } else {
            Get.toNamed(redirectRoute);
          }
        }
      });
    }
  }

  static void close() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
