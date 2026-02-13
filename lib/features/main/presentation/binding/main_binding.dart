import 'package:get/get.dart';
import 'package:hr_attendance/features/main/presentation/controller/main_controller.dart';
import 'package:hr_attendance/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:hr_attendance/features/pengajuan%20cuti/presentation/controllers/cuti_controller.dart';
import 'package:hr_attendance/features/profile/presentation/controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => CutiController());
    Get.lazyPut(() => ProfileController());
  }
}
