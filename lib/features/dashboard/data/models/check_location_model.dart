class CheckLocationResponse {
  final bool isNear;
  final double distanceMeters;
  final double maxDistanceMeters;
  final double officeLat;
  final double officeLng;

  CheckLocationResponse({
    required this.isNear,
    required this.distanceMeters,
    required this.maxDistanceMeters,
    required this.officeLat,
    required this.officeLng,
  });

  factory CheckLocationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return CheckLocationResponse(
      isNear: data['is_near'] ?? false,
      distanceMeters: (data['distance_meters'] ?? 0).toDouble(),
      maxDistanceMeters: (data['max_distance_meters'] ?? 0).toDouble(),
      officeLat: (data['office_lat'] ?? 0).toDouble(),
      officeLng: (data['office_lng'] ?? 0).toDouble(),
    );
  }
}