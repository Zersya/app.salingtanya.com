import 'dart:io';

import 'package:app_salingtanya/app/riverpods/app_riverpod.dart';
import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/gen/assets.gen.dart';
import 'package:app_salingtanya/gen/colors.gen.dart';
import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/get_it.dart';
import 'package:appwrite/appwrite.dart' hide Locale;
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

final appProvider = StateNotifierProvider.autoDispose<AppNotifier, BasicState>(
  (ref) => AppNotifier(),
);

final themeIsDarkProvider = StateProvider((ref) => false);

final infoCookieIsVisible = StateProvider((ref) => true);

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AppState createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    HttpOverrides.global = MyHttpOverrides();

    final sdk = Client();

    sdk
        .setEndpoint('https://api.salingtanya.com/v1')
        .setProject('625b9c6a48a44771d02e')
        .setSelfSigned();

    GetItContainer.initializeAppwrite(sdk);

    final brightness = SchedulerBinding.instance!.window.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;
    ref.read(themeIsDarkProvider.notifier).state = isDarkMode;

    SharedPreferences.getInstance().then((pref) {
      final isDarkModePref = pref.getBool(kIsDarkMode) ?? isDarkMode;
      ref.read(themeIsDarkProvider.notifier).state = isDarkModePref;

      final isCookieVisible = pref.getBool(kIsCookieVisible) ?? true;
      ref.read(infoCookieIsVisible.notifier).state = isCookieVisible;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appProvider);

    const _colorSchemeLight = ColorScheme(
      brightness: Brightness.light,
      primary: ColorName.primary,
      primaryContainer: ColorName.primaryVariant,
      secondary: ColorName.info,
      secondaryContainer: ColorName.infoVariant,
      outline: ColorName.border,
      background: ColorName.background,
      error: ColorName.errorBackground,
      surface: ColorName.white,
      onPrimary: ColorName.white,
      onSecondary: ColorName.primary,
      onSurface: ColorName.textPrimary,
      onBackground: ColorName.textSecondary,
      onError: ColorName.errorForeground,
    );

    final _colorSchemeDark = _colorSchemeLight.copyWith(
      primary: ColorName.primaryDark,
      primaryContainer: ColorName.primaryVariantDark,
      secondary: ColorName.infoDark,
      secondaryContainer: ColorName.infoVariantDark,
      outline: ColorName.border,
      error: ColorName.errorBackground,
      surface: ColorName.white,
      onPrimary: ColorName.white,
      onSecondary: ColorName.primaryDark,
      brightness: Brightness.dark,
      background: ColorName.backgroundDark,
      onSurface: ColorName.white,
      onBackground: ColorName.white,
    );

    return app.when(
      idle: () => Column(
        children: [
          Expanded(
            child: _AppBody(
              colorSchemeLight: _colorSchemeLight,
              colorSchemeDark: _colorSchemeDark,
            ),
          ),
          if (kIsWeb)
            Consumer(
              builder: (context, ref, child) {
                final isVisible = ref.watch(infoCookieIsVisible);

                return Visibility(
                  visible: isVisible,
                  child: child!,
                );
              },
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: ColorName.primaryDark,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'This website uses authentication cookies. Authentication data is not shared externally.',
                        style: TextStyle(
                          color: ColorName.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          final url =
                              Uri.parse('https://www.cookiesandyou.com/');
                          launchUrl(url);
                        },
                        child: const Text(
                          'Learn more',
                          style: TextStyle(color: ColorName.white),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: ColorName.primary,
                          textStyle: const TextStyle(
                            color: ColorName.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          ref.read(infoCookieIsVisible.notifier).state = false;
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool(kIsCookieVisible, false);
                        },
                        child: const Text(
                          'Accept',
                          style: TextStyle(color: ColorName.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      loading: () => Material(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: ColorName.primary,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Assets.images.logoSalingtanya.image(width: 300, height: 300),
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(ColorName.primary),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBody extends ConsumerWidget {
  const _AppBody({
    Key? key,
    required this.colorSchemeLight,
    required this.colorSchemeDark,
  }) : super(key: key);

  final ColorScheme colorSchemeLight;
  final ColorScheme colorSchemeDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = GetIt.I<NavigationHelper>().goRouter;
    final isDarkMode = ref.watch(themeIsDarkProvider);

    final textThemeLight = GoogleFonts.openSansTextTheme(
      TextTheme(
        subtitle1: TextStyle(color: colorSchemeLight.onSurface),
        subtitle2: TextStyle(color: colorSchemeLight.onBackground),
        headline5: TextStyle(color: colorSchemeLight.onSurface),
        headline6: TextStyle(color: colorSchemeLight.onSurface),
        bodyText2: TextStyle(color: colorSchemeLight.onSurface),
        bodyText1: TextStyle(color: colorSchemeLight.onBackground),
      ),
    );

    final textThemeDark = GoogleFonts.openSansTextTheme(
      TextTheme(
        subtitle1: TextStyle(color: colorSchemeDark.onSurface),
        subtitle2: TextStyle(color: colorSchemeDark.onBackground),
        headline5: TextStyle(color: colorSchemeDark.onSurface),
        headline6: TextStyle(color: colorSchemeDark.onSurface),
        bodyText2: TextStyle(color: colorSchemeDark.onSurface),
        bodyText1: TextStyle(color: colorSchemeDark.onBackground),
      ),
    );

    final theme = isDarkMode
        ? ThemeData(
            appBarTheme: const AppBarTheme(
              color: ColorName.primaryDark,
            ),
            colorScheme: colorSchemeDark,
            primaryColor: colorSchemeDark.primary,
            backgroundColor: colorSchemeDark.background,
            textTheme: textThemeDark,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          )
        : ThemeData(
            appBarTheme: const AppBarTheme(
              color: ColorName.primary,
            ),
            colorScheme: colorSchemeLight,
            primaryColor: colorSchemeLight.primary,
            backgroundColor: colorSchemeLight.background,
            textTheme: textThemeLight,
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );

    return EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
      fallbackLocale: const Locale('en', 'US'),
      path: 'assets/translations',
      child: DevicePreview(
        // ignore: avoid_redundant_argument_values
        enabled: kDebugMode,
        builder: (context) => MaterialApp.router(
          onGenerateTitle: (context) => 'Saling Tanya',
          useInheritedMediaQuery: true,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: DevicePreview.locale(context),
          routeInformationParser: appRouter.routeInformationParser,
          routerDelegate: appRouter.routerDelegate,
          builder: (context, widget) => ResponsiveWrapper.builder(
            DevicePreview.appBuilder(context, widget),
            minWidth: 480,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(480, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
            ],
            background: Container(color: ColorName.background),
          ),
          theme: theme,
        ),
      ),
    );
  }
}
