import 'package:hr_attendance/features/attendance_history_shared/data/datasource/attendance_history_remote.dart';
import 'package:hr_attendance/features/attendance_history_shared/data/models/attendance_history_model.dart';
import 'package:hr_attendance/features/attendance_history_shared/domain/repositories/attendance_history_repo.dart';

class AttendanceHistoryRepoImpl implements  AttendanceHistoryRepo{
  final AttendanceHistoryRemote remoteDatasource;

  AttendanceHistoryRepoImpl(this.remoteDatasource);

  @override
  Future<List<AttendanceModel>> getAttendanceHistory({String? search,}) async {
    final result = await remoteDatasource.getAttendanceHistory(search: search);

    return result
        .map<AttendanceModel>((e) => AttendanceModel.fromJson(e))
        .toList();
  }

 @override
Future<List<AttendanceModel>> getAllAttendanceHistory({String? search}) async {
  final result = await remoteDatasource.getAllAttendanceHistory(search: search);

  return result
      .map<AttendanceModel>((e) => AttendanceModel.fromJson(e))
      .toList();
}
}
