import 'package:hr_attendance/core/utils/extensions.dart';

class AttendanceModel {
  final String rawDate;
  final String date;
  final String duration;
  final String clockIn;
  final String clockOut;
  final String note;

  AttendanceModel({
    required this.rawDate,
    required this.date,
    required this.duration,
    required this.clockIn,
    required this.clockOut,
    required this.note,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    final rawDate = (json['date'] ?? "-").toString();

    return AttendanceModel(
      rawDate: rawDate,
      date: rawDate.toFormattedDate(),
      duration: (json['duration'] ?? "-").toString().toFormattedDuration(),
      clockIn: (json['clock_in'] ?? "-").toString().toFormattedClock(),
      clockOut: (json['clock_out'] ?? "-").toString().toFormattedClock(),
      note: (json['note'] ?? "-"),
    );
  }
}
