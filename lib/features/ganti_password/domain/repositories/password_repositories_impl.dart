import 'package:hr_attendance/features/ganti_password/data/datasource/password_remote_datasource.dart';
import 'package:hr_attendance/features/ganti_password/data/models/password_model.dart';
import 'package:hr_attendance/features/ganti_password/domain/repositories/password_repositories.dart';

class PasswordRepositoriesImpl implements PasswordRepositories {
  final PasswordRemoteDatasource remoteDatasource;

  PasswordRepositoriesImpl(this.remoteDatasource);

  @override
  Future<void> submitPassword(PasswordModel request){
    return remoteDatasource.submitPassword(request);
  }
}