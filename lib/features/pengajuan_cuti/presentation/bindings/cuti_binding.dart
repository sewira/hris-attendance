import 'package:get/get.dart';
import 'package:hr_attendance/features/pengajuan_cuti/presentation/controllers/cuti_controller.dart';

class CutiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CutiController());
  }
}
