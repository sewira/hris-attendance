import 'package:hr_attendance/features/attendance_history_shared/data/models/attendance_history_model.dart';

abstract class AttendanceHistoryRepo {
  Future<List<AttendanceModel>> getAttendanceHistory({
    String? search,
  });

   Future<List<AttendanceModel>> getAllAttendanceHistory({
    String? search,
  });
}
