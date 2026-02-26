import 'package:hr_attendance/features/dashboard/domain/repositories/dashboard_repository.dart';

class ClockOutUsecase {
  final DashboardRepository repository;

  ClockOutUsecase(this.repository);

  Future<void> call({String? note}) {
    return repository.clockOut(note: note);
  }
}
