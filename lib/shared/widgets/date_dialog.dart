import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> showDateDialog(
  BuildContext context,
  TextEditingController controller,
) async {
  final DateTime? picked = await showDialog<DateTime>(
    context: context,
    builder: (context) {
      return DatePickerDialog(
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
      );
    },
  );

  if (picked != null) {
    controller.text = DateFormat('dd/MM/yyyy').format(picked);
  }
}
