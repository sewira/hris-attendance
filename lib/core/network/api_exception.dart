import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(message: 'Connection timeout');
      case DioExceptionType.sendTimeout:
        return ApiException(message: 'Send timeout');
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Receive timeout');
      case DioExceptionType.badResponse:
        return ApiException(
          message: _handleBadResponse(error.response?.statusCode),
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return ApiException(message: 'No internet connection');
      default:
        return ApiException(message: 'Something went wrong');
    }
  }

  static String _handleBadResponse(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Something went wrong';
    }
  }

  @override
  String toString() => message;
}
