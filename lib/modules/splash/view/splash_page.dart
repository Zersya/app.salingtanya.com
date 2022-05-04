import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/widgets/pick_language_widget.dart';
import 'package:app_salingtanya/widgets/splash_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    
    final prefs = GetIt.I<SharedPreferences>();
    final defaultLanguage = prefs.getString(kDefaultLanguage);
    if (defaultLanguage == null) {
      PickLanguageWidget(
        defaultLanguage: defaultLanguage,
        pref: prefs,
      ).showCustomDialog<void>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashWidget(),
    );
  }
}
