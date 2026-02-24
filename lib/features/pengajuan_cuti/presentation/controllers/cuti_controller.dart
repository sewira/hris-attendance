import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/shared/widgets/alert_dialog.dart';
import 'package:intl/intl.dart';
import 'package:hr_attendance/shared/widgets/date_dialog.dart';

class CutiController extends GetxController {
  final reasonController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final RxString dateError = "".obs;
  final DateFormat formatter = DateFormat("dd/MM/yyyy");


  Future<void> pickStartDate(BuildContext context) async {
    await showDateDialog(context, startDateController);
    validateDate();
  }

  Future<void> pickEndDate(BuildContext context) async {
    await showDateDialog(context, endDateController);
    validateDate();
  }

  void validateDate() {
    dateError.value = "";

    if (startDateController.text.isEmpty || endDateController.text.isEmpty) {
      return;
    }

    try {
      final start = formatter.parse(startDateController.text);
      final end = formatter.parse(endDateController.text);

      if (end.isBefore(start)) {
        dateError.value =
            "Tanggal selesai tidak boleh kurang dari tanggal mulai";
      }
    } catch (_) {
      dateError.value = "Format tanggal tidak valid";
    }
  }

  void submitCuti() {
    if (startDateController.text.isEmpty ||
        endDateController.text.isEmpty ||
        reasonController.text.isEmpty) {
      Alertdialog.show(
        animasi: AppAssets.lottieFailed,
        message: "Data tidak lengkap",
      );
      return;
    }

    validateDate();

    if (dateError.value.isNotEmpty) return;

    Alertdialog.show(
      animasi: AppAssets.lottieSuccess,
      message: "Pengisian anda berhasil",
      showButton: false,
      changeMainIndex: 0,
    );
  }

  @override
  void onClose() {
    reasonController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }
}
