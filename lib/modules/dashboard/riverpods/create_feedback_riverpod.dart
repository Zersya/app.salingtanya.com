import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/repositories/feedbacks_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateFeedbackNotifier extends StateNotifier<BasicState> {
  CreateFeedbackNotifier({this.onCreate}) : super(const BasicState.idle());

  final Function()? onCreate;

  final _repo = FeedbacksRepository();

  Future createFeedback(String value) async {
    try {
      state = const BasicState.loading();

      await _repo.createFeedback(value);
      onCreate?.call();

      state = const BasicState.idle();
    } catch (e) {
      state = const BasicState.idle();
    }
  }
}
