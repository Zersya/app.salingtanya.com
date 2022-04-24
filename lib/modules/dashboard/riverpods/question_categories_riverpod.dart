import 'package:app_salingtanya/freezed/basic_list_state.dart';
import 'package:app_salingtanya/models/question_category.dart';
import 'package:app_salingtanya/repositories/questions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionCategoriesNotifier
    extends StateNotifier<BasicListState<QuestionCategory>> {
  QuestionCategoriesNotifier()
      : super(const BasicListState<QuestionCategory>.idle([]));

  final _repo = QuestionsRepository();

  Future getQuestionCategories() async {
    try {
      state = const BasicListState<QuestionCategory>.loading();

      final result = await _repo.getQuestionCategories();

      state = BasicListState<QuestionCategory>.idle(result);
    } catch (e) {
      state = BasicListState<QuestionCategory>.error(e.toString());
    }
  }
}
