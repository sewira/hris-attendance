import 'package:intl/intl.dart';

class AttendanceModel {
  final String date;
  final String duration;
  final String clockIn;
  final String clockOut;

  AttendanceModel({
    required this.date,
    required this.duration,
    required this.clockIn,
    required this.clockOut,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      date: _formatDate(json['date']),
      duration: json['duration'] ?? "-",
      clockIn: json['clock_in'] ?? "-",
      clockOut: json['clock_out'] ?? "-",
    );
  }

  static String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat("dd MMM yyyy", "id_ID").format(date);
    } catch (_) {
      return rawDate;
    }
  }
}
