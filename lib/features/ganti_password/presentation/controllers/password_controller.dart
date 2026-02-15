import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/routes/app_routes.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/shared/widgets/alert_dialog.dart';

class PasswordController extends GetxController {
  final latePasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final newPasswordError = RxnString();
  final confirmPasswordMessage = RxnString();
  final isConfirmValid = false.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();

    latePasswordController.addListener(validateAll);
    newPasswordController.addListener(validateAll);
    confirmPasswordController.addListener(validateAll);
  }

  void validateAll() {
    final oldPass = latePasswordController.text;
    final newPass = newPasswordController.text;
    final confirmPass = confirmPasswordController.text;

    if (oldPass.isNotEmpty && newPass.isNotEmpty && oldPass == newPass) {
      newPasswordError.value = "password tidak boleh sama dengan yang lama";
    } else {
      newPasswordError.value = null;
    }

    if (confirmPass.isEmpty) {
      confirmPasswordMessage.value = null;
      isConfirmValid.value = false;
    } else if (confirmPass == newPass) {
      confirmPasswordMessage.value = "password sesuai";
      isConfirmValid.value = true;
    } else {
      confirmPasswordMessage.value = "password tidak sesuai";
      isConfirmValid.value = false;
    }

    isFormValid.value =
        oldPass.isNotEmpty &&
        newPass.isNotEmpty &&
        confirmPass.isNotEmpty &&
        newPasswordError.value == null &&
        isConfirmValid.value;
  }

  void submit() {
    if (!isFormValid.value) {
      Alertdialog.show(
        animasi: AppAssets.lottieFailed,
        message: "Data tidak lengkap",
      );
      return;
    }

    Alertdialog.show(
      animasi: AppAssets.lottieSuccess,
      message: "Ganti password berhasil",
      showButton: false,
      replaceRoute: true,
      redirectRoute: AppRoutes.login,
    );
  }

  @override
  void onClose() {
    latePasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
