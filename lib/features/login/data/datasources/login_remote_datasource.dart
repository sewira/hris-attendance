import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../config/endpoints/api_endpoints.dart';
import '../models/user_model.dart';

abstract class LoginRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final DioClient dioClient;

  LoginRemoteDataSourceImpl(this.dioClient);

  @override
Future<UserModel> login(String email, String password) async {
  try {
    final response = await dioClient.dio.post(
      ApiEndpoints.login,
      data: {
        "email": email,
        "password": password,
      },
    );

    final message = response.data["message"]?.toString() ?? "";

    if (message.toLowerCase().contains("terblokir")) {
      throw Exception("BLOCKED_ACCOUNT");
    }

    if (response.statusCode != 200) {
      throw Exception(message.isNotEmpty ? message : "Login gagal");
    }

    return UserModel.fromJson(response.data);

  } on DioException catch (e) {
    if (e.response != null) {
      final message = e.response?.data["message"]?.toString() ?? "Login gagal";

      if (message.toLowerCase().contains("terblokir")) {
        throw Exception("BLOCKED_ACCOUNT");
      }

      throw Exception(message);
    } else {
      throw Exception("Tidak bisa terhubung ke server");
    }
  }
}
}
