import 'package:hr_attendance/core/utils/extensions.dart';

class LeaveHistoryModel {
  final String startDate;
  final String endDate;
  final String leaveDate; 
  final String reason;
  final String hrNote;
  final String approvedBy;
  final String status;

  LeaveHistoryModel({
    required this.startDate,
    required this.endDate,
    required this.leaveDate,
    required this.reason,
    required this.hrNote,
    required this.approvedBy,
    required this.status,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) {
    final start = (json['start_date'] ?? "-").toString();
    final end = (json['end_date'] ?? "-").toString();

    return LeaveHistoryModel(
      startDate: start,
      endDate: end,
      leaveDate: start.toFormattedLeaveRange(end),
      reason: json['reason'] ?? "-",
      hrNote: (json['hr_note'] == null || json['hr_note'] == "")
          ? ""
          : json['hr_note'],
      approvedBy: json['approved_by'] ?? "-",
      status: json['status'] ?? "-",
    );
  }
}