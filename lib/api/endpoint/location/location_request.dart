class LocationRequest {
  double latitude;
  double longitude;

  LocationRequest({
    required this.latitude,
    required this.longitude,
  });

  factory LocationRequest.fromJson(Map<String, dynamic> json) =>
      LocationRequest(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
