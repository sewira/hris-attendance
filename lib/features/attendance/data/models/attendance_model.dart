class AttendanceModel {
  final String id;
  final String employeeId;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final String date;
  final String status;

  AttendanceModel({
    required this.id,
    required this.employeeId,
    this.clockIn,
    this.clockOut,
    required this.date,
    required this.status,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      clockIn: json['clock_in'] != null
          ? DateTime.parse(json['clock_in'] as String)
          : null,
      clockOut: json['clock_out'] != null
          ? DateTime.parse(json['clock_out'] as String)
          : null,
      date: json['date'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'clock_in': clockIn?.toIso8601String(),
      'clock_out': clockOut?.toIso8601String(),
      'date': date,
      'status': status,
    };
  }

  AttendanceModel copyWith({
    String? id,
    String? employeeId,
    DateTime? clockIn,
    DateTime? clockOut,
    String? date,
    String? status,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}
