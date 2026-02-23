import 'package:hr_attendance/config/endpoints/api_endpoints.dart';
import 'package:hr_attendance/core/network/dio_client.dart';
import 'package:hr_attendance/features/pengajuan_cuti/data/models/cuti_model.dart';

class CutiRemoteDatasource {

  Future<void> submitCuti(CutiModel request) async {
    await DioClient.instance.dio.post(
      ApiEndpoints.leave, 
      data: request.toJson(),
    );
  }
}