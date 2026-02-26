import 'dart:io';
import 'package:hr_attendance/features/dashboard/data/models/attendance_today_model.dart';
import 'package:hr_attendance/features/dashboard/domain/repositories/dashboard_repository.dart';

class ClockInUsecase {
  final DashboardRepository repository;

  ClockInUsecase(this.repository);

  Future<AttendanceTodayModel> call(File photo) {
    return repository.clockIn(photo);
  }
}
