import 'package:app_salingtanya/models/question.dart';
import 'package:app_salingtanya/models/question_category.dart';
import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/exceptions.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';

class QuestionsRepository {
  final db = GetIt.I<Database>();

  Future createQuestion(String question, List<String> categoryIds) async {
    try {
      final now = DateTime.now();
      await db.createDocument(
        collectionId: kQuestionsCollectionId,
        documentId: 'unique()',
        data: <String, dynamic>{
          'value': question,
          'category_ids': categoryIds,
          'created_at': now.toIso8601String(),
        },
      );
    } catch (e) {
      throw ExceptionWithMessage(e.toString());
    }
  }

  Future<List<Question>> getQuestions({required bool isPopular}) async {
    try {
      final result =
          await db.listDocuments(collectionId: kQuestionsCollectionId);

      final data =
          result.documents.reversed.map((e) => Question.fromJson(e.data));

      if (isPopular) {
        return data
            .where((element) => isPopular && element.usedCount > 10)
            .toList();
      } else {
        return data.toList();
      }
    } catch (e) {
      throw ExceptionWithMessage(e.toString());
    }
  }

  Future<List<QuestionCategory>> getQuestionCategories() async {
    try {
      final result =
          await db.listDocuments(collectionId: kQuestionCategoriesCollectionId);

      return result.documents
          .map((e) => QuestionCategory.fromJson(e.data))
          .toList();
    } catch (e) {
      throw ExceptionWithMessage(e.toString());
    }
  }
}
