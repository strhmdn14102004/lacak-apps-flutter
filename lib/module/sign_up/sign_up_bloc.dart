// sign_up_bloc.dart
import "dart:convert";

import "package:flutter_bloc/flutter_bloc.dart";
import "package:lacak_by_sasat/api/api_manager.dart";
import "package:lacak_by_sasat/api/endpoint/sign_up/sign_up_response.dart";
import "package:lacak_by_sasat/module/sign_up/sign_up_event.dart";
import "package:lacak_by_sasat/module/sign_up/sign_up_state.dart";

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SubmitSignUp>((event, emit) async {
      emit(SignUpLoading());

      try {
        final response = await ApiManager.signUp(signUpRequest: event.request);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.data);
          final signUpResponse = SignUpResponse.fromJson(data);
          emit(SignUpSuccess(response: signUpResponse));
        } else {
          final data = response.data;
          final message =
              data is String ? data : data["message"] ?? "Sign up failed.";
          emit(SignUpError(message: message));
        }
      } catch (e) {
        emit(SignUpError(message: e.toString()));
      }
    });
  }
}
