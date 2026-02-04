import 'package:get/get.dart';
import '../../features/attendance/presentation/bindings/attendance_binding.dart';
import '../../features/attendance/presentation/screens/attendance_screen.dart';

abstract class AppRoutes {
  static const attendance = '/attendance';
}

final List<GetPage> appPages = [
  GetPage(
    name: AppRoutes.attendance,
    page: () => const AttendanceScreen(),
    binding: AttendanceBinding(),
    transition: Transition.fadeIn,
  ),
];
