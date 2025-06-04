import "package:lacak_by_sasat/api/endpoint/sign_up/sign_up_request.dart";

abstract class SignUpEvent {}

class SubmitSignUp extends SignUpEvent {
  final SignUpRequest request;

  SubmitSignUp({required this.request});
}
