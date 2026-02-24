import 'package:hr_attendance/features/pengajuan_cuti/data/datasources/cuti_remote_datasource.dart';
import 'package:hr_attendance/features/pengajuan_cuti/data/models/cuti_model.dart';
import 'package:hr_attendance/features/pengajuan_cuti/domain/repositories/cuti_repositories.dart';

class CutiRepositoryImpl implements CutiRepository{

  final CutiRemoteDatasource remoteDatasource;

  CutiRepositoryImpl(this.remoteDatasource);
  
  @override
  Future<void> submitCuti(CutiModel request) {
    return remoteDatasource.submitCuti(request);
  }
}