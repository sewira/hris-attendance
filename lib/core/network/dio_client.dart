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
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Accept'] = 'application/json';
          options.headers['Content-Type'] = 'application/json';
          options.headers['X-API-Key'] = 'hris-api-key-123';

          final isLoginEndpoint = options.path == ApiEndpoints.login;

          if (isLoginEndpoint) {
            options.headers.remove('Authorization');
          } else {
            final token = AppStorage.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          return handler.next(options);
        },

        onResponse: (response, handler) {
          return handler.next(response);
        },

        onError: (error, handler) async {
          final isLoginEndpoint =
              error.requestOptions.path == ApiEndpoints.login;

          if (error.response?.statusCode == 401 && !isLoginEndpoint) {
            await AppStorage.clearAll();
            Get.offAllNamed(AppRoutes.login);
          }

          return handler.next(error);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }
}