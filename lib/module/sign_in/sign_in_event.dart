  import "package:lacak_by_sasat/api/endpoint/sign_in/sign_in_request.dart";

  abstract class SignInEvent {}

  class SignInSubmit extends SignInEvent {
    final SignInRequest signInRequest;

    SignInSubmit({
      required this.signInRequest,
    });
  }

  class SendFcmTokenEvent extends SignInEvent {
    final String token;

    SendFcmTokenEvent({required this.token});
  }
