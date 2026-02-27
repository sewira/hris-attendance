class ProfileModel {
  final String fullName;
  final String email;
  final String department;
  final int leaveBalance;
  final int annualLeaveQuota;
  final String? todayClockIn;
  final String? todayClockOut;
  final String employmentDuration;
  final int totalLeavesTaken;
  final String phone;
  final String nik;
  final String status;
  final String role;

  ProfileModel({
    required this.fullName,
    required this.email,
    required this.department,
    required this.leaveBalance,
    required this.annualLeaveQuota,
    required this.todayClockIn,
    required this.todayClockOut,
    required this.employmentDuration,
    required this.totalLeavesTaken,
    required this.phone,
    required this.nik,
    required this.status,
    required this.role,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['full_name'] ?? "",
      email: json['email'] ?? "",
      department: json['department'] ?? "",
      leaveBalance: json['leave_balance'] ?? 0,
      annualLeaveQuota: json['annual_leave_quota'] ?? 0,
      todayClockIn: json['today_clock_in'],
      todayClockOut: json['today_clock_out'],
      employmentDuration: json['employment_duration'] ?? "",
      totalLeavesTaken: json['total_leaves_taken'] ?? 0,
      phone: json['phone'] ?? "",
      nik: json['nik'] ?? "",
      status: json['status'] ?? "",
      role: json['role'] ?? "",
    );
  }
}