// import 'package:get/get.dart';
// import '../../data/datasources/attendance_remote_datasource.dart';
// import '../../domain/repositories/attendance_repository.dart';
// import '../../domain/usecases/clock_in_usecase.dart';
// import '../../domain/usecases/clock_out_usecase.dart';
// import '../../domain/usecases/get_today_attendance_usecase.dart';
// import '../controllers/attendance_controller.dart';

// class AttendanceBinding extends Bindings {
//   @override
//   void dependencies() {
//     // Register datasource as repository
//     Get.lazyPut<AttendanceRepository>(
//       () => AttendanceRemoteDatasource(),
//     );

//     // Register usecases
//     Get.lazyPut(
//       () => ClockInUsecase(
//         repository: Get.find<AttendanceRepository>(),
//       ),
//     );

//     Get.lazyPut(
//       () => ClockOutUsecase(
//         repository: Get.find<AttendanceRepository>(),
//       ),
//     );

//     Get.lazyPut(
//       () => GetTodayAttendanceUsecase(
//         repository: Get.find<AttendanceRepository>(),
//       ),
//     );

//     // Register controller
//     Get.lazyPut(
//       () => AttendanceController(
//         clockInUsecase: Get.find<ClockInUsecase>(),
//         clockOutUsecase: Get.find<ClockOutUsecase>(),
//         getTodayAttendanceUsecase: Get.find<GetTodayAttendanceUsecase>(),
//       ),
//     );
//   }
// }
