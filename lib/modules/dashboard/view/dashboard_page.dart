import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/helpers/flash_message_helper.dart';
import 'package:app_salingtanya/modules/dashboard/riverpods/create_feedback_riverpod.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/widgets/list_question/widget/create_question_widget.dart';
import 'package:app_salingtanya/widgets/list_question/widget/list_question_widget.dart';
import 'package:app_salingtanya/widgets/room/widget/create_room_widget.dart';
import 'package:app_salingtanya/widgets/room/widget/list_room_widget.dart';
import 'package:app_salingtanya/widgets/sliver_custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_it/get_it.dart';
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
      body: const CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverCustomHeader(),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Popular Questions',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16),
            sliver: ListQuestionWidget(isPopular: true),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Latest Added Questions',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 16),
            sliver: ListQuestionWidget(isPopular: false),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Rooms',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 4),
            sliver: ListRoomWidget(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }
}
