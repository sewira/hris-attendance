import 'package:hr_attendance/features/dashboard/data/datasources/dashboard_remote_datasource.dart.dart';
import 'package:hr_attendance/features/dashboard/data/models/attendance_model.dart';

import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource remoteDatasource;

  DashboardRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<AttendanceModel>> getAttendanceHistory() async {
    final result = await remoteDatasource.getAttendanceHistory();

    return result
        .map<AttendanceModel>((e) => AttendanceModel.fromJson(e))
        .toList();
  }
}
