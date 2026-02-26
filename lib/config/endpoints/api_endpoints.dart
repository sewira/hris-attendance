abstract class ApiEndpoints {
  static const String baseUrl = 'http://109.111.53.197:7090/api/v1/';

  static const String login = 'auth/login';
  static const String attendanceHistory = 'attendance/history';
  static const String leave = 'leaves';
  static const String leaveHistory = 'leaves/history';
  static const String profile = 'profile';
  static const String password= 'auth/change-password';
  static const String email= 'auth/profile/email';
  static const String clockIn = 'attendance/clock-in';
  static const String checkLocation = 'attendance/check-location';
  static const String clockOut= 'attendance/clock-out';
}
