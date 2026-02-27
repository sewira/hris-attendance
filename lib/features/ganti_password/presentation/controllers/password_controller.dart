import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:hr_attendance/config/routes/app_routes.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/core/utils/app_storage.dart';
import 'package:hr_attendance/features/ganti_password/data/models/password_model.dart';
import 'package:hr_attendance/features/ganti_password/domain/usecase/ganti_password_usecases.dart';
import 'package:hr_attendance/shared/widgets/alert_dialog.dart';
import 'package:hr_attendance/shared/widgets/loading_dialog.dart';

class PasswordController extends GetxController {
  final GantiPasswordUsecases usecases;

  PasswordController(this.usecases);

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final oldPasswordError = RxnString();
  final newPasswordError = RxnString();
  final confirmPasswordMessage = RxnString();

  final isConfirmValid = false.obs;
  final isFormValid = false.obs;

  final isOldObscure = true.obs;
  final isNewObscure = true.obs;
  final isConfirmObscure = true.obs;

  void toggleOld() => isOldObscure.toggle();
  void toggleNew() => isNewObscure.toggle();
  void toggleConfirm() => isConfirmObscure.toggle();

  @override
  void onInit() {
    super.onInit();
    oldPasswordController.addListener(validateAll);
    newPasswordController.addListener(validateAll);
    confirmPasswordController.addListener(validateAll);
  }

  void validateAll() {
    final oldPass = oldPasswordController.text;
    final newPass = newPasswordController.text;
    final confirmPass = confirmPasswordController.text;

    if (oldPasswordError.value != null) {
      oldPasswordError.value = null;
    }

    if (newPass.isEmpty) {
      newPasswordError.value = null;
    } else if (newPass.length < 8) {
      newPasswordError.value = "Password minimal 8 karakter";
    } else if (oldPass.isNotEmpty && newPass == oldPass) {
      newPasswordError.value = "Password tidak boleh sama dengan yang lama";
    } else {
      newPasswordError.value = null;
    }

    if (confirmPass.isEmpty) {
      confirmPasswordMessage.value = null;
      isConfirmValid.value = false;
    } else if (confirmPass == newPass) {
      confirmPasswordMessage.value = "Password sesuai";
      isConfirmValid.value = true;
    } else {
      confirmPasswordMessage.value = "Password tidak sesuai";
      isConfirmValid.value = false;
    }

    isFormValid.value =
        oldPass.isNotEmpty &&
        newPass.isNotEmpty &&
        confirmPass.isNotEmpty &&
        newPasswordError.value == null &&
        isConfirmValid.value;
  }

  Future<void> submit() async {
    final oldPass = oldPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Alertdialog.show(
        animasi: AppAssets.lottieFailed,
        message: "Data tidak lengkap",
      );
      return; 
    }

    if (!isFormValid.value) {
      return;
    }

    try {
      LoadingDialog.show();

      final request = PasswordModel(
        oldPassword: oldPass,
        newPassword: newPass,
        confirmPassword: confirmPass,
      );

      await usecases(request);

      LoadingDialog.close();

      await AppStorage.logout();

      Alertdialog.show(
        animasi: AppAssets.lottieSuccess,
        message: "Ganti password berhasil",
        showButton: false,
        replaceRoute: true,
        redirectRoute: AppRoutes.login,
      );
    } on DioException catch (e) {
      LoadingDialog.close();

      final message = e.response?.data["message"];

      if (message == "password lama salah") {
        oldPasswordError.value = "Password lama salah";
      } else {
        Alertdialog.show(
          animasi: AppAssets.lottieFailed,
          message: "Terjadi kesalahan",
        );
      }
    } catch (_) {
      LoadingDialog.close();

      Alertdialog.show(
        animasi: AppAssets.lottieFailed,
        message: "Terjadi kesalahan",
      );
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
