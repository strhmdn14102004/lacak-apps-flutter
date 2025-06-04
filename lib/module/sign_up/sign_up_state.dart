// sign_up_state.dart
import "package:lacak_by_sasat/api/endpoint/sign_up/sign_up_response.dart";

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final SignUpResponse response;

  SignUpSuccess({required this.response});
}

class SignUpError extends SignUpState {
  final String message;

  SignUpError({required this.message});
}
