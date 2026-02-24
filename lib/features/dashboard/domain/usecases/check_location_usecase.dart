import 'package:hr_attendance/features/dashboard/domain/repositories/dashboard_repository.dart';

class CheckLocationUsecase {
  final DashboardRepository repository;

  CheckLocationUsecase(this.repository);

  Future<void> call({required double lat, required double lng}) {
    return repository.checkLocation(lat: lat, lng: lng);
  }
}
