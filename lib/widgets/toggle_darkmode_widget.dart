import 'package:app_salingtanya/app/app.dart';
import 'package:app_salingtanya/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToggleDarkModeWidget extends ConsumerWidget {
  const ToggleDarkModeWidget({
    Key? key,
    this.color,
  }) : super(key: key);
  final Color? color;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeIsDarkProvider);

    return IconButton(
      icon: Icon(
        isDark ? Icons.brightness_2 : Icons.brightness_1,
      ),
      color: color ?? Theme.of(context).colorScheme.primary,
      onPressed: () {
        final isDarkProvider = ref.read(themeIsDarkProvider.notifier);
        isDarkProvider.state = !isDarkProvider.state;
        SharedPreferences.getInstance().then((prefs) {
          prefs.setBool(kIsDarkMode, isDarkProvider.state);
        });
      },
    );
  }
}
