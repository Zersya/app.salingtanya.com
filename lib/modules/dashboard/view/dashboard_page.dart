import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/helpers/flash_message_helper.dart';
import 'package:app_salingtanya/modules/dashboard/riverpods/create_feedback_riverpod.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/widgets/list_question/widget/create_question_widget.dart';
import 'package:app_salingtanya/widgets/list_question/widget/list_question_widget.dart';
import 'package:app_salingtanya/widgets/pick_language_widget.dart';
import 'package:app_salingtanya/widgets/room/widget/create_room_widget.dart';
import 'package:app_salingtanya/widgets/room/widget/list_room_widget.dart';
import 'package:app_salingtanya/widgets/sliver_custom_header.dart';
import 'package:easy_localization/easy_localization.dart';
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

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final prefs = GetIt.I<SharedPreferences>();
      final defaultLanguage = prefs.getString(kDefaultLanguage);

      if (defaultLanguage == null) {
        PickLanguageWidget(
          defaultLanguage: defaultLanguage,
          pref: prefs,
        ).showCustomDialog<void>(context).then((value) {
          Future.wait<void>([
            ref.read(latestAddedQuestionsProvider.notifier).getQuestions(),
            ref
                .read(popularQuestionsProvider.notifier)
                .getQuestions(isPopular: true),
          ]);
        });
      }
    });
  }

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
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.table_restaurant),
                backgroundColor: isLight ? Colors.white : Colors.black87,
                label: tr('dashboard.create_room'),
                onTap: () {
                  final controller = TextEditingController();
                  CreateRoomWidget(controller: controller)
                      .showCustomDialog<void>(context);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.question_mark),
                backgroundColor: isLight ? Colors.white : Colors.black87,
                label: tr('dashboard.create_question'),
                onTap: () {
                  CreateQuestionWidget(controller: TextEditingController())
                      .showCustomDialog<void>(context);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.feedback),
                backgroundColor: isLight ? Colors.white : Colors.black87,
                label: tr('dashboard.feedback'),
                onTap: () {
                  _CreateFeedbackWidget(controller: TextEditingController())
                      .showCustomDialog<void>(context);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.chat_bubble),
                backgroundColor: isLight ? Colors.white : Colors.black87,
                label: tr('dashboard.chat'),
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
          const SliverCustomHeader(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                tr('dashboard.popular_questions'),
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16),
            sliver: ListQuestionWidget(isPopular: true),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                tr('dashboard.latest_questions'),
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16),
            sliver: ListQuestionWidget(isPopular: false),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                tr('rooms.title'),
                style: const TextStyle(fontSize: 24),
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
