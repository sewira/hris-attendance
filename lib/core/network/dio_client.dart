import 'package:dio/dio.dart';
import '../../config/endpoints/api_endpoints.dart';

class DioClient {
  static DioClient? _instance;
  late Dio dio;

  DioClient._() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }
}
