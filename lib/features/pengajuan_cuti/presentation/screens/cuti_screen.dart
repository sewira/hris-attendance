import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/shared/widgets/text_fied.dart';
import 'package:hr_attendance/shared/widgets/button_widget.dart';
import '../controllers/cuti_controller.dart';

class CutiScreen extends GetView<CutiController> {
  const CutiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pengajuan Cuti",
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.disableBorder,
              ),
            ),
            const SizedBox(height: 20),

            TextFieldCuti(
              label: "Tanggal Mulai",
              hint: "dd/mm/yyyy",
              requiredLabel: true,
              type: TextFieldType.date,
              controller: controller.startDateController,
              onTap: () => controller.pickStartDate(context),
            ),
            Obx(() {
              if (controller.startDateError.value.isEmpty) {
                return const SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  controller.startDateError.value,
                  style: const TextStyle(
                    color: AppColor.danger,
                    fontSize: 12,
                    fontFamily: "Inter",
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            TextFieldCuti(
              label: "Tanggal Selesai",
              hint: "dd/mm/yyyy",
              requiredLabel: true,
              type: TextFieldType.date,
              controller: controller.endDateController,
              onTap: () => controller.pickEndDate(context),
            ),
            Obx(() {
              if (controller.endDateError.value.isEmpty) {
                return const SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  controller.endDateError.value,
                  style: const TextStyle(
                    color: AppColor.danger,
                    fontSize: 12,
                    fontFamily: "Inter",
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            TextFieldCuti(
              label: "Alasan Cuti",
              hint: "",
              controller: controller.reasonController,
              type: TextFieldType.normal,
            ),
            Obx(() {
              if (controller.reasonError.value.isEmpty) {
                return const SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  controller.reasonError.value,
                  style: const TextStyle(
                    color: AppColor.danger,
                    fontSize: 12,
                    fontFamily: "Inter",
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),

            Obx(() {
              return TextFieldCuti(
                label: "Sisa Cuti Tersedia",
                hint: controller.leaveBalance.toString(),
                type: TextFieldType.disabled,
              );
            }),
            Obx(() {
              if (controller.leaveError.value.isEmpty) {
                return const SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  controller.leaveError.value,
                  style: const TextStyle(
                    color: AppColor.danger,
                    fontSize: 12,
                    fontFamily: "Inter",
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            Obx(() {
              return TextFieldCuti(
                label: "Durasi",
                hint: controller.durationDays.value == 0
                    ? "0 Hari"
                    : "${controller.durationDays.value} Hari",
                type: TextFieldType.disabled,
              );
            }),
            const SizedBox(height: 24),

            Obx(
              () => ButtonLarge(
                label: "Kirim",
                onPressed: controller.submitCuti,
                isEnabled: true,
                colorButton: controller.isFormReady.value
                    ? AppColor.info
                    : AppColor.disable,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
