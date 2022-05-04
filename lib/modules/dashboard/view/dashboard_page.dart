import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/helpers/flash_message_helper.dart';
import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/modules/dashboard/riverpods/create_feedback_riverpod.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/repositories/auth_repository.dart';
import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/widgets/list_question/widget/create_question_widget.dart';
import 'package:app_salingtanya/widgets/list_question/widget/list_question_widget.dart';
import 'package:app_salingtanya/widgets/pick_language_widget.dart';
import 'package:app_salingtanya/widgets/room/widget/create_room_widget.dart';
import 'package:app_salingtanya/widgets/room/widget/list_room_widget.dart';
import 'package:app_salingtanya/widgets/toggle_darkmode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

part 'widgets/create_feedback_widget.dart';

final createFeedbackProvider =
    StateNotifierProvider.autoDispose<CreateFeedbackNotifier, BasicState>(
  (ref) => CreateFeedbackNotifier(),
);

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer(
        builder: (_, ref, __) {
          final isVisible = ref.watch(roomsProvider).maybeMap(
                idle: (value) => value.data.isNotEmpty,
                orElse: () => false,
              );

          final isLight = Theme.of(context).brightness == Brightness.light;

          return SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            visible: isVisible,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () {},
            onClose: () {},
            tooltip: 'Menu',
            heroTag: 'menu_fab',
            foregroundColor: Colors.white,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.table_restaurant),
                backgroundColor: isLight ? Colors.white : Colors.black87,
                label: 'Create Room',
                onTap: () {
                  final controller = TextEditingController();
                  CreateRoomWidget(controller: controller)
                      .showCustomDialog<void>(context);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.question_mark),
                backgroundColor: isLight ? Colors.white : Colors.black87,
                label: 'Create Question',
                onTap: () {
                  CreateQuestionWidget(controller: TextEditingController())
                      .showCustomDialog<void>(context);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.feedback),
                backgroundColor: isLight ? Colors.white : Colors.black87,
                label: 'Feedback',
                onTap: () {
                  _CreateFeedbackWidget(controller: TextEditingController())
                      .showCustomDialog<void>(context);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.chat_bubble),
                backgroundColor: isLight ? Colors.white : Colors.black87,
                label: 'Chat',
                onTap: () async {
                  final url = Uri.parse('https://chat.salingtanya.com/');
                  await launchUrl(url);
                },
              ),
            ],
          );
        },
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await AuthRepository().signOut();
                  GetIt.I<NavigationHelper>().goNamed('AuthPage');
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  return IconButton(
                    icon: const Icon(Icons.language),
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
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Popular Questions',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16),
            sliver: ListQuestionWidget(isPopular: true),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Latest Added Questions',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16),
            sliver: ListQuestionWidget(isPopular: false),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Rooms',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 4),
            sliver: ListRoomWidget(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }
}
