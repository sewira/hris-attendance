abstract class ApiEndpoints {
  static const String baseUrl = 'http://109.111.53.197:7090';

  static const String login = '/api/v1/auth/login';
  static const String attendanceHistory = '/api/v1/attendance/history';
  static const String leave = '/api/v1/leaves';
  static const String leaveHistory = '/api/v1/leaves/history';
  static const String profile = '/api/v1/profile';
}
