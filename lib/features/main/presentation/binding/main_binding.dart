import 'package:get/get.dart';
import 'package:hr_attendance/features/dashboard/data/datasources/dashboard_remote_datasource.dart.dart';
import 'package:hr_attendance/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:hr_attendance/features/dashboard/domain/repositories/dashboard_repository_impl.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/get_attendance_history_usecase.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/get_leave_history.dart';
import 'package:hr_attendance/features/main/presentation/controller/main_controller.dart';
import 'package:hr_attendance/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:hr_attendance/features/pengajuan_cuti/presentation/controllers/cuti_controller.dart';
import 'package:hr_attendance/features/profile/presentation/controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => MainController());

    // =========================
    // DASHBOARD DEPENDENCY
    // =========================

    Get.lazyPut<DashboardRemoteDatasource>(
      () => DashboardRemoteDatasource(),
    );

    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(Get.find()),
    );

    Get.lazyPut<GetAttendanceHistoryUsecase>(
      () => GetAttendanceHistoryUsecase(Get.find()),
    );

    Get.lazyPut<GetLeaveHistoryUsecase>(
      () => GetLeaveHistoryUsecase(Get.find()),
    );

    Get.lazyPut<DashboardController>(
      () => DashboardController(
        Get.find<GetAttendanceHistoryUsecase>(),
        Get.find<GetLeaveHistoryUsecase>(),
      ),
      fenix: true,
    );

    // =========================

    Get.lazyPut(() => CutiController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
  }
}