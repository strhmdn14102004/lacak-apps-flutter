class SignUpResponse {
  User user;
  String token;
  String pairingCode;
  PrimaryDevice primaryDevice;

  SignUpResponse({
    required this.user,
    required this.token,
    required this.pairingCode,
    required this.primaryDevice,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) => SignUpResponse(
        user: User.fromJson(json["user"]),
        token: json["token"],
        pairingCode: json["pairingCode"],
        primaryDevice: PrimaryDevice.fromJson(json["primaryDevice"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
        "pairingCode": pairingCode,
        "primaryDevice": primaryDevice.toJson(),
      };
}

class PrimaryDevice {
  String id;
  String name;
  String imei;
  String pairingCode;
  bool isPrimary;
  String userId;
  DateTime updatedAt;
  DateTime createdAt;
  dynamic fcmToken;

  PrimaryDevice({
    required this.id,
    required this.name,
    required this.imei,
    required this.pairingCode,
    required this.isPrimary,
    required this.userId,
    required this.updatedAt,
    required this.createdAt,
    required this.fcmToken,
  });

  factory PrimaryDevice.fromJson(Map<String, dynamic> json) => PrimaryDevice(
        id: json["id"],
        name: json["name"],
        imei: json["imei"],
        pairingCode: json["pairingCode"],
        isPrimary: json["isPrimary"],
        userId: json["userId"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
        fcmToken: json["fcmToken"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imei": imei,
        "pairingCode": pairingCode,
        "isPrimary": isPrimary,
        "userId": userId,
        "updatedAt": updatedAt.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "fcmToken": fcmToken,
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
