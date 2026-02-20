import 'package:flutter/material.dart';
import 'package:hr_attendance/config/theme/app_color.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toFormattedDate() {
    return DateFormat('dd MMM yyyy').format(this);
  }

  String toFormattedTime() {
    return DateFormat('HH:mm').format(this);
  }

  String toFormattedDateTime() {
    return DateFormat('dd MMM yyyy, HH:mm').format(this);
  }
}

extension DateRangeExtension on DateTime {
  Map<String, String> toCurrentMonthRange() {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    String format(DateTime date) {
      return "${date.year}-"
          "${date.month.toString().padLeft(2, '0')}-"
          "${date.day.toString().padLeft(2, '0')}";
    }

    return {
      "start_date": format(firstDay),
      "end_date": format(lastDay),
    };
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String toFormattedDuration() {
    if (isEmpty || this == "-") return "-";

    try {
      final hourMatch = RegExp(r'(\d+)h').firstMatch(this);
      final minuteMatch = RegExp(r'(\d+)m').firstMatch(this);

      final hours = hourMatch != null ? int.parse(hourMatch.group(1)!) : 0;
      final minutes = minuteMatch != null
          ? int.parse(minuteMatch.group(1)!)
          : 0;

      if (hours > 0) {
        return "$hours jam";
      }

      if (minutes > 0) {
        return "$minutes menit";
      }

      return "0 menit";
    } catch (_) {
      return this;
    }
  }

  String toFormattedDate({String locale = "id_ID"}) {
    if (isEmpty || this == "-") return "-";

    try {
      final date = DateTime.parse(this);
      return DateFormat("dd MMM yyyy", locale).format(date);
    } catch (_) {
      return this;
    }
  }

   String toFormattedLeaveRange(String endDate,
      {String locale = "id_ID"}) {
    if (isEmpty || this == "-" || endDate.isEmpty || endDate == "-") {
      return "-";
    }

    try {
      final startDate = DateTime.parse(this);
      final end = DateTime.parse(endDate);

      final year = startDate.year;

      if (startDate == end) {
        return "${DateFormat("dd MMM", locale).format(startDate)}\n$year";
      }

      return "${DateFormat("dd MMM", locale).format(startDate)} - "
          "${DateFormat("dd MMM", locale).format(end)}\n$year";
    } catch (_) {
      return "-";
    }
  }

  String toFormattedClock() {
    if (isEmpty || this == "-") return "-";

    try {
      final dateTime = DateTime.parse("2026-01-01 $this");
      return DateFormat("HH:mm").format(dateTime);
    } catch (_) {
      return this;
    }
  }

  Color getClockInColor() {
    try {
      if (this == "-" || isEmpty) return Colors.black;

      final parts = split(":");
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour > 8 || (hour == 8 && minute > 15) && hour < 17) {
        return AppColor.danger;
      }

      return Colors.black;
    } catch (_) {
      return Colors.black;
    }
  }

  Color getClockOutColor() {
     try {
      if (this == "-" || isEmpty) return Colors.black;

      final parts = split(":");
      final hour = int.parse(parts[0]);

      if (hour < 17) {
        return AppColor.danger;
      }

      return Colors.black;
    } catch (_) {
      return Colors.black;
    }
  }
}
