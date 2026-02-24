import 'package:get/get.dart';
import 'package:hr_attendance/features/login/domain/repositories/login_repository_impl.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/login_remote_datasource.dart';
import '../../domain/usecases/login_usecase.dart';
import '../controllers/login_controller.dart';
import '../../domain/repositories/login_repository.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DioClient>(() => DioClient.instance);

    Get.lazyPut<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(Get.find()),
    );

    Get.lazyPut<LoginRepository>(
      () => LoginRepositoryImpl(Get.find()),
    );

    Get.lazyPut(
      () => LoginUsecase(Get.find()),
    );

    Get.lazyPut(
      () => LoginController(Get.find()),
      fenix: true,
    );
  }
}