import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/exceptions.dart';
import 'package:app_salingtanya/utils/wrappers/error_wrapper.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';

class FeedbacksRepository {
  final db = GetIt.I<Database>();

  Future createFeedback(String value) async {
    final now = DateTime.now();

    await ErrorWrapper.guard(
      () => db.createDocument(
        collectionId: kFeedbacksCollectionId,
        documentId: 'unique()',
        data: <String, dynamic>{
          'value': value,
          'created_at': now.toIso8601String(),
        },
      ),
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );
  }

}
