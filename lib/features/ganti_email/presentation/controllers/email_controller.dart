import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/routes/app_routes.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/features/ganti_email/data/models/email_model.dart';
import 'package:hr_attendance/features/ganti_email/domain/usecase/ganti_email_usecases.dart';
import 'package:hr_attendance/features/profile/presentation/controllers/profile_controller.dart';
import 'package:hr_attendance/shared/widgets/alert_dialog.dart';
import 'package:hr_attendance/shared/widgets/loading_dialog.dart';

class EmailController extends GetxController {
  final GantiEmailUsecases changeEmailUsecase;

  EmailController(this.changeEmailUsecase);

  final oldEmailController = TextEditingController();
  final newEmailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final oldEmailError = "".obs;
  final newEmailError = "".obs;

  final isFormValid = false.obs;
  final isLoading = false.obs;

  ProfileController get profileController => Get.find();

  @override
  void onInit() {
    super.onInit();
    oldEmailController.addListener(validateAll);
    newEmailController.addListener(validateAll);
  }

  void validateAll() {
    final oldEmail = oldEmailController.text.trim();
    final newEmail = newEmailController.text.trim();
    final currentEmail = profileController.profile.value?.email ?? "";

    oldEmailError.value = "";
    newEmailError.value = "";

    if (oldEmail.isNotEmpty && oldEmail != currentEmail) {
      oldEmailError.value = "email lama salah";
    }
    if (newEmail.isNotEmpty && !GetUtils.isEmail(newEmail)) {
      newEmailError.value = "format email tidak valid";
    }
    if (oldEmail.isNotEmpty && newEmail.isNotEmpty && oldEmail == newEmail) {
      newEmailError.value = "email baru tidak boleh sama dengan email lama";
    }

    isFormValid.value =
        oldEmail.isNotEmpty &&
        newEmail.isNotEmpty &&
        oldEmailError.value.isEmpty &&
        newEmailError.value.isEmpty &&
        !isLoading.value;
  }

  void confirmSubmit() {
    validateAll();

    if (oldEmailController.text.trim().isEmpty ||
        newEmailController.text.trim().isEmpty) {
      Alertdialog.show(
        animasi: AppAssets.lottieFailed,
        message: "Data tidak lengkap",
      );
      return;
    }

    if (oldEmailError.value.isNotEmpty || newEmailError.value.isNotEmpty) {
      return;
    }

    Alertdialog.show(
      animasi: AppAssets.lottieQuestion,
      isQuestion: true,
      message: "Yakin ingin mengganti email?",
      cancelLabel: "Batal",
      onConfirm: submit,
    );
  }

  Future<void> submit() async {
    try {
      Alertdialog.close();

      isLoading.value = true;
      LoadingDialog.show();

      final model = EmailModel(email: newEmailController.text.trim());

      await changeEmailUsecase(model);
      await profileController.fetchProfile();

      LoadingDialog.close();

      oldEmailController.clear();
      newEmailController.clear();
      oldEmailError.value = "";
      newEmailError.value = "";
      isFormValid.value = false;

      Alertdialog.show(
        animasi: AppAssets.lottieSuccess,
        message: "Email berhasil diubah",
        showButton: false,
        redirectRoute: AppRoutes.main,
        changeMainIndex: 2,
      );
    } catch (_) {
      LoadingDialog.close();

      Alertdialog.show(
        animasi: AppAssets.lottieFailed,
        message: "Ganti email gagal",
      );
    } finally {
      isLoading.value = false;
      validateAll();
    }
  }

  @override
  void onClose() {
    oldEmailController.dispose();
    newEmailController.dispose();
    super.onClose();
  }
}
