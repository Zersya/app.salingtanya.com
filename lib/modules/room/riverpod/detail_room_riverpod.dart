import 'package:app_salingtanya/freezed/basic_detail_state.dart';
import 'package:app_salingtanya/models/room.dart';
import 'package:app_salingtanya/modules/room/view/detail_room_page.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/repositories/rooms_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailRoomNotifier extends StateNotifier<BasicDetailState<Room?>> {
  DetailRoomNotifier(this.ref)
      : super(BasicDetailState<Room?>.idle(ref.read(selectedRoomProvider)));

  late String roomId;

  final Ref ref;
  final _repo = RoomsRepository();

  void subscribe(String roomId) {
    this.roomId = roomId;
    _repo.subscribe(roomId);
  }

  void listen() {
    _repo.subscription.stream.listen((event) {
      final room = Room.fromJson(event.payload);

      ref.read(selectedRoomProvider.notifier).state = room;
      ref.read(selectedQuestionsProvider.notifier).state = room.questionIds;

      final activeQuestion = ref.read(activeQuestionProvider);

      if (room.activeQuestionId != null) {
        if (activeQuestion == null ||
            (room.activeQuestionId != activeQuestion.id)) {
          ref
              .read(questionRoomProvider.notifier)
              .getQuestion(room.activeQuestionId!);
        }
      }
    });
  }

  void Function() close() => _repo.subscription.close;

  Future getRoom() async {
    try {
      state = const BasicDetailState<Room?>.loading();

      final result = await _repo.getRoom(roomId);
      ref.read(selectedRoomProvider.notifier).state = result;
      ref.read(selectedQuestionsProvider.notifier).state = result.questionIds;

      state = BasicDetailState<Room?>.idle(result);
    } catch (e) {
      state = BasicDetailState<Room?>.error(e.toString());
    }
  }
}
