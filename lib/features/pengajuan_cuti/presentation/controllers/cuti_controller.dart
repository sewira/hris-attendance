import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/features/dashboard/data/models/leave_history_model.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/get_leave_history.dart';
import 'package:hr_attendance/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:hr_attendance/shared/widgets/alert_dialog.dart';
import 'package:hr_attendance/shared/widgets/loading_dialog.dart';
import 'package:intl/intl.dart';
import '../../data/models/cuti_model.dart';
import '../../domain/usecases/submit_cuti_usecase.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';

class CutiController extends GetxController {
  final SubmitCutiUsecase submitLeaveUsecase;
  final GetLeaveHistoryUsecase getLeaveHistoryUsecase;

  CutiController(this.submitLeaveUsecase, this.getLeaveHistoryUsecase);

  final reasonController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final RxString startDateError = "".obs;
  final RxString endDateError = "".obs;
  final RxString reasonError = "".obs;
  final RxString leaveError = "".obs;
  final RxBool isLoading = false.obs;

  final DateFormat inputFormat = DateFormat("dd/MM/yyyy");
  final DateFormat apiFormat = DateFormat("yyyy-MM-dd");

  final RxList<LeaveHistoryModel> leaveList = <LeaveHistoryModel>[].obs;

  ProfileController get profileController => Get.find();
  int get leaveBalance => profileController.leaveBalance;

  @override
  void onInit() {
    super.onInit();
    fetchLeaveHistory();

    reasonController.addListener(() {
      if (reasonController.text.length > 50) {
        reasonError.value = "Alasan cuti maksimal 50 karakter";
      } else {
        reasonError.value = "";
      }
    });
  }

  Future<void> fetchLeaveHistory() async {
    final result = await getLeaveHistoryUsecase();
    leaveList.assignAll(result);
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      startDateController.text = inputFormat.format(picked);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final start = picked;

      if (start.isBefore(today)) {
        startDateError.value = "Tanggal tidak boleh kurang dari hari ini";
      } else {
        startDateError.value = "";
        validateDates();
      }
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      endDateController.text = inputFormat.format(picked);
      validateDates();
    }
  }

  void validateDates() {
    endDateError.value = "";
    if (startDateController.text.isEmpty || endDateController.text.isEmpty)
      return;
    try {
      final start = inputFormat.parse(startDateController.text);
      final end = inputFormat.parse(endDateController.text);

      if (end.isBefore(start)) {
        endDateError.value =
            "Tanggal selesai tidak boleh kurang dari tanggal mulai";
      }

      if (startDateError.value.isEmpty && endDateError.value.isEmpty) {
        if (isDateConflict(start, end)) {
          startDateError.value = "Masih ada cuti berjalan";
        }
      }
    } catch (_) {
      startDateError.value = "Format tanggal tidak valid";
    }
  }

  bool isDateConflict(DateTime newStart, DateTime newEnd) {
    for (var leave in leaveList) {
      if (leave.startDate == "-" || leave.endDate == "-") continue;
      if (leave.status != "approved" && leave.status != "pending") continue;

      final existingStart = DateTime.parse(leave.startDate);
      final existingEnd = DateTime.parse(leave.endDate);

      if (!(newEnd.isBefore(existingStart) || newStart.isAfter(existingEnd))) {
        return true;
      }
    }
    return false;
  }

  void validateLeaveBalance() {
    leaveError.value = "";

    if (leaveBalance == 0) {
      leaveError.value = "Sisa cuti habis";
      return;
    }

    final start = inputFormat.parse(startDateController.text);
    final end = inputFormat.parse(endDateController.text);

    final totalDays = end.difference(start).inDays + 1;

    if (totalDays > leaveBalance) {
      leaveError.value = "Sisa cuti tidak mencukupi";
    }
  }

  Future<void> submitCuti() async {
    validateDates();

    bool inputKosong = false;
    if (startDateController.text.isEmpty) {
      startDateError.value = "Tanggal mulai wajib diisi";
      inputKosong = true;
    }
    if (endDateController.text.isEmpty) {
      endDateError.value = "Tanggal selesai wajib diisi";
      inputKosong = true;
    }
    if (reasonController.text.isEmpty) {
      reasonError.value = "Alasan cuti wajib diisi";
      inputKosong = true;
    }

    if (inputKosong) {
      Alertdialog.show(
        animasi: AppAssets.lottieFailed,
        message: "Input tidak lengkap",
      );
      return;
    }

    if (startDateError.value.isNotEmpty ||
        endDateError.value.isNotEmpty ||
        reasonError.value.isNotEmpty ||
        leaveError.value.isNotEmpty) {
      return;
    }

    validateLeaveBalance();
    if (leaveError.value.isNotEmpty) return;

    try {
      LoadingDialog.show();

      final start = inputFormat.parse(startDateController.text);
      final end = inputFormat.parse(endDateController.text);

      final model = CutiModel(
        startDate: apiFormat.format(start),
        endDate: apiFormat.format(end),
        reason: reasonController.text,
      );

      await submitLeaveUsecase(model);
      await profileController.fetchProfile();
      await fetchLeaveHistory();

      final dashboardController = Get.find<DashboardController>();
      await dashboardController.fetchLeave();

      LoadingDialog.close();

      clearForm();

      Alertdialog.show(
        animasi: AppAssets.lottieSuccess,
        message: "Pengajuan berhasil",
        showButton: false,
        changeMainIndex: 0,
      );
    } catch (e) {
      LoadingDialog.close();

      Alertdialog.show(
        animasi: AppAssets.lottieFailed,
        message: "Pengajuan gagal",
      );
    }
  }

  void clearForm() {
    reasonController.clear();
    startDateController.clear();
    endDateController.clear();
    startDateError.value = "";
    endDateError.value = "";
    reasonError.value = "";
    leaveError.value = "";
  }

  @override
  void onClose() {
    reasonController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }
}
