import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hr_attendance/features/attendance_history_shared/data/models/attendance_history_model.dart';
import 'package:hr_attendance/features/attendance_history_shared/domain/usecases/get_all_attendance.dart';
import 'package:hr_attendance/features/profile/data/models/profile_model.dart';
import 'package:hr_attendance/features/profile/domain/usecase/get_profile_usecase.dart';

class ProfileController extends GetxController {
  final TextEditingController filterDateController = TextEditingController();

  final GetProfileUsecase getProfileUsecase;
  final GetAllAttendanceHistoryUsecase getAllAttendanceUsecase;

  ProfileController(
    this.getProfileUsecase,
    this.getAllAttendanceUsecase,
  );

  // ================= PROFILE =================
  final RxBool isLoading = false.obs;
  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();

  // ================= ATTENDANCE =================
  final RxList<AttendanceModel> attendanceList = <AttendanceModel>[].obs;
  final RxBool isAttendanceLoading = false.obs;
  final RxBool isAttendanceError = false.obs;
  final RxString attendanceSearchQuery = "".obs;
  final RxBool isSearching = false.obs;

  Timer? _debounce;

  @override
  void onInit() {
    fetchProfile();
    fetchAllAttendance();
    super.onInit();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    filterDateController.dispose();
    super.onClose();
  }

  // ================= FETCH PROFILE =================
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final result = await getProfileUsecase();
      profile.value = result;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= FETCH ALL ATTENDANCE =================
  Future<void> fetchAllAttendance({String? search}) async {
    try {
      isAttendanceLoading.value = true;
      isAttendanceError.value = false;

      final result = await getAllAttendanceUsecase(search: search);
      attendanceList.assignAll(result);
    } catch (e) {
      attendanceList.clear();
      isAttendanceError.value = false;
    } finally {
      isAttendanceLoading.value = false;
    }
  }

  // ================= SEARCH =================
  void onSearchChanged(String value) {
    attendanceSearchQuery.value = value;
    isSearching.value = value.isNotEmpty;

    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => fetchAllAttendance(search: value),
    );
  }

  // ================= EMPTY MESSAGE HANDLER =================
  String get attendanceEmptyMessage {
    if (isAttendanceLoading.value) return "";
    if (isAttendanceError.value) return "Gagal memuat data";

    if (attendanceList.isEmpty) {
      return isSearching.value
          ? "Data tidak ditemukan"
          : "Belum ada data absensi";
    }

    return "";
  }

int get leaveBalance =>
    profile.value?.leaveBalance ?? 0;
}