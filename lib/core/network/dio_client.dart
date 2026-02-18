import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../config/endpoints/api_endpoints.dart';
import '../../core/utils/app_storage.dart';
import '../../config/routes/app_routes.dart';

class DioClient {
  static DioClient? _instance;
  late Dio dio;

  DioClient._() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) {
          return status != null && status < 500;
        },
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {

          // =========================
          // API KEY
          // =========================
          options.headers["x-api-key"] = "hris-api-key-123";

          // =========================
          // AUTHORIZATION (skip login & register)
          // =========================
          final token = AppStorage.getToken();

          final isAuthEndpoint =
              options.path.contains('/auth/login') ||
              options.path.contains('/auth/register');

          if (token != null && !isAuthEndpoint) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },

        // =========================
        // RESPONSE
        // =========================
        onResponse: (response, handler) {

          if (response.statusCode != 200) {
            return handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
              ),
            );
          }

          return handler.next(response);
        },

        // =========================
        // ERROR HANDLER
        // =========================
        onError: (error, handler) async {

          // Kalau token expired / unauthorized
          if (error.response?.statusCode == 401) {
            await AppStorage.clearAll();
            Get.offAllNamed(AppRoutes.login);
          }

          return handler.next(error);
        },
      ),
    );

    // =========================
    // LOGGING
    // =========================
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }
}
