import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/repositories/questions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateQuestionNotifier extends StateNotifier<BasicState> {
  CreateQuestionNotifier({this.onCreate}) : super(const BasicState.idle());

  final Function()? onCreate;

  final _repo = QuestionsRepository();

  Future createQuestion(String name, List<String> categoryIds) async {
    try {
      state = const BasicState.loading();

      await _repo.createQuestion(name, categoryIds);
      onCreate?.call();

      state = const BasicState.idle();
    } catch (e) {
      state = const BasicState.idle();
    }
  }
}
