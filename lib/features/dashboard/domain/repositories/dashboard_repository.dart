import 'dart:io';
import 'package:hr_attendance/features/dashboard/data/models/attendance_today_model.dart';
import 'package:hr_attendance/features/dashboard/data/models/check_location_model.dart';
import 'package:hr_attendance/features/dashboard/data/models/leave_history_model.dart';

abstract class DashboardRepository {
  // Future<List<AttendanceModel>> getAttendanceHistory({
  //   String? search,
  // });

  Future<List<LeaveHistoryModel>> getLeaveHistory({String? search});

  Future<CheckLocationResponse> checkLocation({
    required double lat,
    required double lng,
  });

  Future<AttendanceTodayModel> clockIn(File photo);

  Future<void> clockOut({String? note}); 
}
