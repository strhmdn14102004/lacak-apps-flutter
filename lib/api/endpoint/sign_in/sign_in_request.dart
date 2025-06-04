class SignInRequest {
  final String email;
  final String password;
  final String imei;

  SignInRequest({
    required this.email,
    required this.password,
    required this.imei,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "imei": imei,
      };
}
