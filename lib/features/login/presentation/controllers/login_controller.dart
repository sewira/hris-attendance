import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {

  var obscurePassword = true.obs;
  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isFilled = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    emailController.addListener(_checkFilled);
    passwordController.addListener(_checkFilled);
  }

  void _checkFilled() {
    isFilled.value =
        emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
