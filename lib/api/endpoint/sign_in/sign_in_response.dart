class SigninResponse {
  User user;
  String token;
  String pairingCode;
  PrimaryDevice primaryDevice;
  List<PairedDevice> pairedDevices;

  SigninResponse({
    required this.user,
    required this.token,
    required this.pairingCode,
    required this.primaryDevice,
    required this.pairedDevices,
  });

  factory SigninResponse.fromJson(Map<String, dynamic> json) => SigninResponse(
        user: User.fromJson(json["user"]),
        token: json["token"],
        pairingCode: json["pairingCode"],
        primaryDevice: PrimaryDevice.fromJson(json["primaryDevice"]),
        pairedDevices: List<PairedDevice>.from(
          json["pairedDevices"].map((x) => PairedDevice.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
        "pairingCode": pairingCode,
        "primaryDevice": primaryDevice.toJson(),
        "pairedDevices":
            List<dynamic>.from(pairedDevices.map((x) => x.toJson())),
      };
}

class PairedDevice {
  String id;
  String name;
  String imei;
  DateTime createdAt;
  String secondaryToken;

  PairedDevice({
    required this.id,
    required this.name,
    required this.imei,
    required this.createdAt,
    required this.secondaryToken,
  });

  factory PairedDevice.fromJson(Map<String, dynamic> json) => PairedDevice(
        id: json["id"],
        name: json["name"],
        imei: json["imei"],
        createdAt: DateTime.parse(json["createdAt"]),
        secondaryToken: json["secondaryToken"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imei": imei,
        "createdAt": createdAt.toIso8601String(),
        "secondaryToken": secondaryToken,
      };
}

class PrimaryDevice {
  String id;
  String name;
  String imei;

  PrimaryDevice({
    required this.id,
    required this.name,
    required this.imei,
  });

  factory PrimaryDevice.fromJson(Map<String, dynamic> json) => PrimaryDevice(
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
