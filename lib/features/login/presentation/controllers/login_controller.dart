import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/shared/widgets/alert_dialog.dart';

class LoginController extends GetxController {

  var obscurePassword = true.obs;
  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isFilled = false.obs;
  final showPasswordError = false.obs;
  final passwordError = RxnString();

  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_checkFilled);
    passwordController.addListener(_checkFilled);
  }

  void _checkFilled() {
  isFilled.value = emailController.text.isNotEmpty;

  if (passwordController.text.isNotEmpty) {
    passwordError.value = null;
  }
}


  void onLoginPressed() {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (email.isEmpty) {  
    Alertdialog.show(animasi: AppAssets.lottieFailed, message: 'Input data terlebih dahulu',);
    return;
  }

  if (password.isEmpty) {
    passwordError.value = "Isi data dengan lengkap";
    return;
  }
  passwordError.value = null;

}
}


