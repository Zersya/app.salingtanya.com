import 'package:app_salingtanya/freezed/basic_form_state.dart';
import 'package:app_salingtanya/repositories/rooms_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateDetailRoomNotifier extends StateNotifier<BasicFormState> {
  UpdateDetailRoomNotifier({
    this.onUpdate,
  }) : super(const BasicFormState.idle());

  final Function()? onUpdate;

  final _repo = RoomsRepository();

  Future updateNames(String docId, List<String> names) async {
    try {
      state = const BasicFormState.loading();

      await _repo.updateNames(names, docId);
      onUpdate?.call();

      state = const BasicFormState.succeed();
    } catch (e) {
      state = const BasicFormState.failed();
    }
  }

  Future updateQuestions(String docId, List<String> questions) async {
    try {
      state = const BasicFormState.loading();

      await _repo.updateQuestions(questions, docId);
      onUpdate?.call();

      state = const BasicFormState.succeed();
    } catch (e) {
      state = const BasicFormState.failed();
    }
  }

  Future startRoom(String docId) async {
    try {
      state = const BasicFormState.loading();

      await _repo.startRoom(docId);
      onUpdate?.call();

      state = const BasicFormState.succeed();
    } catch (e) {
      state = const BasicFormState.failed();
    }
  }

  Future updateActiveQuestionId(
    String questionId,
    int indexShuffle,
    String docId,
  ) async {
    try {
      state = const BasicFormState.loading();

      await _repo.updateActiveQuestionId(questionId, indexShuffle, docId);
      onUpdate?.call();

      state = const BasicFormState.succeed();
    } catch (e) {
      state = const BasicFormState.failed();
    }
  }
}
