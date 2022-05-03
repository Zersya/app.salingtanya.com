import 'package:app_salingtanya/app/app.dart';
import 'package:app_salingtanya/freezed/basic_detail_state.dart';
import 'package:app_salingtanya/freezed/basic_form_state.dart';
import 'package:app_salingtanya/gen/assets.gen.dart';
import 'package:app_salingtanya/gen/colors.gen.dart';
import 'package:app_salingtanya/helpers/flash_message_helper.dart';
import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/models/question.dart';
import 'package:app_salingtanya/models/room.dart';
import 'package:app_salingtanya/modules/room/riverpod/detail_room_riverpod.dart';
import 'package:app_salingtanya/modules/room/riverpod/question_room_riverpod.dart';
import 'package:app_salingtanya/modules/room/riverpod/update_detail_room_riverpod.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/utils/extensions/string_extension.dart';
import 'package:app_salingtanya/utils/extensions/widget_extension.dart';
import 'package:app_salingtanya/utils/functions.dart';
import 'package:app_salingtanya/widgets/custom_error_widget.dart';
import 'package:app_salingtanya/widgets/list_question/widget/card_question_widget.dart';
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
  (ref) => UpdateDetailRoomNotifier(),
);

final detailRoomProvider = StateNotifierProvider.autoDispose<DetailRoomNotifier,
    BasicDetailState<Room?>>(
  DetailRoomNotifier.new,
);

final questionRoomProvider =
    StateNotifierProvider<QuestionRoomNotifier, BasicDetailState<Question?>>(
  QuestionRoomNotifier.new,
);

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
      ..subscribe(widget.roomId)
      ..listen()
      ..getRoom();

    super.initState();
  }

  @override
  void dispose() {
    ref.read(detailRoomProvider.notifier).close();
    ref.read(questionRoomProvider.notifier).dispose();
    super.dispose();
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
          actions: [
            Consumer(
              builder: (context, ref, _) {
                final room = ref.watch(selectedRoomProvider);

                if (room == null || room.startedAt == null) {
                  return const SizedBox();
                }

                return IconButton(
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: '$defaultUrl/public-room/${room.id}',
                      ),
                    );
                    GetIt.I<FlashMessageHelper>()
                        .showTopFlash('URL ruangan disalin');
                  },
                  icon: const Icon(Icons.share),
                );
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final isDark = ref.read(themeIsDarkProvider);

                return IconButton(
                  icon: Icon(
                    isDark ? Icons.brightness_2 : Icons.brightness_1,
                  ),
                  onPressed: () {
                    final isDarkProvider =
                        ref.read(themeIsDarkProvider.notifier);
                    isDarkProvider.state = !isDarkProvider.state;
                  },
                );
              },
            )
          ],
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
    final room = ref.watch(selectedRoomProvider)!;
    final isCreatedByMe = room.isCreatedByMe();

    final stateQuestionRoom = ref.watch(questionRoomProvider);

    final session = room.indexSession + 1;

    if (room.startedAt != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Permainan dimulai pada sesi $session'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                height: 300,
                child: stateQuestionRoom.maybeWhen(
                  idle: (data) => Column(
                    children: [
                      if (data != null)
                        Flexible(
                          child: QuestionCardWidget(
                            question: data,
                            isSelectable: false,
                            width: 300,
                          ),
                        ),
                      if (isCreatedByMe)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: TextButton(
                            onPressed: () {
                              final result = ref
                                  .read(questionRoomProvider.notifier)
                                  .getRandomQuestionId(room.questionIds);

                              ref
                                  .read(updateDetailRoomProvider.notifier)
                                  .updateActiveQuestionId(
                                    room,
                                    result,
                                  );
                            },
                            child: const Text('Dapatkan pertanyaan'),
                          ),
                        ),
                    ],
                  ),
                  orElse: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const _SetupRoomWidget();
  }
}

class _SetupRoomWidget extends ConsumerWidget {
  const _SetupRoomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(selectedRoomProvider)!;

    final isCreatedByMe = room.isCreatedByMe();

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
              onTap: () {
                ref.read(updateDetailRoomProvider.notifier).startRoom(room.id);
              },
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
                        fontSize: 14,
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
