// import 'package:dartz/dartz.dart';
// import '../../../../core/base/base_usecase.dart';
// import '../../../../core/error/failure.dart';
// import '../../data/models/attendance_model.dart';
// import '../repositories/attendance_repository.dart';

// /// Params class for multiple parameters
// class DateRangeParams {
//   final String employeeId;
//   final DateTime startDate;
//   final DateTime endDate;

//   DateRangeParams({
//     required this.employeeId,
//     required this.startDate,
//     required this.endDate,
//   });
// }

// class GetAttendanceByDateRangeUsecase
//     extends BaseUsecase<List<AttendanceModel>, DateRangeParams> {
//   final AttendanceRepository repository;

//   GetAttendanceByDateRangeUsecase({required this.repository});

//   @override
//   Future<Either<Failure, List<AttendanceModel>>> call(
//       DateRangeParams params) async {
//     return repository.getAttendanceHistory(params.employeeId);
//     // Would pass startDate/endDate to repository if API supports it
//   }
// }
