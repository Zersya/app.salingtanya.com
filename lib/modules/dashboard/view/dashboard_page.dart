import 'package:app_salingtanya/freezed/basic_list_state.dart';
import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/helpers/flash_message_helper.dart';
import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/models/question.dart';
import 'package:app_salingtanya/models/question_category.dart';
import 'package:app_salingtanya/models/room.dart';
import 'package:app_salingtanya/modules/dashboard/riverpods/create_question_riverpod.dart';
import 'package:app_salingtanya/modules/dashboard/riverpods/create_room_riverpod.dart';
import 'package:app_salingtanya/modules/dashboard/riverpods/list_question_riverpod.dart';
import 'package:app_salingtanya/modules/dashboard/riverpods/list_room_riverpod.dart';
import 'package:app_salingtanya/modules/dashboard/riverpods/question_categories_riverpod.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/repositories/auth_repository.dart';
import 'package:app_salingtanya/utils/extensions/string_extension.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_it/get_it.dart';

part 'widgets/create_question_widget.dart';
part 'widgets/create_room_widget.dart';
part 'widgets/list_question_widget.dart';
part 'widgets/list_room_widget.dart';

final roomsProvider =
    StateNotifierProvider<ListRoomNotifier, BasicListState<Room>>(
  (ref) => ListRoomNotifier()..getRooms(),
);

final popularQuestionsProvider =
    StateNotifierProvider<ListQuestionNotifier, BasicListState<Question>>(
  (ref) => ListQuestionNotifier()..getQuestions(isPopular: true),
);

final latestAddedQuestionsProvider =
    StateNotifierProvider<ListQuestionNotifier, BasicListState<Question>>(
  (ref) => ListQuestionNotifier()..getQuestions(),
);

final createRoomProvider =
    StateNotifierProvider.autoDispose<CreateRoomNotifier, BasicState>(
  (ref) => CreateRoomNotifier(
    onCreate: (result) {
      ref.read(selectedRoomProvider.notifier).state = result;

      ref.read(roomsProvider.notifier).getRooms();
      GetIt.I<NavigationHelper>().goRouter.goNamed(
        'DetailRoomPage',
        params: {
          'rid': result.id,
        },
      );
    },
  ),
);

final selectedQuestionCategoryProvider =
    StateProvider.autoDispose<QuestionCategory?>((ref) => null);

final questionCategoriesProvider = StateNotifierProvider.autoDispose<
    QuestionCategoriesNotifier, BasicListState<QuestionCategory>>(
  (ref) => QuestionCategoriesNotifier()..getQuestionCategories(),
);

final createQuestionProvider =
    StateNotifierProvider.autoDispose<CreateQuestionNotifier, BasicState>(
  (ref) => CreateQuestionNotifier(
    onCreate: () {
      ref.read(latestAddedQuestionsProvider.notifier).getQuestions();
      ref.read(popularQuestionsProvider.notifier).getQuestions(isPopular: true);
    },
  ),
);

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthRepository().signOut();
              GetIt.I<NavigationHelper>().goRouter.goNamed('AuthPage');
            },
          ),
        ],
      ),
      floatingActionButton: Consumer(
        builder: (_, ref, __) {
          final isVisible = ref.watch(roomsProvider).maybeMap(
                idle: (value) => value.data.isNotEmpty,
                orElse: () => false,
              );

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
                backgroundColor: Colors.white,
                label: 'Create Room',
                onTap: () {
                  final controller = TextEditingController();
                  _CreateRoomWidget(controller: controller)
                      .showCustomDialog<void>(context);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.question_mark),
                backgroundColor: Colors.white,
                label: 'Create Question',
                onTap: () {
                  final controller = TextEditingController();
                  _CreateQuestionWidget(controller: controller)
                      .showCustomDialog<void>(context);
                },
              ),
            ],
          );
        },
      ),
      body: const CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
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
            sliver: _ListQuestionWidget(isPopular: true),
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
            sliver: _ListQuestionWidget(isPopular: false),
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
            padding: EdgeInsets.symmetric(vertical: 16),
            sliver: _ListRoomWidget(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }
}
