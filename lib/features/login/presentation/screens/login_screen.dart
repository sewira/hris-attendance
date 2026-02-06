import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:hr_attendance/features/login/presentation/controllers/login_controller.dart';
import 'package:hr_attendance/features/login/presentation/widgets/button_login.dart';
import 'package:hr_attendance/features/login/presentation/widgets/text_field_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.find<LoginController>();

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColor.netral1,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColor.netral1,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width < 360 ? 24 : 50),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.14),
                  _logo(),
                  const SizedBox(height: 20),
                  _title(),
                  SizedBox(height: height * 0.08),
                  _textForm(context, controller),
                  const SizedBox(height: 30),
                  _buttonLogin(controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _logo() {
  return Image.asset(
    AppAssets.logo,
    width: 160,
    height: 157,
    fit: BoxFit.contain,
  );
}

Widget _title() {
  return Column(
    children: const [
      Text(
        "Log In to your account",
        style: TextStyle(
          fontFamily: "Inter",
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColor.netral2,
        ),
      ),
      SizedBox(height: 5),
      Text(
        "Welcome back",
        style: TextStyle(
          fontFamily: "Inter",
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColor.netral2,
        ),
      ),
    ],
  );
}

Widget _textForm(BuildContext context, LoginController controller) {
  final width = MediaQuery.of(context).size.width;

  return Column(
    children: [
      SizedBox(
        width: width * 0.7,
        child: TextFieldLogin(
          hint: "Email",
          controller: controller.emailController,
        ),
      ),
      const SizedBox(height: 30),
      SizedBox(
        width: width * 0.7,
        child: Obx(
          () => TextFieldPassword(
            hint: "Password",
            controller: controller.passwordController,
            obscureText: controller.obscurePassword.value,
            onToggle: controller.togglePassword,
          ),
        ),
      ),
    ],
  );
}

Widget _buttonLogin(LoginController controller) {
  return Obx(() {
    return ButtonLogin(
      label: "Login",
      isEnabled: controller.isFilled.value,
      onPressed: () {},
    );
  });
}
