import 'package:hr_attendance/core/network/dio_client.dart';
import 'package:hr_attendance/config/endpoints/api_endpoints.dart';
import 'package:hr_attendance/core/utils/extensions.dart';

class DashboardRemoteDatasource {

  Future<List<dynamic>> getAttendanceHistory({
    String? startDate,
    String? endDate,
    String? search,
  }) async {

    final now = DateTime.now();
    final range = now.toCurrentMonthRange();

    final response = await DioClient.instance.dio.get(
      ApiEndpoints.attendanceHistory,
      queryParameters: {
        "page": 1,
        "page_size": 31,
        "start_date": startDate ?? range["start_date"],
        "end_date": endDate ?? range["end_date"],

        if (search != null && search.isNotEmpty)
          "search": search,
      },
    );

    return response.data['data']['data'];
  }

  Future<List<dynamic>> getLeaveHistory({
    String? startDate,
    String? endDate,
    String? search,
  }) async {

    final now = DateTime.now();
    final range = now.toCurrentMonthRange();

    final response = await DioClient.instance.dio.get(
      ApiEndpoints.leaveHistory,
      queryParameters: {
        "page": 1,
        "page_size": 31,
        "start_date": startDate ?? range["start_date"],
        "end_date": endDate ?? range["end_date"],

        if (search != null && search.isNotEmpty)
          "search": search,
      },
    );

    return response.data['data']['data'];
  }
}