import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/shared/widgets/text_fied.dart';
import 'package:hr_attendance/shared/widgets/button_widget.dart';
import '../controllers/email_controller.dart';

class EmailScreen extends GetView<EmailController> {
  const EmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.netral1,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        {
                          Get.back();
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                      color: AppColor.disableBorder,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Ganti Email",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.disableBorder,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                TextFieldCuti(
                  label: "Email Lama",
                  hint: "Input Email",
                  controller: controller.oldEmailController,
                  type: TextFieldType.normal,
                ),

                Obx(
                  () => controller.oldEmailError.value.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            controller.oldEmailError.value,
                            style: const TextStyle(color: AppColor.danger),
                          ),
                        ),
                ),
                const SizedBox(height: 16),

                TextFieldCuti(
                  label: "Email Baru",
                  hint: "Input Email",
                  controller: controller.newEmailController,
                  type: TextFieldType.normal,
                ),

                Obx(
                  () => controller.newEmailError.value.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            controller.newEmailError.value,
                            style: const TextStyle(color: AppColor.danger),
                          ),
                        ),
                ),

                const SizedBox(height: 24),

                Obx(
                  () => ButtonLarge(
                    label: controller.isLoading.value ? "Loading..." : "Kirim",
                    onPressed: controller.confirmSubmit, 
                    isEnabled: controller.isFormValid.value,
                    colorButton: AppColor.info,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
