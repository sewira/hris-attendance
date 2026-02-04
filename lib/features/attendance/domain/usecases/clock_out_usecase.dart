import 'package:dartz/dartz.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/attendance_model.dart';
import '../repositories/attendance_repository.dart';

class ClockOutUsecase extends BaseUsecase<AttendanceModel, String> {
  final AttendanceRepository repository;

  ClockOutUsecase({required this.repository});

  @override
  Future<Either<Failure, AttendanceModel>> call(String employeeId) {
    return repository.clockOut(employeeId);
  }
}
