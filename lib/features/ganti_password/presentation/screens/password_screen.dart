import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/shared/widgets/text_fied.dart';
import 'package:hr_attendance/shared/widgets/button_widget.dart';
import '../controllers/password_controller.dart';

class PasswordScreen extends GetView<PasswordController> {
  const PasswordScreen({super.key});

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
                        {Get.back();}
                      },
                      icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                      color: AppColor.disableBorder,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Ganti Password",
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
                  label: "Password Lama",
                  hint: "Input Password",
                  controller: controller.latePasswordController,
                  type: TextFieldType.normal,
                ),
                const SizedBox(height: 16),

                TextFieldCuti(
                  label: "Password Baru",
                  hint: "Input Password",
                  controller: controller.newPasswordController,
                  type: TextFieldType.normal,
                ),

                Obx(() {
                  if (controller.newPasswordError.value == null) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      controller.newPasswordError.value!,
                      style: const TextStyle(color: AppColor.danger),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                TextFieldCuti(
                  label: "Konfirmasi Password",
                  hint: "Input Password",
                  controller: controller.confirmPasswordController,
                  type: TextFieldType.normal,
                ),

                Obx(() {
                  final msg = controller.confirmPasswordMessage.value;
                  if (msg == null) return const SizedBox();

                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      msg,
                      style: TextStyle(
                        color: controller.isConfirmValid.value
                            ? AppColor.info
                            : AppColor.danger,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                ButtonLarge(
                  label: "Kirim",
                  onPressed: controller.submit,
                  isEnabled: true,
                  colorButton: AppColor.info,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
