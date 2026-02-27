import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
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
                      onPressed: Get.back,
                      icon: const Icon(Icons.arrow_back_ios_new, size: 22),
                      color: AppColor.disableBorder,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Ganti Password",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.disableBorder,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Obx(
                  () => TextFieldCuti(
                    label: "Password Lama",
                    hint: "Input Password",
                    controller: controller.oldPasswordController,
                    obscureText: controller.isOldObscure.value,
                    suffixIcon: IconButton(
                      icon: HeroIcon(
                        controller.isOldObscure.value
                            ? HeroIcons.eyeSlash
                            : HeroIcons.eye,
                        color: AppColor.disableBorder,
                      ),
                      onPressed: controller.toggleOld,
                    ),
                  ),
                ),

                Obx(() {
                  final err = controller.oldPasswordError.value;
                  if (err == null) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      err,
                      style: const TextStyle(color: AppColor.danger),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                Obx(
                  () => TextFieldCuti(
                    label: "Password Baru",
                    hint: "Input Password",
                    controller: controller.newPasswordController,
                    obscureText: controller.isNewObscure.value,
                    suffixIcon: IconButton(
                      icon: HeroIcon(
                        controller.isNewObscure.value
                            ? HeroIcons.eyeSlash
                            : HeroIcons.eye,
                        color: AppColor.disableBorder,
                      ),
                      onPressed: controller.toggleNew,
                    ),
                  ),
                ),

                Obx(() {
                  final err = controller.newPasswordError.value;
                  if (err == null) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      err,
                      style: const TextStyle(color: AppColor.danger),
                    ),
                  );
                }),

                const SizedBox(height: 16),

                Obx(
                  () => TextFieldCuti(
                    label: "Konfirmasi Password",
                    hint: "Input Password",
                    controller: controller.confirmPasswordController,
                    obscureText: controller.isConfirmObscure.value,
                    suffixIcon: IconButton(
                      icon: HeroIcon(
                        controller.isConfirmObscure.value
                            ? HeroIcons.eyeSlash
                            : HeroIcons.eye,
                        color: AppColor.disableBorder,
                      ),
                      onPressed: controller.toggleConfirm,
                    ),
                  ),
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

                Obx(
                  () => ButtonLarge(
                    label: "Kirim",
                    onPressed: controller.submit,
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
