import 'dart:io';

import 'package:hr_attendance/features/dashboard/domain/repositories/dashboard_repository.dart';

class ClockInUsecase {
  final DashboardRepository repository;

  ClockInUsecase(this.repository);

  Future<void> call(File photo) {
    return repository.clockIn(photo);
  }
}
