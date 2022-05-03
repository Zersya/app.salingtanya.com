import 'package:app_salingtanya/freezed/basic_list_state.dart';
import 'package:app_salingtanya/freezed/basic_state.dart';
import 'package:app_salingtanya/helpers/navigation_helper.dart';
import 'package:app_salingtanya/models/question.dart';
import 'package:app_salingtanya/models/question_category.dart';
import 'package:app_salingtanya/models/room.dart';
import 'package:app_salingtanya/modules/auth/riverpods/auth_riverpod.dart';
import 'package:app_salingtanya/modules/dashboard/riverpods/question_categories_riverpod.dart';
import 'package:app_salingtanya/widgets/list_category/riverpod/list_question_category_riverpod.dart';
import 'package:app_salingtanya/widgets/list_question/riverpod/create_question_riverpod.dart';
import 'package:app_salingtanya/widgets/list_question/riverpod/list_question_riverpod.dart';
import 'package:app_salingtanya/widgets/room/riverpod/create_room_riverpod.dart';
import 'package:app_salingtanya/widgets/room/riverpod/list_room_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod/riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, BasicState>(
  (ref) => AuthNotifier(),
);

final roomsProvider =
    StateNotifierProvider<ListRoomNotifier, BasicListState<Room>>(
  (ref) => ListRoomNotifier()..getRooms(),
);

final popularQuestionsProvider =
    StateNotifierProvider<ListQuestionNotifier, BasicListState<Question>>(
  (ref) => ListQuestionNotifier()..getQuestions(isPopular: true),
);

final latestAddedQuestionsProvider =
    StateNotifierProvider<ListQuestionNotifier, BasicListState<Question>>(
  (ref) => ListQuestionNotifier()..getQuestions(),
);

final latestQuestionCategoriesProvider = StateNotifierProvider<
    ListQuestionCategoryNotifier, BasicListState<QuestionCategory>>(
  (ref) => ListQuestionCategoryNotifier()..getCategories(),
);

final createQuestionProvider =
    StateNotifierProvider.autoDispose<CreateQuestionNotifier, BasicState>(
  (ref) => CreateQuestionNotifier(
    onCreate: () {
      ref.read(latestAddedQuestionsProvider.notifier).getQuestions();
      ref.read(popularQuestionsProvider.notifier).getQuestions(isPopular: true);
    },
  ),
);

final createRoomProvider =
    StateNotifierProvider.autoDispose<CreateRoomNotifier, BasicState>(
  (ref) => CreateRoomNotifier(
    onCreate: (result) {
      ref.read(selectedRoomProvider.notifier).state = result;

      ref.read(roomsProvider.notifier).getRooms();
      GetIt.I<NavigationHelper>().goNamed(
        'DetailRoomPage',
        params: {
          'rid': result.id,
        },
      );
    },
  ),
);

final selectedFormQuestionCategoryProvider =
    StateProvider.autoDispose<QuestionCategory?>((ref) => null);

final questionCategoriesProvider = StateNotifierProvider.autoDispose<
    QuestionCategoriesNotifier, BasicListState<QuestionCategory>>(
  (ref) => QuestionCategoriesNotifier()..getQuestionCategories(),
);

final selectedRoomProvider = StateProvider<Room?>((ref) => null);

final selectedQuestionsProvider = StateProvider<List<String>>((ref) => []);

final selectedQuestionCategoryProvider =
    StateProvider<List<String>>((ref) => []);

final activeQuestionProvider = StateProvider<Question?>((ref) => null);
