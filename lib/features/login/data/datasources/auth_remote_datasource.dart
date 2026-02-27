import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../config/endpoints/api_endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<bool> setNewEmployeeFalse();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<bool> setNewEmployeeFalse() async {
    try {
      final response = await dioClient.dio.patch(
        ApiEndpoints.isNewEmployee,
        data: {"isNewEmployee": false},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("PATCH gagal: ${response.statusCode} ${response.data}");
        return false;
      }
    } on DioException catch (e) {
      print("Error patch isNewEmployee: ${e.message}");
      return false;
    }
  }
}