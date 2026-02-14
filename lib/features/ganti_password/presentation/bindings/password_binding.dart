import 'package:get/get.dart';
import 'package:hr_attendance/features/ganti_password/presentation/controllers/password_controller.dart';

class PasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PasswordController());
  }
}
