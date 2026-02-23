import 'package:hr_attendance/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:hr_attendance/features/profile/data/models/profile_model.dart';
import 'package:hr_attendance/features/profile/domain/repositories/profile_repositories.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl(this.remoteDatasource);

  @override
  Future<ProfileModel> getProfile() async {
    final result = await remoteDatasource.getProfile();
    return ProfileModel.fromJson(result);
  }
}