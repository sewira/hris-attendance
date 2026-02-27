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

  final RxInt durationDays = 0.obs;
  final RxBool isFormReady = false.obs;

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
      checkFormReady();
    });
  }

  void checkFormReady() {
    isFormReady.value =
        startDateController.text.isNotEmpty &&
        endDateController.text.isNotEmpty &&
        reasonController.text.isNotEmpty &&
        startDateError.value.isEmpty &&
        endDateError.value.isEmpty &&
        reasonError.value.isEmpty &&
        leaveError.value.isEmpty &&
        durationDays.value > 0;
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

      final today = DateTime.now();
      final nowOnlyDate = DateTime(today.year, today.month, today.day);

      if (picked.isBefore(nowOnlyDate)) {
        startDateError.value = "Tanggal tidak boleh kurang dari hari ini";
      } else {
        startDateError.value = "";
      }

      validateDates();
      calculateDuration();
      checkFormReady();
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
      calculateDuration();
      checkFormReady();
    }
  }

  void validateDates() {
    endDateError.value = "";

    if (startDateController.text.isEmpty || endDateController.text.isEmpty) {
      durationDays.value = 0;
      return;
    }

    try {
      final start = inputFormat.parse(startDateController.text);
      final end = inputFormat.parse(endDateController.text);

      if (end.isBefore(start)) {
        endDateError.value =
            "Tanggal selesai tidak boleh kurang dari tanggal mulai";
        durationDays.value = 0;
        return;
      }

      if (isDateConflict(start, end)) {
        startDateError.value = "Masih ada cuti berjalan";
        durationDays.value = 0;
        return;
      }

      startDateError.value = "";
    } catch (_) {
      startDateError.value = "Format tanggal tidak valid";
      durationDays.value = 0;
    }
  }

  void calculateDuration() {
    if (startDateController.text.isEmpty || endDateController.text.isEmpty) {
      durationDays.value = 0;
      return;
    }

    try {
      final start = inputFormat.parse(startDateController.text);
      final end = inputFormat.parse(endDateController.text);

      if (!end.isBefore(start)) {
        durationDays.value = end.difference(start).inDays + 1;
        validateLeaveBalance();
      }
    } catch (_) {
      durationDays.value = 0;
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

    if (durationDays.value > leaveBalance) {
      leaveError.value = "Sisa cuti tidak mencukupi";
    }
  }

  Future<void> submitCuti() async {
    if (startDateController.text.isEmpty ||
        endDateController.text.isEmpty ||
        reasonController.text.isEmpty) {
      Alertdialog.show(
        animasi: AppAssets.lottieFailed,
        message: "Data tidak lengkap",
      );
      return;
    }

    validateDates();
    calculateDuration();
    validateLeaveBalance();

    if (startDateError.value.isNotEmpty ||
        endDateError.value.isNotEmpty ||
        reasonError.value.isNotEmpty ||
        leaveError.value.isNotEmpty ||
        durationDays.value == 0) {
      return;
    }

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
    } catch (_) {
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
    durationDays.value = 0;
    startDateError.value = "";
    endDateError.value = "";
    reasonError.value = "";
    leaveError.value = "";
    checkFormReady();
  }

  @override
  void onClose() {
    reasonController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }
}
