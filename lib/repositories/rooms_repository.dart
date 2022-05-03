import 'package:app_salingtanya/models/room.dart';
import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/exceptions.dart';
import 'package:app_salingtanya/utils/wrappers/error_wrapper.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';

class RoomsRepository {
  final db = GetIt.I<Database>();
  final realtime = GetIt.I<Realtime>();
  late RealtimeSubscription subscription;

  Future<void> subscribe(String roomId) async {
    subscription = realtime
        .subscribe(['collections.$kRoomsCollectionId.documents.$roomId']);
  }

  Future<Room> createRoom(String name) async {
    final result = await ErrorWrapper.guard(
      () {
        final now = DateTime.now();
        final slug =
            // ignore: lines_longer_than_80_chars
            '${name.toLowerCase().replaceAll(' ', '-')}-${now.millisecondsSinceEpoch}';

        return db.createDocument(
          collectionId: kRoomsCollectionId,
          documentId: 'unique()',
          data: <String, dynamic>{
            'name': name,
            'slug': slug,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          },
        );
      },
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );

    return Room.fromJson(result.data);
  }

  Future<List<Room>> getRooms() async {
    final result = await ErrorWrapper.guard(
      () => db.listDocuments(collectionId: kRoomsCollectionId),
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );

    return result.documents.reversed.map((e) => Room.fromJson(e.data)).toList();
  }

  Future<Room> getRoom(String id) async {
    final result = await ErrorWrapper.guard(
      () => db.getDocument(collectionId: kRoomsCollectionId, documentId: id),
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );

    return Room.fromJson(result.data);
  }

  Future<List<String>> updateNames(List<String> names, String docId) async {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'member_names': names,
      'updated_at': now.toIso8601String(),
    };

    final result = await ErrorWrapper.guard(
      () => db.updateDocument(
        collectionId: kRoomsCollectionId,
        documentId: docId,
        data: data,
      ),
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );

    return List<String>.from(result.data['member_names'] as List)
        .map((e) => e)
        .toList();
  }

  Future<List<String>> updateQuestions(
    List<String> questions,
    String docId,
  ) async {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'question_ids': questions,
      'updated_at': now.toIso8601String(),
    };

    final result = await ErrorWrapper.guard(
      () => db.updateDocument(
        collectionId: kRoomsCollectionId,
        documentId: docId,
        data: data,
      ),
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );

    await ErrorWrapper.guard(() async {
      for (final questionId in questions) {
        final rawQuestion = await db.getDocument(
          collectionId: kQuestionsCollectionId,
          documentId: questionId,
        );

        final usedCount = rawQuestion.data['used_count'] as int;

        final data = <String, dynamic>{
          'used_count': usedCount + 1,
        };

        await db.updateDocument(
          collectionId: kQuestionsCollectionId,
          documentId: questionId,
          data: data,
        );
      }
    });

    return List<String>.from(result.data['member_names'] as List)
        .map((e) => e)
        .toList();
  }

  Future<void> startRoom(String docId) async {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'started_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    };

    await ErrorWrapper.guard(
      () => db.updateDocument(
        collectionId: kRoomsCollectionId,
        documentId: docId,
        data: data,
      ),
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );
  }

  Future<void> updateActiveQuestionId(
    Room room,
    String questionId,
    String docId,
  ) async {
    var indexRaffle = room.indexRaffle + 1;

    var indexSession = room.indexSession;

    if (indexRaffle == room.memberNames.length - 1) {
      indexRaffle = 0;
      indexSession++;
    }

    final now = DateTime.now();
    final data = <String, dynamic>{
      'active_question_id': questionId,
      'active_question_emojis': <String>[],
      'index_raffle': indexRaffle,
      'index_session': indexSession,
      'updated_at': now.toIso8601String(),
    };

    await ErrorWrapper.guard(
      () => db.updateDocument(
        collectionId: kRoomsCollectionId,
        documentId: docId,
        data: data,
      ),
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );
  }

  Future<void> updateActiveQuestionEmojis(
    List<String> emojis,
    String docId,
  ) async {
    final now = DateTime.now();
    final data = <String, dynamic>{
      'active_question_emojis': emojis,
      'updated_at': now.toIso8601String(),
    };

    await ErrorWrapper.guard(
      () => db.updateDocument(
        collectionId: kRoomsCollectionId,
        documentId: docId,
        data: data,
      ),
      onError: (e) => throw ExceptionWithMessage(e.toString()),
    );
  }
}
