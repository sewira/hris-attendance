import 'package:get/get.dart';
import 'package:hr_attendance/features/ganti_email/presentation/bindings/email_binding.dart';
import 'package:hr_attendance/features/ganti_email/presentation/screens/email_screen.dart';
import 'package:hr_attendance/features/ganti_password/presentation/bindings/password_binding.dart';
import 'package:hr_attendance/features/ganti_password/presentation/screens/password_screen.dart';
import 'package:hr_attendance/features/login/presentation/screens/login_screen.dart';
import 'package:hr_attendance/features/main/presentation/binding/main_binding.dart';
import 'package:hr_attendance/features/main/presentation/screen/main_screen.dart';
import 'package:hr_attendance/features/login/presentation/bindings/login_binding.dart';

abstract class AppRoutes {
  static const login = '/login';
  static const main = '/main';
  static const password = '/password';
  static const email = '/email';
}

final List<GetPage> appPages = [
  GetPage(
    name: AppRoutes.login,
    page: () => const LoginScreen(),
    binding: LoginBinding(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.main, 
    page: () => MainScreen(),
    binding: MainBinding(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.password, 
    page: () => PasswordScreen(),
    binding: PasswordBinding(),
    transition: Transition.fadeIn,
  ),
  GetPage(
    name: AppRoutes.email, 
    page: () => EmailScreen(),
    binding: EmailBinding(),
    transition: Transition.fadeIn,
  ),
];
