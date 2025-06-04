import "dart:io";

import "package:base/base.dart";
import "package:device_info_plus/device_info_plus.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:lacak_by_sasat/api/endpoint/sign_up/sign_up_request.dart";
import "package:lacak_by_sasat/module/sign_up/sign_up_bloc.dart";
import "package:lacak_by_sasat/module/sign_up/sign_up_event.dart";
import "package:lacak_by_sasat/module/sign_up/sign_up_state.dart";
import "package:loader_overlay/loader_overlay.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final TextEditingController tecName = TextEditingController();
  final TextEditingController tecEmail = TextEditingController();
  final TextEditingController tecPassword = TextEditingController();
  final TextEditingController tecTelegramNumber = TextEditingController();

  String imei = "";
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    getImei();
  }

  Future<void> getImei() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      setState(() {
        imei = androidInfo.id;
      });
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      setState(() {
        imei = iosInfo.identifierForVendor ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) async {
        if (state is SignUpLoading) {
          context.loaderOverlay.show();
        } else if (state is SignUpSuccess) {
          context.go("/");
        } else if (state is SignUpError) {
          context.loaderOverlay.hide();
          BaseOverlays.error(message: state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("sign_up".tr()),
          leading: IconButton(
            icon: Icon(
              Icons.turn_left_rounded,
              size: Dimensions.size30,
            ),
            onPressed: () {
              context.pop();
            },
          ),
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.size20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimensions.size80),
                Text(
                  "sign_up".tr(),
                  style: TextStyle(
                    fontSize: Dimensions.text24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface(),
                  ),
                ),
                Text(
                  "create_your_new_account".tr(),
                  style: TextStyle(
                    fontSize: Dimensions.text20,
                    color: AppColors.onSurface(),
                  ),
                ),
                SizedBox(height: Dimensions.size20),
                Form(
                  key: formState,
                  child: Column(
                    children: [
                      BaseWidgets.text(
                        mandatory: true,
                        readonly: false,
                        controller: tecName,
                        label: "full_name".tr(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      SizedBox(height: Dimensions.size15),
                      BaseWidgets.text(
                        mandatory: true,
                        readonly: false,
                        controller: tecEmail,
                        label: "email_address".tr(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      SizedBox(height: Dimensions.size15),
                      BaseWidgets.text(
                        mandatory: true,
                        readonly: false,
                        controller: tecTelegramNumber,
                        label: "telegram_number".tr(),
                        prefixIcon: Icon(Icons.telegram),
                      ),
                      SizedBox(height: Dimensions.size15),
                      BaseWidgets.text(
                        mandatory: true,
                        readonly: false,
                        controller: tecPassword,
                        label: "password".tr(),
                        obscureText: obscurePassword,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: Dimensions.size30),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (formState.currentState!.validate()) {
                              final request = SignUpRequest(
                                name: tecName.text,
                                email: tecEmail.text,
                                password: tecPassword.text,
                                telegramNumber: tecTelegramNumber.text,
                                imei: imei,
                              );

                              context.read<SignUpBloc>().add(
                                    SubmitSignUp(request: request),
                                  );
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.tertiary(),
                            foregroundColor: AppColors.onTertiary(),
                          ),
                          child: Text("sign_up".tr()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
