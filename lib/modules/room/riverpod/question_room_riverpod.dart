import 'package:app_salingtanya/freezed/basic_detail_state.dart';
import 'package:app_salingtanya/models/question.dart';
import 'package:app_salingtanya/models/room.dart';
import 'package:app_salingtanya/modules/top_level_providers.dart';
import 'package:app_salingtanya/repositories/questions_repository.dart';
import 'package:app_salingtanya/repositories/rooms_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionRoomNotifier extends StateNotifier<BasicDetailState<Question?>> {
  QuestionRoomNotifier(this.ref)
      : super(const BasicDetailState<Question?>.idle(null));

  final Ref ref;
  final _repo = QuestionsRepository();
  final _repoRoom = RoomsRepository();

  String getRandomQuestionId(List<String> questionIds) {
    final result = _repo.getRandomQuestionId(questionIds);

    return result;
  }

  Future updateActiveQuestionId(
    Room room,
    String questionId,
  ) async {
    try {
      state = const BasicDetailState.loading();

      await _repoRoom.updateActiveQuestionId(room, questionId, room.id);

      final question = ref.read(activeQuestionProvider.notifier).state;

      state = BasicDetailState.idle(question);
    } catch (e) {
      state = BasicDetailState.error(e.toString());
    }
  }

  Future getQuestion(String questionId) async {
    try {
      state = const BasicDetailState<Question?>.loading();

      final result = await _repo.getQuestion(questionId);

      ref.read(activeQuestionProvider.notifier).state = result;

      state = BasicDetailState<Question?>.idle(result);
    } catch (e) {
      state = BasicDetailState<Question?>.error(e.toString());
    }
  }
}
