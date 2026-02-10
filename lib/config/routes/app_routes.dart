import 'package:get/get.dart';
import 'package:hr_attendance/features/dashboard/presentation/bindings/dashboard_binding.dart';
import 'package:hr_attendance/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:hr_attendance/features/login/presentation/screens/login_screen.dart';
import 'package:hr_attendance/features/main/presentation/binding/main_binding.dart';
import 'package:hr_attendance/features/main/presentation/screen/main_screen.dart';
// import '../../features/attendance/presentation/bindings/attendance_binding.dart';
// import '../../features/attendance/presentation/screens/attendance_screen.dart';
import 'package:hr_attendance/features/login/presentation/bindings/login_binding.dart';

abstract class AppRoutes {
  static const login = '/login';
  // static const attendance = '/attendance';
  static const main = '/main';
  static const dashboard = '/dashboard';
}

final List<GetPage> appPages = [
  GetPage(
    name: AppRoutes.login,
    page: () => const LoginScreen(),
    binding: LoginBinding(),
    transition: Transition.fadeIn,
  ),
  // GetPage(
  //   name: AppRoutes.attendance,
  //   page: () => const AttendanceScreen(),
  //   binding: AttendanceBinding(),
  //   transition: Transition.fadeIn,
  // ),
  GetPage(
    name: AppRoutes.main, 
    page: () => MainScreen(),
    binding: MainBinding(),
  ),
  GetPage(
    name: AppRoutes.dashboard, 
    page: () => DashboardScreen(),
    binding: DashboardBinding(),
  ),
];
