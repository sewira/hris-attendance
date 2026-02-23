import 'package:hr_attendance/features/profile/domain/repositories/profile_repositories.dart';

import '../../data/models/profile_model.dart';

class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase(this.repository);

  Future<ProfileModel> call() {
    return repository.getProfile();
  }
}
