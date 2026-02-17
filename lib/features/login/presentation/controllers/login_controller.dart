import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/core/utils/app_storage.dart';
import 'package:hr_attendance/shared/widgets/loading_dialog.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_assets.dart';
import '../../../../shared/widgets/alert_dialog.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginController extends GetxController {
  final LoginUsecase loginUsecase;

  LoginController(this.loginUsecase);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final isLoading = false.obs;
  final formError = RxnString();

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_validateRealtime);
    passwordController.addListener(_validateRealtime);
  }

  void _validateRealtime() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    formError.value = null;

    if (email.isNotEmpty && !GetUtils.isEmail(email)) {
      formError.value = "Format email tidak valid";
      return;
    }

    if (password.isNotEmpty && password.length < 8) {
      formError.value = "Password minimal 8 karakter";
      return;
    }
  }

  bool get isFormInvalid {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    return email.isEmpty ||
        password.isEmpty ||
        formError.value != null;
  }

  Future<void> onLoginPressed() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Alertdialog.show(
        animasi: AppAssets.lottieFailed,
        message: "Isi data terlebih dahulu",
      );
      return;
    }

    if (formError.value != null) {
      return;
    }

    try {
      isLoading.value = true;
      LoadingDialog.show();

      final user = await loginUsecase(email, password);

      LoadingDialog.close();

      await AppStorage.saveToken(user.token);
      await AppStorage.saveUserId(user.id.toString());

      Get.offAllNamed(AppRoutes.main);

    } catch (e) {
      LoadingDialog.close();
      formError.value = "Email atau password salah";
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
