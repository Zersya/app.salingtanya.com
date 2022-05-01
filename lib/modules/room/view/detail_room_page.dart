import 'package:app_salingtanya/freezed/basic_detail_state.dart';
import 'package:app_salingtanya/freezed/basic_form_state.dart';
import 'package:app_salingtanya/gen/assets.gen.dart';
import 'package:app_salingtanya/gen/colors.gen.dart';
import 'package:app_salingtanya/helpers/flash_message_helper.dart';
import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/models/room.dart';
import 'package:app_salingtanya/modules/room/riverpod/detail_room_riverpod.dart';
import 'package:app_salingtanya/modules/room/riverpod/update_detail_room_riverpod.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/utils/extensions/string_extension.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/utils/functions.dart';
import 'package:app_salingtanya/widgets/custom_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

part 'widgets/insert_names_widget.dart';

final namesController =
    StateProvider.autoDispose<List<TextEditingController>>((ref) {
  final currentNames = ref.read(selectedRoomProvider)?.memberNames;

  if (currentNames == null || currentNames.isEmpty) {
    return List.filled(1, TextEditingController());
  }

  return currentNames.map((e) => TextEditingController(text: e)).toList();
});

final updateDetailRoomProvider =
    StateNotifierProvider<UpdateDetailRoomNotifier, BasicFormState>(
  (ref) => UpdateDetailRoomNotifier(
    onUpdate: (_) {
      ref.read(detailRoomProvider.notifier).getRoom();
    },
  ),
);

final detailRoomProvider = StateNotifierProvider.autoDispose<DetailRoomNotifier,
    BasicDetailState<Room?>>((ref) {
  return DetailRoomNotifier(ref);
});

class DetailRoomPage extends ConsumerStatefulWidget {
  const DetailRoomPage({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

  @override
  ConsumerState<DetailRoomPage> createState() => _DetailRoomPageState();
}

class _DetailRoomPageState extends ConsumerState<DetailRoomPage> {
  @override
  void initState() {
    ref.read(detailRoomProvider.notifier)
      ..roomId = widget.roomId
      ..getRoom();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final detailRoomState = ref.watch(detailRoomProvider);

    return WillPopScope(
      onWillPop: () async {
        ref
          ..refresh(selectedQuestionsProvider)
          ..refresh(updateDetailRoomProvider);
          
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Room'),
        ),
        body: detailRoomState.maybeWhen(
          idle: (_) => const _DetailRoomBody(),
          error: (message) => CustomErrorWidget(
            message: message,
            onTap: () => GetIt.I<NavigationHelper>().goRouter.pop(),
          ),
          orElse: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class _DetailRoomBody extends ConsumerWidget {
  const _DetailRoomBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(selectedRoomProvider);

    final isCreatedByMe = room!.isCreatedByMe();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: Assets.illustration.fittingPiece.svg(),
          ),
          const _TutorialItemWidget(
            text: 'Hai, satanya akan memberi tahu kamu tentang room ini',
          ),
          const _TutorialItemWidget(
            text:
                'Bila kalian bermain bersama, silahkan duduk melingkar saling berhadapan',
          ),
          if (isCreatedByMe)
            _TutorialItemWidget(
              text: 'Pertama, silahkan',
              subtext: room.memberNames.map((e) => e.capitalize).join(', '),
              child: InkWell(
                onTap: () {
                  _InsertNameWidget(roomId: room.id)
                      .showCustomDialog<void>(context);
                },
                child: Text(
                  'Tambahkan nama akrab teman main kamu',
                  style: TextStyle(
                    color: room.memberNames.isNotEmpty
                        ? Theme.of(context).colorScheme.onBackground
                        : ColorName.primary,
                  ),
                ),
              ),
            )
          else
            _TutorialItemWidget(
              text:
                  'Pertama, teman kamu sudah membuat ruangan ini untuk kamu dan juga menambahkan nama kamu, yaitu: ',
              subtext: room.memberNames.map((e) => e.capitalize).join(', '),
            ),
          if (isCreatedByMe)
            _TutorialItemWidget(
              text: 'Lalu kamu bisa',
              subtext: '${room.questionIds.length} selected',
              child: InkWell(
                onTap: () {
                  GetIt.I<NavigationHelper>().goNamed(
                    'SelectQuestionsPage',
                    params: {'rid': room.id},
                  );
                },
                child: Text(
                  'Menambahkan pertanyaan yang kamu inginkan',
                  style: TextStyle(
                    color: room.questionIds.isNotEmpty
                        ? Theme.of(context).colorScheme.onBackground
                        : ColorName.primary,
                  ),
                ),
              ),
            )
          else
            _TutorialItemWidget(
              text:
                  'Terdapat ${room.questionIds.length} pertanyaan terpilih, yang akan di acak beserta dengan nama kamu',
            ),
          if (isCreatedByMe)
            const _TutorialItemWidget(
              text: 'Kamu bisa mengubahnya lagi nanti',
            ),
          if (isCreatedByMe)
            const _TutorialItemWidget(
              text:
                  'Kamu bisa menghapusnya jika kamu tidak ingin menggunakan room ini lagi',
            ),
          _TutorialItemWidget(
            text: 'Salin lalu bagikan room ini dengan teman kamu',
            child: InkWell(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(
                    text: '$defaultUrl/public-room/${room.id}',
                  ),
                );
                GetIt.I<FlashMessageHelper>()
                    .showTopFlash('URL ruangan disalin');
              },
              child: const Text(
                'Salin Room',
                style: TextStyle(
                  color: ColorName.primary,
                ),
              ),
            ),
          ),
          _TutorialItemWidget(
            text: 'Bila sudah mengerti,',
            child: InkWell(
              onTap: () {},
              child: const Text(
                'Ayo main!!',
                style: TextStyle(
                  color: ColorName.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialItemWidget extends StatelessWidget {
  const _TutorialItemWidget({
    Key? key,
    required this.text,
    this.subtext,
    this.child,
  }) : super(key: key);

  final String text;
  final String? subtext;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(child: Text(text)),
                    if (child != null)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: child,
                          ),
                        ),
                      ),
                  ],
                ),
                if (subtext != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      subtext!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
