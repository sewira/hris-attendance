import 'package:hr_attendance/features/dashboard/data/models/leave_history_model.dart';
import 'package:hr_attendance/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetLeaveHistoryUsecase {
  final DashboardRepository repository;

  GetLeaveHistoryUsecase(this.repository);

  Future<List<LeaveHistoryModel>> call({
    String? search,
  }) {
    return repository.getLeaveHistory(search: search);
  }
}