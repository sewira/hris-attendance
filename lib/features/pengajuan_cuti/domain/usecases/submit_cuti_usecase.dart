import 'package:hr_attendance/features/pengajuan_cuti/data/models/cuti_model.dart';
import 'package:hr_attendance/features/pengajuan_cuti/domain/repositories/cuti_repositories.dart';

class SubmitCutiUsecase {
  final CutiRepository repository;

  SubmitCutiUsecase(this.repository);

  Future<void> call(CutiModel request) {
    return repository.submitCuti(request);
  }
}