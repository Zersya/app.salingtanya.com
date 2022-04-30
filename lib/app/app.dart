import 'dart:io';

import 'package:app_salingtanya/app/riverpods/app_riverpod.dart';
import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/gen/assets.gen.dart';
import 'package:app_salingtanya/gen/colors.gen.dart';
import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/utils/get_it.dart';
import 'package:appwrite/appwrite.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

final appProvider = StateNotifierProvider.autoDispose<AppNotifier, BasicState>(
  (ref) => AppNotifier(),
);

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

    GetItContainer.initialize(sdk);

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
      brightness: Brightness.dark,
      onSurface: ColorName.white,
      onBackground: ColorName.white,
    );

    return app.when(
      idle: () => _AppBody(
        colorSchemeLight: _colorSchemeLight,
        colorSchemeDark: _colorSchemeDark,
      ),
      loading: () => Material(child: Assets.images.logoIndieapps.image()),
    );
  }
}

class _AppBody extends StatelessWidget {
  const _AppBody({
    Key? key,
    required this.colorSchemeLight,
    required this.colorSchemeDark,
  }) : super(key: key);

  final ColorScheme colorSchemeLight;
  final ColorScheme colorSchemeDark;

  @override
  Widget build(BuildContext context) {
    final appRouter = GetIt.I<NavigationHelper>().goRouter;
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

    return DevicePreview(
      builder: (context) => MaterialApp.router(
        onGenerateTitle: (context) => 'Saling Tanya',
        useInheritedMediaQuery: true,
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
        theme: ThemeData(
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
        ),
        darkTheme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: ColorName.primary,
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
        ),
      ),
    );
  }
}
