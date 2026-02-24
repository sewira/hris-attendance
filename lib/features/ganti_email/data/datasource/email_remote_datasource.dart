import 'package:hr_attendance/config/endpoints/api_endpoints.dart';
import 'package:hr_attendance/core/network/dio_client.dart';
import 'package:hr_attendance/features/ganti_email/data/models/email_model.dart';

class EmailRemoteDatasource {
  Future<void> changeEmail(EmailModel request) async {
    await DioClient.instance.dio.patch(
      ApiEndpoints.email,
      data: request.toJson(),
    );
  }
}