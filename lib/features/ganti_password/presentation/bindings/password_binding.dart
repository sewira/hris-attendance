import 'package:get/get.dart';
import 'package:hr_attendance/features/ganti_password/data/datasource/password_remote_datasource.dart';
import 'package:hr_attendance/features/ganti_password/domain/repositories/password_repositories.dart';
import 'package:hr_attendance/features/ganti_password/domain/repositories/password_repositories_impl.dart';
import 'package:hr_attendance/features/ganti_password/domain/usecase/ganti_password_usecases.dart';
import 'package:hr_attendance/features/ganti_password/presentation/controllers/password_controller.dart';

class PasswordBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<PasswordRemoteDatasource>(
      () => PasswordRemoteDatasource(),
    );

    Get.lazyPut<PasswordRepositories>(
      () => PasswordRepositoriesImpl(
        Get.find<PasswordRemoteDatasource>(),
      ),
    );

    Get.lazyPut<GantiPasswordUsecases>(
      () => GantiPasswordUsecases(
        Get.find<PasswordRepositories>(),
      ),
    );

    Get.lazyPut<PasswordController>(
      () => PasswordController(
        Get.find<GantiPasswordUsecases>(),
      ),
    );
  }
}