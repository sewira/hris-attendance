import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/core/utils/app_storage.dart';
import 'package:hr_attendance/features/attendance_history_shared/data/models/attendance_history_model.dart';
import 'package:hr_attendance/features/attendance_history_shared/domain/usecases/get_attendance_history_month.dart';
import 'package:hr_attendance/features/dashboard/data/models/attendance_today_model.dart';
import 'package:hr_attendance/features/dashboard/data/models/check_location_model.dart';
import 'package:hr_attendance/features/dashboard/data/models/leave_history_model.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/check_location_usecase.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/clock_in_usecase.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/clock_out_usecase.dart';
import 'package:hr_attendance/shared/widgets/alert_dialog.dart';
import 'package:hr_attendance/shared/widgets/loading_dialog.dart';
import '../../domain/usecases/get_leave_history.dart';

class DashboardController extends GetxController {
  final GetAttendanceHistoryMonthUsecase getAttendanceHistoryUsecase;
  final GetLeaveHistoryUsecase getLeaveHistoryUsecase;
  final ClockInUsecase clockInUsecase;
  final CheckLocationUsecase checkLocationUsecase;
  final ClockOutUsecase clockOutUsecase;

  DashboardController(
    this.getAttendanceHistoryUsecase,
    this.getLeaveHistoryUsecase,
    this.clockInUsecase,
    this.checkLocationUsecase,
    this.clockOutUsecase,
  );

  // Carousel
  late PageController pageController;
  final RxInt currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
    AppStorage.saveCardIndex(index);
  }

  // Absensi
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
      isAttendanceError.value = true;
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

  // Cuti
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

  // Modal
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

  // Check Location
  Future<CheckLocationResponse?> checkLocation({
    required double lat,
    required double lng,
  }) async {
    try {
      LoadingDialog.show();
      final result = await checkLocationUsecase(lat: lat, lng: lng);
      LoadingDialog.close();
      return result;
    } catch (e) {
      LoadingDialog.close();
      final error = e.toString().replaceAll('Exception: ', '');
      Alertdialog.show(animasi: AppAssets.lottieFailed, message: error);
      return null;
    }
  }

  // Clock In / Clock Out
  final RxString todayClockIn = "-".obs;
  final RxString todayClockOut = "-".obs;
  final RxBool isClockInDone = false.obs;
  final RxBool isClockOutDone = false.obs;
  final Rx<AttendanceTodayModel?> todayAttendance = Rx<AttendanceTodayModel?>(null);
  Timer? _midnightTimer;

  String formatTime(String? isoString) {
    if (isoString == null) return "-";
    final dt = DateTime.parse(isoString).toLocal();
    return "${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}";
  }

  Future<void> clockIn(File photo) async {
    try {
      LoadingDialog.show();
      final result = await clockInUsecase(photo);
      LoadingDialog.close();

      todayAttendance.value = result;
      todayClockIn.value = formatTime(result.clockIn);
      isClockInDone.value = true;

      await AppStorage.saveClockIn(result.clockIn);

      Alertdialog.show(animasi: AppAssets.lottieSuccess, message: 'Clock in berhasil');
      fetchAttendance();
    } catch (e) {
      LoadingDialog.close();
      final error = e.toString().replaceAll('Exception: ', '');
      Alertdialog.show(animasi: AppAssets.lottieFailed, message: error);
    }
  }

  Future<void> clockOut({String? note}) async {
    try {
      LoadingDialog.show();
      await clockOutUsecase(note: note);
      LoadingDialog.close();

      final now = DateTime.now();
      todayClockOut.value = "${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}";
      isClockOutDone.value = true;

      await AppStorage.saveClockOut(now.toIso8601String());

      Alertdialog.show(animasi: AppAssets.lottieSuccess, message: 'Clock out berhasil', showButton: false);
      fetchAttendance();
    } catch (e) {
      LoadingDialog.close();
      final error = e.toString().replaceAll('Exception: ', '');
      Alertdialog.show(animasi: AppAssets.lottieFailed, message: error);
    }
  }

  @override
  void onInit() {
    super.onInit();

    final savedIndex = AppStorage.getCardIndex();
    pageController = PageController(viewportFraction: 0.94, initialPage: savedIndex);
    currentPage.value = savedIndex;

    fetchAttendance();
    fetchLeave();

    todayClockIn.value = formatTime(AppStorage.getClockIn());
    todayClockOut.value = formatTime(AppStorage.getClockOut());
    isClockInDone.value = AppStorage.getIsClockInDone();
    isClockOutDone.value = AppStorage.getIsClockOutDone();

    _setupMidnightReset();
  }

  void _setupMidnightReset() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final duration = nextMidnight.difference(now);

    _midnightTimer?.cancel();
    _midnightTimer = Timer(duration, () {
      todayAttendance.value = null;
      todayClockIn.value = "-";
      todayClockOut.value = "-";
      isClockInDone.value = false;
      isClockOutDone.value = false;
      currentPage.value = 0;

      AppStorage.resetCardIndex();
      AppStorage.resetClockState();

      _setupMidnightReset();
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    _attendanceDebounce?.cancel();
    _leaveDebounce?.cancel();
    _midnightTimer?.cancel();
    super.onClose();
  }
}