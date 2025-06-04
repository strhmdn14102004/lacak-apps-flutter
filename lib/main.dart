// ignore_for_file: depend_on_referenced_packages

import "dart:io";

import "package:base/base.dart";
import "package:easy_localization/easy_localization.dart" as el;
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:get/get.dart";
import "package:go_router/go_router.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:lacak_by_sasat/helper/firebase.dart";
import "package:lacak_by_sasat/helper/generals.dart";
import "package:lacak_by_sasat/helper/timers.dart";
import "package:lacak_by_sasat/main_bloc.dart";
import "package:lacak_by_sasat/main_state.dart";
import "package:lacak_by_sasat/module/home/home_bloc.dart";
import "package:lacak_by_sasat/module/home/home_page.dart";
import "package:lacak_by_sasat/module/root/root_bloc.dart";
import "package:lacak_by_sasat/module/sign_in/sign_in_bloc.dart";
import "package:lacak_by_sasat/module/sign_in/sign_in_page.dart";
import "package:lacak_by_sasat/module/sign_up/sign_up_bloc.dart";
import "package:lacak_by_sasat/module/sign_up/sign_up_page.dart";
import "package:loader_overlay/loader_overlay.dart";
import "package:lottie/lottie.dart";
import "package:provider/provider.dart";
import "package:smooth_corner/smooth_corner.dart";

