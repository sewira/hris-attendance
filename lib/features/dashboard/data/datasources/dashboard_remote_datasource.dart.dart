import 'package:hr_attendance/core/network/dio_client.dart';
import 'package:hr_attendance/config/endpoints/api_endpoints.dart';

class DashboardRemoteDatasource {
  Future<List<dynamic>> getAttendanceHistory() async {
    final response = await DioClient.instance.dio.get(
      ApiEndpoints.attendanceHistory,
    );

    return response.data['data']['data'];
  }
}
