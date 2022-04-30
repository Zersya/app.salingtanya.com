import 'package:app_salingtanya/freezed/basic_form_state.dart';
import 'package:app_salingtanya/repositories/rooms_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InsertNamesNotifier extends StateNotifier<BasicFormState> {
  InsertNamesNotifier({
    this.onInsert,
  }) : super(const BasicFormState.idle());

  final Function(List<String>)? onInsert;

  final _repo = RoomsRepository();

  Future insertNames(String docId, List<String> names) async {
    try {
      state = const BasicFormState.loading();

      final result = await _repo.insertNames(names, docId);
      onInsert?.call(result);

      state = const BasicFormState.succeed();
    } catch (e) {
      state = const BasicFormState.failed();
    }
  }
}
