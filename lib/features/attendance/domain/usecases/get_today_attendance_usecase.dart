import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/attendance_model.dart';
import '../repositories/attendance_repository.dart';

class GetTodayAttendanceUsecase extends BaseUsecase<AttendanceModel?, String> {
  final AttendanceRepository repository;

  GetTodayAttendanceUsecase({required this.repository});

  @override
  Future<Either<Failure, AttendanceModel?>> call(String employeeId) {
    return repository.getTodayAttendance(employeeId);
  }
}
