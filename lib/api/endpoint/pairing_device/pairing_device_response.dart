class PairingDeviceResponse {
  bool success;
  String message;
  Device device;
  String secondaryToken;

  PairingDeviceResponse({
    required this.success,
    required this.message,
    required this.device,
    required this.secondaryToken,
  });

  factory PairingDeviceResponse.fromJson(Map<String, dynamic> json) =>
      PairingDeviceResponse(
        success: json["success"],
        message: json["message"],
        device: Device.fromJson(json["device"]),
        secondaryToken: json["secondaryToken"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "device": device.toJson(),
        "secondaryToken": secondaryToken,
      };
}

class Device {
  String id;
  String name;
  String imei;

  Device({
    required this.id,
    required this.name,
    required this.imei,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["id"],
        name: json["name"],
        imei: json["imei"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imei": imei,
      };
}
