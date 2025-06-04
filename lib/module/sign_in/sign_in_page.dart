// ignore_for_file: use_build_context_synchronously, always_specify_types

import "dart:io";

import "package:base/base.dart";
import "package:device_info_plus/device_info_plus.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:go_router/go_router.dart";
import "package:lacak_by_sasat/api/endpoint/sign_in/sign_in_request.dart";
import "package:lacak_by_sasat/helper/generals.dart";
import "package:lacak_by_sasat/module/sign_in/sign_in_bloc.dart";
import "package:lacak_by_sasat/module/sign_in/sign_in_event.dart";
import "package:lacak_by_sasat/module/sign_in/sign_in_state.dart";
import "package:loader_overlay/loader_overlay.dart";
import "package:smooth_corner/smooth_corner.dart";

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> with WidgetsBindingObserver {
  final TextEditingController tecEmailAddress = TextEditingController();
  final TextEditingController tecPassword = TextEditingController();

  final GlobalKey<FormState> formState =
      GlobalKey<FormState>(debugLabel: "formState");
  String imei = "";
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    getImei();
    WidgetsBinding.instance.addObserver(this);
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
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) async {
        if (state is SignInSubmitLoading) {
          context.loaderOverlay.show();
        } else if (state is SignInSubmitSuccess) {
          context.go("/home");
        } else if (state is SignInSubmitError) {
          BaseOverlays.error(message: state.message);
          context.loaderOverlay.hide();
        } else if (state is SignInSubmitFinished) {
          BaseOverlays.error(message: state.message);
          context.loaderOverlay.hide();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.surface(),
          statusBarIconBrightness: AppColors.brightnessInverse(),
          systemNavigationBarColor: AppColors.surface(),
          systemNavigationBarIconBrightness: AppColors.brightnessInverse(),
        ),
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(Dimensions.size20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimensions.size50),
                    Center(
                      child: SvgPicture.asset(
                        "assets/svg/location_track.svg",
                        width: 200,
                        height: 150,
                      ),
                    ),
                    SizedBox(height: Dimensions.size50),
                    Text(
                      "welcome".tr(),
                      style: TextStyle(
                        color: AppColors.onSurface(),
                        fontSize: Dimensions.text24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "sign_in_with_your_account".tr(),
                      style: TextStyle(
                        color: AppColors.onSurface(),
                        fontSize: Dimensions.text20,
                      ),
                    ),
                    SizedBox(height: Dimensions.size20),
                    Form(
                      key: formState,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BaseWidgets.text(
                            mandatory: true,
                            readonly: false,
                            controller: tecEmailAddress,
                            label: "email_address".tr(),
                            prefixIcon: Icon(Icons.alternate_email),
                          ),
                          SizedBox(height: Dimensions.size15),
                          BaseWidgets.text(
                            mandatory: true,
                            readonly: false,
                            controller: tecPassword,
                            label: "password".tr(),
                            prefixIcon: Icon(Icons.password),
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
                            obscureText: obscurePassword,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.size15),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "dont_have_an_account".tr(),
                            style: TextStyle(
                              color: AppColors.onSurface(),
                              fontSize: Dimensions.text14,
                            ),
                          ),
                          WidgetSpan(
                            child: SizedBox(
                              width: Dimensions.size5,
                            ),
                          ),
                          TextSpan(
                            text: "create_here".tr(),
                            style: TextStyle(
                              color: AppColors.onSurface(),
                              fontSize: Dimensions.text14,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await context.push("/sign-up");
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.size30),
                    Center(
                      child: SizedBox(
                        width: 200,
                        child: FilledButton(
                          onPressed: () async {
                            if (formState.currentState != null &&
                                formState.currentState!.validate()) {
                              formState.currentState!.save();

                              context.read<SignInBloc>().add(
                                    SignInSubmit(
                                      signInRequest: SignInRequest(
                                        email: tecEmailAddress.text,
                                        password: tecPassword.text,
                                        imei: imei,
                                      ),
                                    ),
                                  );
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.tertiary(),
                            foregroundColor: AppColors.onTertiary(),
                          ),
                          child: Text(
                            "sign_in".tr(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.size50),
                    Align(
                      alignment: Alignment.center,
                      child: SegmentedButton<Language>(
                        multiSelectionEnabled: false,
                        emptySelectionAllowed: false,
                        showSelectedIcon: false,
                        style: SegmentedButton.styleFrom(
                          shape: SmoothRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.size10),
                            smoothness: 1,
                          ),
                          visualDensity: VisualDensity.compact,
                          selectedBackgroundColor: AppColors.primaryContainer(),
                          selectedForegroundColor:
                              AppColors.onPrimaryContainer(),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: TextStyle(
                            fontSize: Dimensions.text12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        segments: const [
                          ButtonSegment(
                            value: Language.BAHASA,
                            label: Text("ID"),
                          ),
                          ButtonSegment(
                            value: Language.ENGLISH,
                            label: Text("EN"),
                          ),
                        ],
                        selected: {Language.valueOf("locale".tr())},
                        onSelectionChanged: (selected) {
                          Generals.changeLanguage(
                            locale: selected.first.locale,
                          );

                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }
}
