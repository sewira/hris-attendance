import 'package:get/get.dart';
import 'package:hr_attendance/features/ganti_email/data/datasource/email_remote_datasource.dart';
import 'package:hr_attendance/features/ganti_email/domain/repositories/email_repositories.dart';
import 'package:hr_attendance/features/ganti_email/domain/repositories/email_repositories_impl.dart';
import 'package:hr_attendance/features/ganti_email/domain/usecase/ganti_email_usecases.dart';
import 'package:hr_attendance/features/ganti_email/presentation/controllers/email_controller.dart';

class EmailBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<EmailRemoteDatasource>(
      () => EmailRemoteDatasource(),
    );

    Get.lazyPut<EmailRepository>(
      () => EmailRepositoryImpl(
        Get.find<EmailRemoteDatasource>(),
      ),
    );

    Get.lazyPut<GantiEmailUsecases>(
      () => GantiEmailUsecases(
        Get.find<EmailRepository>(),
      ),
    );

    Get.lazyPut<EmailController>(
      () => EmailController(
        Get.find<GantiEmailUsecases>(),
      ),
    );
  }
}