final goRouter = GoRouter(
  initialLocation: "/home",
  navigatorKey: Get.key,
  debugLogDiagnostics: true,
  routes: [
    // // Route untuk pengecekan awal
    // GoRoute(
    //   path: "/auth-check",
    //   redirect: (context, state) async {
    //     final isLoggedIn = await Generals.isLoggedIn();
    //     return isLoggedIn ? "/home" : "/sign-in";
    //   },
    // ),
    GoRoute(
      path: "/sign-in",
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: "/sign-up",
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: "/home",
      builder: (context, state) => const HomePage(),
      redirect: (context, state) async {
        final isLoggedIn = await Generals.isLoggedIn();
        return isLoggedIn ? null : "/sign-in";
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text("Route tidak ditemukan: ${state.uri.path}"),
    ),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseNotification.initialize();
  HttpOverrides.global = BaseHttpOverrides();

  AppColors.lightColorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFB4C7E7), // pastel blue
    surfaceTint: Color(0xFFB4C7E7),
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFFDDE7F6),
    onPrimaryContainer: Color(0xFF1F2A38),

    secondary: Color(0xFFF7C8E0), // pastel pink
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFFFFE4F1),
    onSecondaryContainer: Color(0xFF3A2A34),

    tertiary: Color(0xFFA8E6CF), // pastel green
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFFDFF6EF),
    onTertiaryContainer: Color(0xFF264D3D),

    error: Color(0xFFFFB4B4), // pastel red
    onError: Color(0xFF000000),
    errorContainer: Color(0xFFFFE5E5),
    onErrorContainer: Color(0xFF5C1A1A),

    surface: Color(0xFFFFFCF9),
    onSurface: Color(0xFF2C2C2C),
    onSurfaceVariant: Color(0xFF6F6F6F),
    outline: Color(0xFFB5B5B5),
    outlineVariant: Color(0xFFE6E6E6),
    shadow: Color(0x33000000),
    scrim: Color(0x33000000),

    inverseSurface: Color(0xFF2C2C2C),
    inversePrimary: Color(0xFF7A94C2),

    primaryFixed: Color(0xFFDDE7F6),
    onPrimaryFixed: Color(0xFF1F2A38),
    primaryFixedDim: Color(0xFFB4C7E7),
    onPrimaryFixedVariant: Color(0xFF4C5C73),

    secondaryFixed: Color(0xFFFFE4F1),
    onSecondaryFixed: Color(0xFF3A2A34),
    secondaryFixedDim: Color(0xFFF7C8E0),
    onSecondaryFixedVariant: Color(0xFF815872),

    tertiaryFixed: Color(0xFFDFF6EF),
    onTertiaryFixed: Color(0xFF264D3D),
    tertiaryFixedDim: Color(0xFFA8E6CF),
    onTertiaryFixedVariant: Color(0xFF3F7F67),

    surfaceDim: Color(0xFFF3F0EC),
    surfaceBright: Color(0xFFFFFFFF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFFAF8F5),
    surfaceContainer: Color(0xFFF5F3F0),
    surfaceContainerHigh: Color(0xFFEFEDEA),
    surfaceContainerHighest: Color(0xFFE9E7E4),
  );

  AppColors.darkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF7A94C2), // dim pastel blue
    surfaceTint: Color(0xFF7A94C2),
    onPrimary: Color(0xFF0E1725),
    primaryContainer: Color(0xFF4C5C73),
    onPrimaryContainer: Color(0xFFDDE7F6),

    secondary: Color(0xFFCE92B9), // dim pastel pink
    onSecondary: Color(0xFF2D1F27),
    secondaryContainer: Color(0xFF815872),
    onSecondaryContainer: Color(0xFFFFE4F1),

    tertiary: Color(0xFF80BFA6), // dim pastel green
    onTertiary: Color(0xFF122D23),
    tertiaryContainer: Color(0xFF3F7F67),
    onTertiaryContainer: Color(0xFFDFF6EF),

    error: Color(0xFFFFB4B4),
    onError: Color(0xFF3D0000),
    errorContainer: Color(0xFF5C1A1A),
    onErrorContainer: Color(0xFFFFE5E5),

    surface: Color(0xFF121212),
    onSurface: Color(0xFFEFEDEA),
    onSurfaceVariant: Color(0xFFCACACA),
    outline: Color(0xFF8F8F8F),
    outlineVariant: Color(0xFF4A4A4A),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    inverseSurface: Color(0xFFF5F3F0),
    inversePrimary: Color(0xFFB4C7E7),

    primaryFixed: Color(0xFFDDE7F6),
    onPrimaryFixed: Color(0xFF1F2A38),
    primaryFixedDim: Color(0xFFB4C7E7),
    onPrimaryFixedVariant: Color(0xFF4C5C73),

    secondaryFixed: Color(0xFFFFE4F1),
    onSecondaryFixed: Color(0xFF3A2A34),
    secondaryFixedDim: Color(0xFFF7C8E0),
    onSecondaryFixedVariant: Color(0xFF815872),

    tertiaryFixed: Color(0xFFDFF6EF),
    onTertiaryFixed: Color(0xFF264D3D),
    tertiaryFixedDim: Color(0xFFA8E6CF),
    onTertiaryFixedVariant: Color(0xFF3F7F67),

    surfaceDim: Color(0xFF121212),
    surfaceBright: Color(0xFF2E2E2E),
    surfaceContainerLowest: Color(0xFF0F0F0F),
    surfaceContainerLow: Color(0xFF1C1C1C),
    surfaceContainer: Color(0xFF202020),
    surfaceContainerHigh: Color(0xFF2A2A2A),
    surfaceContainerHighest: Color(0xFF353535),
  );

  usePathUrlStrategy();
  initializeDateFormatting();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  await el.EasyLocalization.ensureInitialized();
  await BasePreferences.getInstance().init();

  runApp(
    el.EasyLocalization(
      supportedLocales: const [Locale("en"), Locale("id")],
      path: "assets/i18n",
      useFallbackTranslations: true,
      fallbackLocale: const Locale("id"),
      saveLocale: true,
      startLocale: const Locale("id"),
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final ValueNotifier<String> valueNotifier = ValueNotifier("");

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      scaffoldFeatureController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => MainBloc()),
        BlocProvider(create: (BuildContext context) => SignInBloc()),
        BlocProvider(create: (BuildContext context) => RootBloc()),
        BlocProvider(create: (BuildContext context) => HomeBloc()),
        BlocProvider(create: (BuildContext context) => SignUpBloc()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Timers.getInstance()),
        ],
        child: GlobalLoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/lottie/loading.json",
                  frameRate: const FrameRate(60),
                  width: Dimensions.size100,
                  height: Dimensions.size100,
                  repeat: true,
                ),
                Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: Dimensions.text20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          overlayColor: Colors.black,
          overlayOpacity: 0.8,
          child: DismissKeyboard(
            child: BlocBuilder<MainBloc, MainState>(
              builder: (context, state) {
                return MaterialApp.router(
                  scrollBehavior: BaseScrollBehavior(),
                  scaffoldMessengerKey: rootScaffoldMessengerKey,
                  title: "Lacak",
                  routerConfig: goRouter,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    useMaterial3: true,
                    fontFamily: "Manrope",
                    colorScheme: AppColors.lightColorScheme,
                    filledButtonTheme: FilledButtonThemeData(
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                        padding: EdgeInsets.all(Dimensions.size20),
                        textStyle: TextStyle(
                          fontSize: Dimensions.text12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                        padding: EdgeInsets.all(Dimensions.size20),
                        textStyle: TextStyle(
                          fontSize: Dimensions.text12,
                          fontWeight: FontWeight.w500,
                        ),
                        foregroundColor: AppColors.onSurface(),
                        iconColor: AppColors.onSurface(),
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                        padding: EdgeInsets.all(Dimensions.size20),
                        textStyle: TextStyle(
                          fontSize: Dimensions.text12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    iconButtonTheme: IconButtonThemeData(
                      style: IconButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        minimumSize:
                            Size.square(Dimensions.size45 + Dimensions.size3),
                      ),
                    ),
                  ),
                  darkTheme: ThemeData(
                    useMaterial3: true,
                    fontFamily: "Manrope",
                    colorScheme: AppColors.darkColorScheme,
                    filledButtonTheme: FilledButtonThemeData(
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                        padding: EdgeInsets.all(Dimensions.size20),
                        textStyle: TextStyle(
                          fontSize: Dimensions.text12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    outlinedButtonTheme: OutlinedButtonThemeData(
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                        padding: EdgeInsets.all(Dimensions.size20),
                        textStyle: TextStyle(
                          fontSize: Dimensions.text12,
                          fontWeight: FontWeight.w500,
                        ),
                        foregroundColor: AppColors.onSurface(),
                        iconColor: AppColors.onSurface(),
                      ),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: SmoothRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.size10),
                          smoothness: 1,
                        ),
                        padding: EdgeInsets.all(Dimensions.size20),
                        textStyle: TextStyle(
                          fontSize: Dimensions.text12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    iconButtonTheme: IconButtonThemeData(
                      style: IconButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        minimumSize:
                            Size.square(Dimensions.size45 + Dimensions.size3),
                      ),
                    ),
                  ),
                  themeMode: state.themeMode,
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: const TextScaler.linear(1.0)),
                      child: child ?? Container(),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;

  const DismissKeyboard({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}

class SnackContent extends StatelessWidget {
  final ValueNotifier<String> message;

  const SnackContent(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: message,
      builder: (_, msg, __) => Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.onError(),
        ),
      ),
    );
  }
}
