part of '../dashboard_page.dart';

class _ListRoomWidget extends ConsumerWidget {
  const _ListRoomWidget({Key? key}) : super(key: key);

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
                  _CreateRoomWidget(controller: controller)
                      .showCustomDialog<void>(context);
                },
              ),
            );
          }

          return ListView.builder(
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
                  GetIt.I<NavigationHelper>().goRouter.goNamed(
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
