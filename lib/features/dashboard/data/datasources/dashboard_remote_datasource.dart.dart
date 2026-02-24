import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hr_attendance/core/network/dio_client.dart';
import 'package:hr_attendance/config/endpoints/api_endpoints.dart';

class DashboardRemoteDatasource {

  Future<void> checkLocation({
    required double lat,
    required double lng,
  }) async {
    final response = await DioClient.instance.dio.get(
      ApiEndpoints.checkLocation,
      queryParameters: {
        'lat': lat,
        'lng': lng,
      },
    );

    if (response.statusCode != 200) {
      final message =
          response.data['message']?.toString() ?? 'Lokasi tidak valid';
      throw Exception(message);
    }
  }

  Future<void> clockIn(File photo) async {
    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        photo.path,
        filename: photo.path.split('/').last,
      ),
    });

    final response = await DioClient.instance.dio.post(
      ApiEndpoints.clockIn,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final message = response.data['message']?.toString() ?? 'Clock in gagal';
      throw Exception(message);
    }
  }
  
  // Future<List<dynamic>> getAttendanceHistory({
  //   String? startDate,
  //   String? endDate,
  //   String? search,
  // }) async {
  //   final now = DateTime.now();
  //   final range = now.toCurrentMonthRange();

  //   final response = await DioClient.instance.dio.get(
  //     ApiEndpoints.attendanceHistory,
  //     queryParameters: {
  //       "page": 1,
  //       "page_size": 31,
  //       "start_date": startDate ?? range["start_date"],
  //       "end_date": endDate ?? range["end_date"],

  //       if (search != null && search.isNotEmpty) "search": search,
  //     },
  //   );

  //   return response.data['data']['data'];
  // }

  Future<List<dynamic>> getLeaveHistory({
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    final response = await DioClient.instance.dio.get(
      ApiEndpoints.leaveHistory,
      queryParameters: {
        "page": 1,
        "page_size": 100,
        "start_date": startDate,
        "end_date": endDate,

        if (search != null && search.isNotEmpty) "search": search,
      },
    );

    return response.data['data']['data'];
  }
}
