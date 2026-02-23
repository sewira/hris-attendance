import 'package:hr_attendance/features/attendance_history_shared/data/models/attendance_history_model.dart';
import 'package:hr_attendance/features/attendance_history_shared/domain/repositories/attendance_history_repo.dart';

class GetAttendanceHistoryMonthUsecase {
  final AttendanceHistoryRepo repository;

  GetAttendanceHistoryMonthUsecase(this.repository);

  Future<List<AttendanceModel>> call({
    String? search,
  }) {
    return repository.getAttendanceHistory(search: search);
  }
}