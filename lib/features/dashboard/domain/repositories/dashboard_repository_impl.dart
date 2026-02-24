import 'package:hr_attendance/features/dashboard/data/datasources/dashboard_remote_datasource.dart.dart';
import 'package:hr_attendance/features/dashboard/data/models/attendance_model.dart';
import 'package:hr_attendance/features/dashboard/data/models/leave_history_model.dart';

import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource remoteDatasource;

  DashboardRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<AttendanceModel>> getAttendanceHistory({String? search,}) async {
    final result = await remoteDatasource.getAttendanceHistory(search: search);

    return result
        .map<AttendanceModel>((e) => AttendanceModel.fromJson(e))
        .toList();
  }

  @override
  Future<List<LeaveHistoryModel>> getLeaveHistory({String? search}) async {
    final result = await remoteDatasource.getLeaveHistory(search: search);

    return result
        .map<LeaveHistoryModel>((e) => LeaveHistoryModel.fromJson(e))
        .toList();
  }
}
