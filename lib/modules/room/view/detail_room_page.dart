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
import 'package:app_salingtanya/widgets/toggle_darkmode_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
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

final detailRoomProvider = StateNotifierProvider.autoDispose<DetailRoomNotifier,
    BasicDetailState<Room?>>(
  DetailRoomNotifier.new,
);

final updateDetailRoomProvider =
    StateNotifierProvider<UpdateDetailRoomNotifier, BasicFormState>(
  (ref) => UpdateDetailRoomNotifier(),
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
                        .showTopFlash(tr('rooms.url_room_copied'));
                  },
                  icon: const Icon(Icons.share),
                );
              },
            ),
            const ToggleDarkModeWidget(color: ColorName.white),
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
            const Text('rooms.game_started_on_session').tr(args: ['$session']),
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
                            onTapEmoji: (value) {
                              final newEmojis = room.activeQuestionEmojis
                                ..add(value);

                              final jsonRoom = room.toJson();
                              final updatedRoom = Room.fromJson(jsonRoom)
                                ..activeQuestionEmojis = newEmojis;

                              ref.read(selectedRoomProvider.notifier).state =
                                  updatedRoom;

                              ref
                                  .read(updateDetailRoomProvider.notifier)
                                  .updateActiveQuestionEmojis(room, newEmojis);
                            },
                          ),
                        ),
                      if (isCreatedByMe)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: TextButton(
                            onPressed: () {
                              final result = ref
                                  .read(questionRoomProvider.notifier)
                                  .getRandomQuestionId(
                                    room.questionIds,
                                  );

                              ref
                                  .read(questionRoomProvider.notifier)
                                  .updateActiveQuestionId(
                                    room,
                                    result,
                                  );
                            },
                            child: const Text('rooms.get_question').tr(),
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

    if (!isCreatedByMe) {
      return Center(
        child: const Text('rooms.waiting_for_room_master_to_start_game').tr(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'rooms.tutorial.title'.tr(),
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          _TutorialItemWidget(
            child: RichText(
              text: TextSpan(
                text: 'rooms.tutorial.1.1'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
          _TutorialItemWidget(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'rooms.tutorial.2.1'.tr()),
                  TextSpan(
                    text: 'rooms.tutorial.2.2'.tr(
                      args: ['${room.questionIds.length}'],
                    ),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextSpan(text: 'rooms.tutorial.2.3'.tr()),
                  TextSpan(
                    text: 'rooms.tutorial.2.4'.tr(),
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        GetIt.I<NavigationHelper>().goNamed(
                          'SelectQuestionsPage',
                          params: {'rid': room.id},
                        );
                      },
                  ),
                ],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),

          _TutorialItemWidget(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'rooms.tutorial.3.1'
                        .tr(args: ['${room.memberNames.length}']),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextSpan(text: 'rooms.tutorial.3.2'.tr()),
                  TextSpan(
                    text: 'rooms.tutorial.3.3'.tr(),
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _InsertNameWidget(roomId: room.id)
                            .showCustomDialog<void>(context);
                      },
                  ),
                ],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),

          _TutorialItemWidget(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'rooms.tutorial.4.1'.tr()),
                  TextSpan(
                    text: 'rooms.tutorial.4.2'.tr(),
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Clipboard.setData(
                          ClipboardData(
                            text: '$defaultUrl/public-room/${room.id}',
                          ),
                        );
                        GetIt.I<FlashMessageHelper>()
                            .showTopFlash(tr('rooms.url_room_copied'));
                      },
                  ),
                ],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),

          _TutorialItemWidget(
            child: RichText(
              text: TextSpan(
                text: 'rooms.tutorial.5'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (room.memberNames.isEmpty) {
                  GetIt.I<FlashMessageHelper>()
                      .showError(tr('rooms.no_members_in_room'));
                  return;
                }

                if (room.questionIds.isEmpty) {
                  GetIt.I<FlashMessageHelper>()
                      .showError(tr('rooms.no_questions_in_room'));
                  return;
                }

                ref.read(updateDetailRoomProvider.notifier).startRoom(room.id);
              },
              child: const Text('rooms.start_game').tr(),
            ),
          )

          // _TutorialItemWidget(
          //   text:
          //       tr('rooms.tutorial.2.2', args: ['${room.questionIds.length}']),
          // ),
          // _TutorialItemWidget(
          //   text: tr('rooms.tutorial.3'),
          // ),
          // _TutorialItemWidget(
          //   text: tr('rooms.tutorial.4'),
          // ),
          // if (isCreatedByMe)
          //   _TutorialItemWidget(
          //     text: 'Pertama, silahkan',
          //     subtext: room.memberNames.map((e) => e.capitalize).join(', '),
          //     child: InkWell(
          //       onTap: () {
          //         _InsertNameWidget(roomId: room.id)
          //             .showCustomDialog<void>(context);
          //       },
          //       child: Text(
          //         'Tambahkan nama akrab teman main kamu',
          //         style: TextStyle(
          //           color: room.memberNames.isNotEmpty
          //               ? Theme.of(context).colorScheme.onBackground
          //               : ColorName.primary,
          //         ),
          //       ),
          //     ),
          //   )
          // else
          //   _TutorialItemWidget(
          //     text:
          //         'Pertama, teman kamu sudah membuat ruangan ini untuk kamu dan juga menambahkan nama kamu, yaitu: ',
          //     subtext: room.memberNames.map((e) => e.capitalize).join(', '),
          //   ),
          // if (isCreatedByMe)
          //   _TutorialItemWidget(
          //     text: 'Lalu kamu bisa',
          //     subtext: '${room.questionIds.length} selected',
          //     child: InkWell(
          //       onTap: () {
          //         GetIt.I<NavigationHelper>().goNamed(
          //           'SelectQuestionsPage',
          //           params: {'rid': room.id},
          //         );
          //       },
          //       child: Text(
          //         'Menambahkan pertanyaan yang kamu inginkan',
          //         style: TextStyle(
          //           color: room.questionIds.isNotEmpty
          //               ? Theme.of(context).colorScheme.onBackground
          //               : ColorName.primary,
          //         ),
          //       ),
          //     ),
          //   )
          // else
          //   _TutorialItemWidget(
          //     text: room.questionIds.isEmpty
          //         ? 'Room master belum memilih pertanyaan'
          //         : 'Terdapat ${room.questionIds.length} pertanyaan terpilih, yang akan di acak beserta dengan nama kamu',
          //   ),
          // _TutorialItemWidget(
          //   text: 'Salin lalu bagikan room ini dengan teman kamu',
          //   child: InkWell(
          //     onTap: () {
          //       Clipboard.setData(
          //         ClipboardData(
          //           text: '$defaultUrl/public-room/${room.id}',
          //         ),
          //       );
          //       GetIt.I<FlashMessageHelper>()
          //           .showTopFlash('URL ruangan disalin');
          //     },
          //     child: const Text(
          //       'Salin Room',
          //       style: TextStyle(
          //         color: ColorName.primary,
          //       ),
          //     ),
          //   ),
          // ),
          // if (isCreatedByMe)
          //   _TutorialItemWidget(
          //     text: 'Bila sudah mengerti,',
          //     child: InkWell(
          //       onTap: () {
          //         ref
          //             .read(updateDetailRoomProvider.notifier)
          //             .startRoom(room.id);
          //       },
          //       child: const Text(
          //         'Ayo main!!',
          //         style: TextStyle(
          //           color: ColorName.primary,
          //         ),
          //       ),
          //     ),
          //   )
          // else
          //   const _TutorialItemWidget(
          //     text: 'Menunggu room master memulai!',
          //   ),
        ],
      ),
    );
  }
}

class _TutorialItemWidget extends StatelessWidget {
  const _TutorialItemWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 24),
          Flexible(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _TutorialItemWidgetOld extends StatelessWidget {
  const _TutorialItemWidgetOld({
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
