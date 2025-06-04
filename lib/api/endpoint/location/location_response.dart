class LocationResponse {
  String id;
  double latitude;
  double longitude;
  dynamic accuracy;
  DateTime timestamp;
  String deviceId;
  bool isRealTimeRequest;
  DateTime createdAt;
  DateTime updatedAt;
  List<LocationResponse>? previousLocations;

  LocationResponse({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
    required this.deviceId,
    required this.isRealTimeRequest,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocationResponse.fromJson(Map<String, dynamic> json) =>
      LocationResponse(
        id: json["id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        accuracy: json["accuracy"],
        timestamp: DateTime.parse(json["timestamp"]),
        deviceId: json["deviceId"],
        isRealTimeRequest: json["isRealTimeRequest"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "accuracy": accuracy,
        "timestamp": timestamp.toIso8601String(),
        "deviceId": deviceId,
        "isRealTimeRequest": isRealTimeRequest,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
