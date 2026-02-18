import '../repositories/dashboard_repository.dart';
import '../../data/models/attendance_model.dart';

class GetAttendanceHistoryUsecase {
  final DashboardRepository repository;

  GetAttendanceHistoryUsecase(this.repository);

  Future<List<AttendanceModel>> call() {
    return repository.getAttendanceHistory();
  }
}
