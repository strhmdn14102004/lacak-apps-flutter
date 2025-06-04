import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:lacak_by_sasat/api/api_manager.dart";
import "package:lacak_by_sasat/api/endpoint/sign_in/sign_in_response.dart";
import "package:lacak_by_sasat/constant/api_url.dart";
import "package:lacak_by_sasat/constant/preference_key.dart";
import "package:lacak_by_sasat/module/sign_in/sign_in_event.dart";
import "package:lacak_by_sasat/module/sign_in/sign_in_state.dart";
import "package:shared_preferences/shared_preferences.dart";

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial()) {
    on<SignInSubmit>((event, emit) async {
      try {
        emit(SignInSubmitLoading());

        final response = await ApiManager.signIn(
          signInRequest: event.signInRequest,
        );

        if (response.statusCode == 200) {
          final responseData = SigninResponse.fromJson(response.data);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(PreferenceKey.TOKEN.name, responseData.token);
          await prefs.setString(PreferenceKey.PAIRING_CODE.name,responseData.pairingCode,);
          await _sendFcmToken();
          emit(SignInSubmitSuccess(responseData));
        } else {
          final errorMessage = response.data is Map
              ? response.data["error"] ?? "Login failed. Please try again."
              : "Login failed. Please try again.";
          emit(SignInSubmitError(errorMessage));
        }
      } on DioException catch (e) {
        String errorMessage;
        if (e.response != null) {
          if (e.response!.data is Map) {
            errorMessage = e.response!.data["error"] ??
                "Login failed (Status: ${e.response?.statusCode})";
          } else {
            errorMessage = e.response?.statusMessage ??
                "Login failed (Status: ${e.response?.statusCode})";
          }

          if (kDebugMode) {
            print("*** Dio Error Response ***");
            print("uri: ${e.requestOptions.uri}");
            print("Status: ${e.response?.statusCode}");
            print("Data: ${e.response?.data}");
            print("Headers: ${e.response?.headers}");
          }
        } else {
          errorMessage = e.message ?? "Password or email is incorrect";
        }
        emit(SignInSubmitError(errorMessage));
      } catch (e) {
        if (kDebugMode) {
          print("SignIn Error: $e");
        }
        emit(SignInSubmitError("An unexpected error occurred"));
      }
    });
  }
  Future<void> _sendFcmToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fcmToken = prefs.getString("fcm_token");
      final authToken = prefs.getString(PreferenceKey.TOKEN.name);

      if (fcmToken != null && authToken != null) {
        final dio = await ApiManager.getDio();
        dio.options.headers["Authorization"] = "Bearer $authToken";

        await dio.post(
          ApiUrl.FCM_TOKEN.path,
          data: {"fcmToken": fcmToken},
        );

        if (kDebugMode) {
          print("FCM token updated successfully");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error sending FCM token: $e");
      }
    }
  }
}
