import 'package:app_salingtanya/models/question.dart';
import 'package:app_salingtanya/models/question_category.dart';
import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/exceptions.dart';
import 'package:app_salingtanya/utils/wrappers/error_wrapper.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';

class QuestionsRepository {
  final db = GetIt.I<Database>();

  Future createQuestion(String question, List<String> categoryIds) async {
    final now = DateTime.now();

    await ErrorWrapper.guard(
      () => db.createDocument(
        collectionId: kQuestionsCollectionId,
        documentId: 'unique()',
        data: <String, dynamic>{
          'value': question,
          'category_ids': categoryIds,
          'created_at': now.toIso8601String(),
        },
      ),
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );
  }

  Future<List<Question>> getQuestions({required bool isPopular}) async {
    final result = await ErrorWrapper.guard(
      () => db.listDocuments(
        collectionId: kQuestionsCollectionId,
        queries: <dynamic>[
          if (isPopular) Query.greaterEqual('used_count', 10),
        ],
        orderTypes: <String>[if (isPopular) 'DESC'],
        orderAttributes: <String>[if (isPopular) 'used_count'],
      ),
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );

    return result.documents.map((e) => Question.fromJson(e.data)).toList();
  }

  Future<List<QuestionCategory>> getQuestionCategories() async {
    final result = await ErrorWrapper.guard(
      () => db.listDocuments(collectionId: kQuestionCategoriesCollectionId),
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );

    return result.documents
        .map((e) => QuestionCategory.fromJson(e.data))
        .toList();
  }
}
