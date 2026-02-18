import '../../data/models/attendance_model.dart';

abstract class DashboardRepository {
  Future<List<AttendanceModel>> getAttendanceHistory();
}
