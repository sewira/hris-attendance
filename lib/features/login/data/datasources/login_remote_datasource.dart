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
    final response = await dioClient.dio.post(
      ApiEndpoints.login,
      data: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception(response.data["message"] ?? "Login gagal");
    }
  }
}
