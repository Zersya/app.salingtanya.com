
import 'package:app_salingtanya/gen/assets.gen.dart';
import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/helpers/user_helper.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/repositories/auth_repository.dart';
import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/widgets/pick_language_widget.dart';
import 'package:app_salingtanya/widgets/toggle_darkmode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SliverCustomHeader extends StatelessWidget {
  const SliverCustomHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Assets.images.logoSalingtanya.image(width: 50),
            ),
            const SizedBox(width: 4),
            Text(
              'Hi ${GetIt.I<UserHelper>().user?.name ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.logout),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () async {
                await AuthRepository().signOut();
                GetIt.I<NavigationHelper>().goNamed('AuthPage');
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                return IconButton(
                  icon: const Icon(Icons.language),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () async {
                    final prefs = GetIt.I<SharedPreferences>();
                    final defaultLanguage = prefs.getString(kDefaultLanguage);

                    await PickLanguageWidget(
                      defaultLanguage: defaultLanguage,
                      pref: prefs,
                    ).showCustomDialog<void>(context);

                    await Future.wait<void>([
                      ref
                          .read(latestAddedQuestionsProvider.notifier)
                          .getQuestions(),
                      ref
                          .read(popularQuestionsProvider.notifier)
                          .getQuestions(isPopular: true),
                    ]);
                  },
                );
              },
            ),
            const ToggleDarkModeWidget(),
          ],
        ),
      ),
    );
  }
}
