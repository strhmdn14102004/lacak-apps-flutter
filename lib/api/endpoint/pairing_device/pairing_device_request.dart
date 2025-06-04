class PairingDeviceRequest {
  String pairingCode;
  String imei;
  String fcmToken;
  String deviceName;

  PairingDeviceRequest({
    required this.pairingCode,
    required this.imei,
    required this.fcmToken,
    required this.deviceName,
  });

  factory PairingDeviceRequest.fromJson(Map<String, dynamic> json) =>
      PairingDeviceRequest(
        pairingCode: json["pairingCode"],
        imei: json["imei"],
        fcmToken: json["fcmToken"],
        deviceName: json["deviceName"],
      );

  Map<String, dynamic> toJson() => {
        "pairingCode": pairingCode,
        "imei": imei,
        "fcmToken": fcmToken,
        "deviceName": deviceName,
      };
}
