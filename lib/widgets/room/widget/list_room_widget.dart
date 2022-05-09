import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/utils/extensions/string_extension.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/widgets/custom_error_widget.dart';
import 'package:app_salingtanya/widgets/room/widget/create_room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

class ListRoomWidget extends ConsumerWidget {
  const ListRoomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listRoom = ref.watch(roomsProvider);

    return SliverToBoxAdapter(
      child: listRoom.when(
        idle: (data) {
          if (data.isEmpty) {
            return Center(
              child: CustomErrorWidget(
                message: 'No rooms has been made\nTap the button to create one',
                onTap: () {
                  final controller = TextEditingController();
                  CreateRoomWidget(controller: controller)
                      .showCustomDialog<void>(context);
                },
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final room = data[index];
              return ListTile(
                title: Text(room.name.capitalize),
                subtitle:
                    room.description != null ? Text(room.description!) : null,
                onTap: () {
                  ref.read(selectedRoomProvider.notifier).state = room;
                  GetIt.I<NavigationHelper>().goNamed(
                    'DetailRoomPage',
                    params: {
                      'rid': room.id,
                    },
                  );
                },
              );
            },
            itemCount: data.length,
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (message) => Center(
          child: CustomErrorWidget(
            message: message,
            onTap: () => ref.read(roomsProvider.notifier).getRooms(),
          ),
        ),
      ),
    );
  }
}
