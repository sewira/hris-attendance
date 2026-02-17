abstract class ApiEndpoints {
  static const String baseUrl = 'http://109.111.53.197:7090';

  static const String login = '/api/v1/auth/login';


  static const String clockIn = '/attendance/clock-in';
  static const String clockOut = '/attendance/clock-out';
  static const String attendanceHistory = '/attendance/history';
  static const String todayAttendance = '/attendance/today';
}
