import 'package:app_salingtanya/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickLanguageWidget extends StatelessWidget {
  const PickLanguageWidget({
    Key? key,
    required this.defaultLanguage,
    required this.pref,
  }) : super(key: key);

  final String? defaultLanguage;
  final SharedPreferences pref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Pick Language / Pilih Bahasa',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          RadioListTile(
            title: const Text('Indonesia'),
            value: 'id',
            activeColor: Theme.of(context).colorScheme.primary,
            groupValue: defaultLanguage,
            onChanged: (value) {
              pref.setString(kDefaultLanguage, 'id');
              Navigator.of(context).pop();
            },
          ),
          RadioListTile(
            title: const Text('English'),
            value: 'en',
            activeColor: Theme.of(context).colorScheme.primary,
            groupValue: defaultLanguage,
            onChanged: (value) {
              pref.setString(kDefaultLanguage, 'en');
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
