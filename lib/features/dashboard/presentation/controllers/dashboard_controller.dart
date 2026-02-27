import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/config/theme/app_assets.dart';
import 'package:hr_attendance/features/attendance_history_shared/data/models/attendance_history_model.dart';
import 'package:hr_attendance/features/attendance_history_shared/domain/usecases/get_attendance_history_month.dart';
import 'package:hr_attendance/features/dashboard/data/models/check_location_model.dart';
import 'package:hr_attendance/features/dashboard/data/models/leave_history_model.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/check_location_usecase.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/clock_in_usecase.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/clock_out_usecase.dart';
import 'package:hr_attendance/features/dashboard/domain/usecases/get_leave_history.dart';
import 'package:hr_attendance/features/profile/presentation/controllers/profile_controller.dart';
import 'package:hr_attendance/shared/widgets/alert_dialog.dart';
import 'package:hr_attendance/shared/widgets/loading_dialog.dart';

class DashboardController extends GetxController with WidgetsBindingObserver {
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

  ProfileController get profileController => Get.find();
  int get leaveBalance => profileController.leaveBalance;
  int get totalLeaveTaken => profileController.totalLeavesTaken;

  //carrosel
  late PageController pageController;
  final RxInt currentPage = 0.obs;
  void onPageChanged(int index) => currentPage.value = index;

  //state card (hari ini)
  final RxString todayClockIn = "-".obs;
  final RxString todayClockOut = "-".obs;
  final RxBool isClockInDone = false.obs;
  final RxBool isClockOutDone = false.obs;

  // attendance list
  final RxList<AttendanceModel> fullAttendanceList = <AttendanceModel>[].obs;
  final RxList<AttendanceModel> filteredAttendanceList = <AttendanceModel>[].obs;

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

      // update full list jika search kosong
      if (search == null || search.isEmpty) {
        fullAttendanceList.assignAll(result);
        // sync state card hanya dari full list
        syncTodayAttendanceFromHistory();
      }

      // update filtered list sesuai search
      if (search != null && search.isNotEmpty) {
        filteredAttendanceList.assignAll(
          result
              .where((e) => e.date
                  .toLowerCase()
                  .contains(search.toLowerCase()))
              .toList(),
        );
      } else {
        filteredAttendanceList.assignAll(result);
      }
    } catch (_) {
      filteredAttendanceList.clear();
      isAttendanceError.value = true;
    } finally {
      isAttendanceLoading.value = false;
    }
  }

  void syncTodayAttendanceFromHistory() {
    final now = DateTime.now();

    try {
      final todayData = fullAttendanceList.firstWhere((e) {
        try {
          final apiDate = DateTime.parse(e.rawDate);
          return apiDate.year == now.year &&
              apiDate.month == now.month &&
              apiDate.day == now.day;
        } catch (_) {
          return false;
        }
      });

      todayClockIn.value =
          todayData.clockIn.trim().isEmpty ? "-" : todayData.clockIn;
      todayClockOut.value =
          todayData.clockOut.trim().isEmpty ? "-" : todayData.clockOut;

      isClockInDone.value = todayClockIn.value != "-";
      isClockOutDone.value = todayClockOut.value != "-";
    } catch (_) {
      todayClockIn.value = "-";
      todayClockOut.value = "-";
      isClockInDone.value = false;
      isClockOutDone.value = false;
    }
  }

  String get attendanceEmptyMessage {
    if (isAttendanceLoading.value) return "";
    if (isAttendanceError.value) return "Gagal memuat data";

    if (filteredAttendanceList.isEmpty) {
      return isSearchingAttendance.value
          ? "Data tidak ditemukan"
          : "Belum ada data absensi";
    }

    return "";
  }

  // leave list
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

  String calculateLeaveDuration(String startDate, String endDate) {
    try {
      if (startDate == "-" || endDate == "-") return "-";

      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);

      if (end.isBefore(start)) return "-";

      final totalDays = end.difference(start).inDays + 1;
      return "$totalDays Hari";
    } catch (_) {
      return "-";
    }
  }

  //cek lokasi
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

  //clock in
  Future<void> clockIn(File photo) async {
    try {
      LoadingDialog.show();
      await clockInUsecase(photo);
      LoadingDialog.close();

      Alertdialog.show(
        animasi: AppAssets.lottieSuccess,
        message: 'Clock in berhasil',
        showButton: false,
      );

      await fetchAttendance(); // refresh full list & filtered
    } catch (e) {
      LoadingDialog.close();
      final error = e.toString().replaceAll('Exception: ', '');
      Alertdialog.show(animasi: AppAssets.lottieFailed, message: error);
    }
  }

  //clock out
  Future<void> clockOut({String? note}) async {
    try {
      LoadingDialog.show();
      await clockOutUsecase(note: note);
      LoadingDialog.close();

      Alertdialog.show(
        animasi: AppAssets.lottieSuccess,
        message: 'Clock out berhasil',
        showButton: false,
      );

      await fetchAttendance(); // refresh full list & filtered
    } catch (e) {
      LoadingDialog.close();
      final error = e.toString().replaceAll('Exception: ', '');
      Alertdialog.show(animasi: AppAssets.lottieFailed, message: error);
    }
  }

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);
    pageController = PageController(viewportFraction: 0.94);

    fetchAttendance();
    fetchLeave();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchAttendance();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    pageController.dispose();
    _attendanceDebounce?.cancel();
    _leaveDebounce?.cancel();
    super.onClose();
  }
}