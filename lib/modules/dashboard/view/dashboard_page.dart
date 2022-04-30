import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/repositories/auth_repository.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/widgets/list_question/widget/create_question_widget.dart';
import 'package:app_salingtanya/widgets/list_question/widget/list_question_widget.dart';
import 'package:app_salingtanya/widgets/room/widget/create_room_widget.dart';
import 'package:app_salingtanya/widgets/room/widget/list_room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_it/get_it.dart';

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
                  CreateRoomWidget(controller: controller)
                      .showCustomDialog<void>(context);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.question_mark),
                backgroundColor: Colors.white,
                label: 'Create Question',
                onTap: () {
                  final controller = TextEditingController();
                  CreateQuestionWidget(controller: controller)
                      .showCustomDialog<void>(context);
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
            padding: EdgeInsets.symmetric(vertical: 16),
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
