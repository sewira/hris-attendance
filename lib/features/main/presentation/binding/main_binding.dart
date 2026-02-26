import 'package:get/get.dart';
import 'package:hr_attendance/features/attendance_history_shared/domain/repositories/attendance_history_repo_impl.dart';
import 'package:hr_attendance/features/attendance_history_shared/domain/usecases/get_all_attendance.dart';
import 'package:hr_attendance/features/attendance_history_shared/domain/usecases/get_attendance_history_month.dart';
import 'package:hr_attendance/features/dashboard/data/datasources/dashboard_remote_datasource.dart.dart';
import 'package:hr_attendance/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:hr_attendance/features/dashboard/domain/repositories/dashboard_repository_impl.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/check_location_usecase.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/clock_in_usecase.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/clock_out_usecase.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/get_leave_history.dart';
import 'package:hr_attendance/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:hr_attendance/features/main/presentation/controller/main_controller.dart';
import 'package:hr_attendance/features/pengajuan_cuti/data/datasources/cuti_remote_datasource.dart';
import 'package:hr_attendance/features/pengajuan_cuti/domain/repositories/cuti_repositories.dart';
import 'package:hr_attendance/features/pengajuan_cuti/domain/repositories/cuti_repositories_impl.dart';
import 'package:hr_attendance/features/pengajuan_cuti/domain/usecases/submit_cuti_usecase.dart';
import 'package:hr_attendance/features/pengajuan_cuti/presentation/controllers/cuti_controller.dart';
import 'package:hr_attendance/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:hr_attendance/features/profile/domain/repositories/profile_repositories.dart';
import 'package:hr_attendance/features/profile/domain/repositories/profile_repositories_impl.dart';
import 'package:hr_attendance/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:hr_attendance/features/profile/presentation/controllers/profile_controller.dart';
import 'package:hr_attendance/features/attendance_history_shared/data/datasource/attendance_history_remote.dart';
import 'package:hr_attendance/features/attendance_history_shared/domain/repositories/attendance_history_repo.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());

    //attendance shared
    Get.lazyPut<AttendanceHistoryRemote>(() => AttendanceHistoryRemote());
    Get.lazyPut<AttendanceHistoryRepo>(
      () => AttendanceHistoryRepoImpl(Get.find()),
    );
    Get.lazyPut<GetAttendanceHistoryMonthUsecase>(
      () => GetAttendanceHistoryMonthUsecase(Get.find()),
    );
    Get.lazyPut<GetAllAttendanceHistoryUsecase>(
      () => GetAllAttendanceHistoryUsecase(Get.find()),
    );

    //dashboard
    Get.lazyPut<DashboardRemoteDatasource>(() => DashboardRemoteDatasource());
    Get.lazyPut<DashboardRepository>(() => DashboardRepositoryImpl(Get.find()));
    Get.lazyPut<GetLeaveHistoryUsecase>(
      () => GetLeaveHistoryUsecase(Get.find()),
    );
    Get.lazyPut<ClockInUsecase>(
      () => ClockInUsecase(Get.find()),
    );
    Get.lazyPut<CheckLocationUsecase>(
      () => CheckLocationUsecase(Get.find()),
    );
    Get.lazyPut<ClockOutUsecase>(
      () => ClockOutUsecase(Get.find()),
    );
    Get.lazyPut<DashboardController>(
      () => DashboardController(
        Get.find<GetAttendanceHistoryMonthUsecase>(),
        Get.find<GetLeaveHistoryUsecase>(),
        Get.find<ClockInUsecase>(),
        Get.find<ClockOutUsecase>(),
        Get.find<CheckLocationUsecase>(),
      ),
      fenix: true,
    );

    //cuti
    Get.lazyPut<CutiRemoteDatasource>(() => CutiRemoteDatasource());
    Get.lazyPut<CutiRepository>(() => CutiRepositoryImpl(Get.find()));
    Get.lazyPut<SubmitCutiUsecase>(() => SubmitCutiUsecase(Get.find()));
    Get.lazyPut<CutiController>(
      () => CutiController(
        Get.find<SubmitCutiUsecase>(),
        Get.find<GetLeaveHistoryUsecase>(),
      ),
      fenix: true,
    );

    //profile
    Get.lazyPut<ProfileRemoteDatasource>(() => ProfileRemoteDatasource());
    Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(Get.find()));
    Get.lazyPut<GetProfileUsecase>(() => GetProfileUsecase(Get.find()));
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<GetProfileUsecase>(),
        Get.find<GetAllAttendanceHistoryUsecase>(),
      ),
      fenix: true,
    );
  }
}
