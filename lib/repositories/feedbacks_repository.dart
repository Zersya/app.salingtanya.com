import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/exceptions.dart';
import 'package:app_salingtanya/utils/wrappers/error_wrapper.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';

class FeedbacksRepository {
  final db = GetIt.I<Databases>();

  Future<void> createFeedback(String value) async {
    final now = DateTime.now();

    await ErrorWrapper.guard(
      () => db.createDocument(
        databaseId: kDatabaseId,
        collectionId: kFeedbacksCollectionId,
        documentId: 'unique()',
        data: <String, dynamic>{
          'value': value,
        },
      ),
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );
  }
}
