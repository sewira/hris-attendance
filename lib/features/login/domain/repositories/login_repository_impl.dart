import 'package:hr_attendance/features/login/data/datasources/login_remote_datasource.dart';
import 'package:hr_attendance/features/login/data/models/user_model.dart';

import '../../domain/repositories/login_repository.dart';


class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserModel> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }
}