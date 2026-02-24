import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/shared/widgets/button_widget.dart';

class AlertDialogCustom extends StatelessWidget {
  final String description;
  final String lottie;
  final double width;
  final double height;
  final bool isQuestion;
  final bool showButton;

  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  final String confirmLabel;
  final String cancelLabel;

  const AlertDialogCustom({
    super.key,
    required this.description,
    required this.lottie,
    this.width = 257,
    this.height = 257,
    this.isQuestion = false,
    this.showButton = true,
    this.onConfirm,
    this.onCancel,
    this.confirmLabel = "Lanjut",
    this.cancelLabel = "Tutup",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.netral1,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Lottie.asset(lottie, width: 97, height: 97),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Inter",
                fontSize: 20,
                color: AppColor.netral2,
              ),
            ),
          ),

          if (showButton)
            isQuestion
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonSmall(
                        label: cancelLabel,
                        backgroundColor: AppColor.danger,
                        onPressed: onCancel ?? () => Get.back(),
                      ),
                      const SizedBox(width: 10),
                      ButtonSmall(
                        label: confirmLabel,
                        backgroundColor: AppColor.info,
                        onPressed: onConfirm ?? () {},
                      ),
                    ],
                  )
                : ButtonSmall(
                    label: cancelLabel,
                    backgroundColor: AppColor.danger,
                    onPressed: onCancel ?? () => Get.back(),
                  ),
        ],
      ),
    );
  }
}