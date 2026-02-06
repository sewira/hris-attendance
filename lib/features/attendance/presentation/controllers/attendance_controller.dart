import 'package:get/get.dart';
import '../../data/models/attendance_model.dart';
import '../../domain/usecases/clock_in_usecase.dart';
import '../../domain/usecases/clock_out_usecase.dart';
import '../../domain/usecases/get_today_attendance_usecase.dart';

class AttendanceController extends GetxController {
  final ClockInUsecase _clockInUsecase;
  final ClockOutUsecase _clockOutUsecase;
  final GetTodayAttendanceUsecase _getTodayAttendanceUsecase;

  AttendanceController({
    required ClockInUsecase clockInUsecase,
    required ClockOutUsecase clockOutUsecase,
    required GetTodayAttendanceUsecase getTodayAttendanceUsecase,
  })  : _clockInUsecase = clockInUsecase,
        _clockOutUsecase = clockOutUsecase,
        _getTodayAttendanceUsecase = getTodayAttendanceUsecase;

  // State
  Rx<AttendanceModel?> todayAttendance = Rx<AttendanceModel?>(null);
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString currentTime = ''.obs;

  final String employeeId = 'employee_001';

  @override
  void onInit() {
    super.onInit();
    _updateCurrentTime();
    fetchTodayAttendance();
  }

  void _updateCurrentTime() {
    ever(currentTime, (_) {});
    _tick();
  }

  void _tick() async {
    while (true) {
      final now = DateTime.now();
      currentTime.value =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  bool get hasClockedIn => todayAttendance.value?.clockIn != null;
  bool get hasClockedOut => todayAttendance.value?.clockOut != null;

  Future<void> fetchTodayAttendance() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getTodayAttendanceUsecase.call(employeeId);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (data) {
        todayAttendance.value = data;
        isLoading.value = false;
      },
    );
  }

  Future<void> clockIn() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _clockInUsecase.call(employeeId);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
        Get.snackbar('Error', failure.message);
      },
      (data) {
        todayAttendance.value = data;
        isLoading.value = false;
        Get.snackbar('Success', 'Clocked in successfully');
      },
    );
  }

  Future<void> clockOut() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _clockOutUsecase.call(employeeId);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
        Get.snackbar('Error', failure.message);
      },
      (data) {
        todayAttendance.value = data;
        isLoading.value = false;
        Get.snackbar('Success', 'Clocked out successfully');
      },
    );
  }
}
