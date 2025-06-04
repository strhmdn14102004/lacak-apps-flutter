class SignUpRequest {
  final String name;
  final String email;
  final String password;
  final String telegramNumber;
  final String imei;

  SignUpRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.telegramNumber,
    required this.imei,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "telegramNumber": telegramNumber,
        "imei": imei,
      };
}
