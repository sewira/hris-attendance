import 'package:hr_attendance/config/endpoints/api_endpoints.dart';
import 'package:hr_attendance/core/network/dio_client.dart';

class ProfileRemoteDatasource {
  Future<Map<String, dynamic>> getProfile() async {
    final response = await DioClient.instance.dio.get(
      ApiEndpoints.profile,
    );

    return response.data['data'];
  }
}