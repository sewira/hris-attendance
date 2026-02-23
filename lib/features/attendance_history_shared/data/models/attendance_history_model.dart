import 'package:hr_attendance/core/utils/extensions.dart';

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
    date: (json['date'] ?? "-").toString().toFormattedDate(),
    duration: (json['duration'] ?? "-")
        .toString()
        .toFormattedDuration(),
    clockIn: (json['clock_in'] ?? "-")
        .toString()
        .toFormattedClock(),
    clockOut: (json['clock_out'] ?? "-")
        .toString()
        .toFormattedClock(),
  );
}

}
