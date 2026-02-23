import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/features/attendance_history_shared/data/models/attendance_history_model.dart';
import 'package:hr_attendance/features/attendance_history_shared/domain/usecases/get_attendance_history_month.dart';
import 'package:hr_attendance/features/dashboard/data/models/leave_history_model.dart';
import '../../domain/usecases/get_leave_history.dart';

class DashboardController extends GetxController {
  final GetAttendanceHistoryMonthUsecase getAttendanceHistoryUsecase;
  final GetLeaveHistoryUsecase getLeaveHistoryUsecase;

  DashboardController(
    this.getAttendanceHistoryUsecase,
    this.getLeaveHistoryUsecase,
  );

  //carrosel
  final PageController pageController = PageController(viewportFraction: 0.94);
  final RxInt currentPage = 0.obs;
  void onPageChanged(int index) => currentPage.value = index;

  //absensi
  final RxList<AttendanceModel> attendanceList = <AttendanceModel>[].obs;
  final RxBool isAttendanceLoading = false.obs;
  final RxBool isAttendanceError = false.obs;
  final RxBool isSearchingAttendance = false.obs;

  Timer? _attendanceDebounce;

  void onAttendanceSearchChanged(String value) {
    isSearchingAttendance.value = value.trim().isNotEmpty;

    _attendanceDebounce?.cancel();
    _attendanceDebounce = Timer(
      const Duration(milliseconds: 500),
      () => fetchAttendance(search: value),
    );
  }

  Future<void> fetchAttendance({String? search}) async {
    try {
      isAttendanceLoading.value = true;
      isAttendanceError.value = false;

      final result = await getAttendanceHistoryUsecase(search: search);

      attendanceList.assignAll(result);
    } catch (_) {
      attendanceList.clear();
      isAttendanceError.value = false;
    } finally {
      isAttendanceLoading.value = false;
    }
  }

  String get attendanceEmptyMessage {
    if (isAttendanceLoading.value) return "";
    if (isAttendanceError.value) return "Gagal memuat data";

    if (attendanceList.isEmpty) {
      return isSearchingAttendance.value
          ? "Data tidak ditemukan"
          : "Belum ada data absensi";
    }

    return "";
  }

  //cuti
  final RxList<LeaveHistoryModel> leaveList = <LeaveHistoryModel>[].obs;
  final RxBool isLeaveLoading = false.obs;
  final RxBool isLeaveError = false.obs;
  final RxBool isSearchingLeave = false.obs;

  Timer? _leaveDebounce;

  void onLeaveSearchChanged(String value) {
    isSearchingLeave.value = value.trim().isNotEmpty;

    _leaveDebounce?.cancel();
    _leaveDebounce = Timer(
      const Duration(milliseconds: 500),
      () => fetchLeave(search: value),
    );
  }

  Future<void> fetchLeave({String? search}) async {
    try {
      isLeaveLoading.value = true;
      isLeaveError.value = false;

      final result = await getLeaveHistoryUsecase(search: search);

      leaveList.assignAll(result);
    } catch (_) {
      leaveList.clear();
      isLeaveError.value = true;
    } finally {
      isLeaveLoading.value = false;
    }
  }

  String get leaveEmptyMessage {
    if (isLeaveLoading.value) return "";
    if (isLeaveError.value) return "Gagal memuat data";

    if (leaveList.isEmpty) {
      return isSearchingLeave.value
          ? "Data tidak ditemukan"
          : "Belum ada data cuti";
    }

    return "";
  }


  //modal
  final TextEditingController modalTextController = TextEditingController();
  final RxBool isModalValid = false.obs;
  final RxBool isOverLimit = false.obs;
  final RxInt modalLength = 0.obs;
  final RxString modalMessage = "".obs;
  int modalMaxLength = 50;

  void onModalChanged(String value) {
    modalLength.value = value.length;
    isModalValid.value = value.trim().isNotEmpty;
    isOverLimit.value = value.length > modalMaxLength;
    modalMessage.value = "";
  }

  void validateSubmit() {
    if (modalTextController.text.trim().isEmpty) {
      modalMessage.value = "isi catatan terlebih dahulu";
      return;
    }
    if (modalTextController.text.length > modalMaxLength) {
      modalMessage.value = "karakter melebihi batas";
      return;
    }
  }

  String get modalText => modalTextController.text;

  void resetModal() {
    modalTextController.clear();
    modalLength.value = 0;
    isModalValid.value = false;
    isOverLimit.value = false;
    modalMessage.value = "";
  }


  @override
  void onInit() {
    fetchAttendance();
    fetchLeave();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    _attendanceDebounce?.cancel();
    _leaveDebounce?.cancel();
    super.onClose();
  }
}
