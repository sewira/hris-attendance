class CutiModel {
  final String startDate;
  final String endDate;
  final String reason;

  CutiModel({
    required this.startDate,
    required this.endDate,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      "start_date": startDate,
      "end_date": endDate,
      "reason": reason,
    };
  }
}