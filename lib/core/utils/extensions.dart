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

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
