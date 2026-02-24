import 'package:hr_attendance/features/ganti_password/data/models/password_model.dart';
import 'package:hr_attendance/features/ganti_password/domain/repositories/password_repositories.dart';

class GantiPasswordUsecases {
  final PasswordRepositories repositories;

  GantiPasswordUsecases(this.repositories);

  Future<void> call(PasswordModel request){
    return repositories.submitPassword(request);
  }
}