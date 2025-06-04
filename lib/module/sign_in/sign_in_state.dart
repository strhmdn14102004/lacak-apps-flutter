import "package:lacak_by_sasat/api/endpoint/sign_in/sign_in_response.dart";

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInSubmitLoading extends SignInState {}

class SignInSubmitSuccess extends SignInState {
  final SigninResponse response;

  SignInSubmitSuccess(this.response);
}

class SignInSubmitError extends SignInState {
  final String message;

  SignInSubmitError(this.message);
}

class SignInSubmitFinished extends SignInState {
  final String message;

  SignInSubmitFinished(this.message);
}