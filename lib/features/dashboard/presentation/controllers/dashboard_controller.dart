import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/get_attendance_history_usecase.dart';
import '../../data/models/attendance_model.dart';

class DashboardController extends GetxController {
  final GetAttendanceHistoryUsecase getAttendanceHistoryUsecase;

  DashboardController(this.getAttendanceHistoryUsecase);

  // =============================
  // CAROUSEL
  // =============================
  final PageController pageController =
      PageController(viewportFraction: 0.94);

  final RxInt currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  // =============================
  // ATTENDANCE STATE (NEW)
  // =============================

  final RxList<AttendanceModel> attendanceList =
      <AttendanceModel>[].obs;

  final RxBool isAttendanceLoading = false.obs;
  final RxBool isAttendanceError = false.obs;

  Future<void> fetchAttendance() async {
    try {
      isAttendanceLoading.value = true;
      isAttendanceError.value = false;

      final result = await getAttendanceHistoryUsecase();
      attendanceList.value = result;
    } catch (e) {
      isAttendanceError.value = true;
    } finally {
      isAttendanceLoading.value = false;
    }
  }

  // =============================
  // MODAL CONTROLLER (TIDAK DIUBAH)
  // =============================

  final TextEditingController modalTextController =
      TextEditingController();
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
    super.onInit();
    fetchAttendance(); // NEW
  }

  @override
  void onClose() {
    pageController.dispose();
    modalTextController.dispose();
    super.onClose();
  }
}
