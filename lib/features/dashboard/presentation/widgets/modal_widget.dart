import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:hr_attendance/shared/widgets/button_widget.dart';

class ModalWidget extends StatelessWidget {
  final int maxLength;
  final Function(String)? onSubmit;

  ModalWidget({super.key, this.maxLength = 50, this.onSubmit});

  final DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.modalMaxLength = maxLength;

    return Container(
      width: 300,
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColor.disableBorder)),
            ),
            child: const Text(
              "Alasan pulang cepat",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColor.disableBorder,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              final textLength = controller.modalLength.value;
              String counterText;

              Color counterColor;

              if (controller.modalMessage.value.isNotEmpty) {
                counterText = controller.modalMessage.value;
                counterColor = AppColor.danger;
              } else if (controller.isOverLimit.value) {
                counterText = "karakter melebihi batas";
                counterColor = AppColor.danger;
              } else {
                counterText = "$textLength/$maxLength Karakter";
                counterColor = AppColor.disableBorder;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: controller.modalTextController,
                    maxLines: 3,
                    onChanged: controller.onModalChanged,
                    decoration: InputDecoration(
                      hintText: "Text",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColor.disableBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColor.disableBorder,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    counterText,
                    style: TextStyle(color: counterColor, fontSize: 12),
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonSmall(
                    label: "Batal",
                    onPressed: () {
                      controller.resetModal();
                      Get.back();
                    },
                    backgroundColor: AppColor.danger,
                  ),
                  const SizedBox(width: 12),
                  ButtonSmall(
                    label: "Kirim",
                    onPressed: () {
                      controller.validateSubmit();
                      if (!controller.isModalValid.value ||
                          controller.isOverLimit.value) {
                        return;
                      }

                      onSubmit?.call(controller.modalText);
                      controller.resetModal();
                      Get.back();
                    },
                    backgroundColor:
                        controller.isModalValid.value &&
                            !controller.isOverLimit.value
                        ? AppColor.info
                        : AppColor.disable,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
