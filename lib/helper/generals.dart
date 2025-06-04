// ignore_for_file: use_build_context_synchronously, cascade_invocations, always_specify_types, depend_on_referenced_packages, avoid_print

import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:go_router/go_router.dart";
import "package:lacak_by_sasat/constant/preference_key.dart";
import "package:lacak_by_sasat/helper/preferences.dart";
import "package:shared_preferences/shared_preferences.dart";

class Generals {
  static BuildContext? context() {
    return Get.context;
  }

  static GlobalKey<NavigatorState> navigatorState() {
    return Get.key;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(PreferenceKey.TOKEN.name);
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PreferenceKey.TOKEN.name);
    context()!.go("/sign-in");
   
  }

  static void signOut() async {
    if (context() != null) {
      if (Preferences.contain(PreferenceKey.TOKEN)) {
        await Preferences.remove(PreferenceKey.TOKEN);

        context()!.go("/sign-in");
      }
    }
  }

  static void changeLanguage({
    required String locale,
  }) async {
    if (context() != null) {
      context()!.setLocale(Locale.fromSubtags(languageCode: locale));

      Locale newLocale = Locale(locale);

      await context()!.setLocale(newLocale);

      Get.updateLocale(newLocale);
    }
  }
}
