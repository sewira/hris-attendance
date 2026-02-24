import 'package:dio/dio.dart';
import 'package:hr_attendance/config/endpoints/api_endpoints.dart';
import 'package:hr_attendance/core/network/dio_client.dart';
import 'package:hr_attendance/features/ganti_password/data/models/password_model.dart';

class PasswordRemoteDatasource {
  Future<void> submitPassword(PasswordModel request) async {
    final response = await DioClient.instance.dio.post(
      ApiEndpoints.password,
      data: request.toJson(),
      options: Options(
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        response.data["message"] ?? "Ganti password gagal",
      );
    }
  }
}