import 'package:get/get.dart';
import 'package:hr_attendance/features/pengajuan%20cuti/presentation/controllers/cuti_controller.dart';

class CutiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CutiController());
  }
}
