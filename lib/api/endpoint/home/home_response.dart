class HomeResponse {
  User user;
  Device primaryDevice;
  List<Device> pairedDevices;

  HomeResponse({
    required this.user,
    required this.primaryDevice,
    required this.pairedDevices,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
        user: User.fromJson(json["user"]),
        primaryDevice: Device.fromJson(json["primaryDevice"]),
        pairedDevices: List<Device>.from(
          json["pairedDevices"].map((x) => Device.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "primaryDevice": primaryDevice.toJson(),
        "pairedDevices":
            List<dynamic>.from(pairedDevices.map((x) => x.toJson())),
      };
}

class Device {
  String id;
  String name;
  String imei;
  bool isPrimary;
  DateTime createdAt;

  Device({
    required this.id,
    required this.name,
    required this.imei,
    required this.isPrimary,
    required this.createdAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["id"],
        name: json["name"],
        imei: json["imei"],
        isPrimary: json["isPrimary"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imei": imei,
        "isPrimary": isPrimary,
        "createdAt": createdAt.toIso8601String(),
      };
}

class User {
  String id;
  String name;
  String email;
  String imei;
  String telegramNumber;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.imei,
    required this.telegramNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        imei: json["imei"],
        telegramNumber: json["telegramNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "imei": imei,
        "telegramNumber": telegramNumber,
      };
}
