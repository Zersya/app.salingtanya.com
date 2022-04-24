import 'package:app_salingtanya/freezed/basic_list_state.dart';
import 'package:app_salingtanya/models/question.dart';
import 'package:app_salingtanya/repositories/questions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionsNotifier extends StateNotifier<BasicListState<Question>> {
  QuestionsNotifier() : super(const BasicListState<Question>.idle([]));

  final _repo = QuestionsRepository();

  Future getQuestions({bool isPopular = false}) async {
    try {
      state = const BasicListState<Question>.loading();

      final result = await _repo.getQuestions(isPopular: isPopular);

      state = BasicListState<Question>.idle(result);
    } catch (e) {
      state = BasicListState<Question>.error(e.toString());
    }
  }
}
