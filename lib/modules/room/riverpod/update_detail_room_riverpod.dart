import 'package:app_salingtanya/freezed/basic_form_state.dart';
import 'package:app_salingtanya/repositories/rooms_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateDetailRoomNotifier extends StateNotifier<BasicFormState> {
  UpdateDetailRoomNotifier({
    this.onUpdate,
  }) : super(const BasicFormState.idle());

  final Function(List<String>)? onUpdate;

  final _repo = RoomsRepository();

  Future updateNames(String docId, List<String> names) async {
    try {
      state = const BasicFormState.loading();

      final result = await _repo.updateNames(names, docId);
      onUpdate?.call(result);

      state = const BasicFormState.succeed();
    } catch (e) {
      state = const BasicFormState.failed();
    }
  }

  Future updateQuestions(String docId, List<String> questions) async {
    try {
      state = const BasicFormState.loading();

      final result = await _repo.updateQuestions(questions, docId);
      onUpdate?.call(result);

      state = const BasicFormState.succeed();
    } catch (e) {
      state = const BasicFormState.failed();
    }
  }
}
