part of '../detail_room_page.dart';

class _InsertNameWidget extends ConsumerWidget {
  const _InsertNameWidget({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

  Future _onSubmitted(BuildContext context, WidgetRef ref) async {
    final controllers = ref.read(namesController);
    if (controllers
        .getRange(0, controllers.length - 1)
        .any((element) => element.text.isEmpty)) {
      GetIt.I<FlashMessageHelper>().showError(tr('rooms.room_cant_be_empty'));
      return;
    }

    FocusScope.of(context).unfocus();

    final names = controllers
        .where((element) => element.text.isNotEmpty)
        .map((e) => e.text)
        .toList();

    await ref
        .read(updateDetailRoomProvider.notifier)
        .updateNames(roomId, names);

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateNames = ref.watch(updateDetailRoomProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const _ListNamesWidget(),
          const SizedBox(height: 16),
          updateNames.maybeWhen(
            orElse: () => Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('widgets.close').tr(),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => _onSubmitted(context, ref),
                  child: const Text('widgets.save').tr(),
                ),
              ],
            ),
            loading: () => const Align(
              alignment: Alignment.centerRight,
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListNamesWidget extends ConsumerWidget {
  const _ListNamesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllers = ref.watch(namesController);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: controllers.length,
      itemBuilder: (context, index) {
        final isLastItem = controllers.length == index + 1;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: controllers[index],
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: tr(
                      'rooms.what_is_your_friend_name',
                      args: ['${index + 1}'],
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) {
                    final newControllers = controllers.toList()
                      ..add(TextEditingController());

                    ref.read(namesController.notifier).state = newControllers;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: InkWell(
                  onTap: () {
                    if (isLastItem) {
                      final newControllers = ref.read(namesController).toList()
                        ..add(TextEditingController());

                      ref.read(namesController.notifier).state = newControllers;
                    } else {
                      final newControllers = controllers.toList()
                        ..removeAt(index);

                      ref.read(namesController.notifier).state = newControllers;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorName.border,
                      ),
                    ),
                    child: Icon(isLastItem ? Icons.add : Icons.remove),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
