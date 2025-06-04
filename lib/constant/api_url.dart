// ignore_for_file: non_constant_identifier_names, constant_identifier_names

const String MAIN_BASE = "https://tracker-sasat.up.railway.app/api/";
const String SECONDARY_BASE = "https://tracker-sasat.up.railway.app/api/";

enum ApiUrl {
  SIGN_IN("auth/login"),
  SIGN_UP("auth/register"),
  PAIRING_DEVICE("devices/pair"),
  FCM_TOKEN("devices/fcm-token"),
  HOME("home"),
  RESET_ACCOUNT_LOCK("home/reset-lock"),
  RESET_IMEI_ACCOUNT("auth/reset-password-with-imei"),
  LOCATION("locations");

  final String path;

  const ApiUrl(this.path);
}
