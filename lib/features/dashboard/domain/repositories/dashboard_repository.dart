import 'package:hr_attendance/features/dashboard/data/models/leave_history_model.dart';

abstract class DashboardRepository {
  // Future<List<AttendanceModel>> getAttendanceHistory({
  //   String? search,
  // });

  Future<List<LeaveHistoryModel>> getLeaveHistory({
    String? search,
  });
}
