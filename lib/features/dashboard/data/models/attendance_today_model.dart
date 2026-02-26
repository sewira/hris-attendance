class AttendanceTodayModel {
  final String clockIn;
  final String? clockOut;
  final String clockInStatus;
  final String clockOutStatus;
  final String note;

  AttendanceTodayModel({
    required this.clockIn,
    this.clockOut,
    required this.clockInStatus,
    required this.clockOutStatus,
    required this.note,
  });

  factory AttendanceTodayModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AttendanceTodayModel(
      clockIn: data['clock_in'],
      clockOut: data['clock_out'],
      clockInStatus: data['clock_in_status'] ?? '',
      clockOutStatus: data['clock_out_status'] ?? '',
      note: data['note'] ?? '',
    );
  }
}