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
              if (controller.dateError.value.isEmpty) {
                return const SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  controller.dateError.value,
                  style: const TextStyle(
                    color: Colors.red,
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

            const SizedBox(height: 16),

            const TextFieldCuti(
              label: "Sisa Cuti Tersedia",
              hint: "40",
              type: TextFieldType.disabled,
            ),

            const SizedBox(height: 24),

            ButtonLarge(
              label: "Kirim",
              onPressed: controller.submitCuti,
              isEnabled: true,
              colorButton: AppColor.info,
            ),
          ],
        ),
      ),
    );
  }
}
