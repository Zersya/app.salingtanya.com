import 'package:app_salingtanya/models/room.dart';
import 'package:app_salingtanya/utils/constants.dart';
import 'package:app_salingtanya/utils/exceptions.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';

class RoomsRepository {
  final db = GetIt.I<Database>();

  Future createRoom(String name) async {
    try {
      final now = DateTime.now();
      final slug =
          // ignore: lines_longer_than_80_chars
          '${name.toLowerCase().replaceAll(' ', '-')}-${now.millisecondsSinceEpoch}';

      await db.createDocument(
        collectionId: kRoomsCollectionId,
        documentId: 'unique()',
        data: <String, dynamic>{
          'name': name,
          'slug': slug,
          'created_at': now.toIso8601String(),
        },
      );
    } catch (e) {
      throw ExceptionWithMessage(e.toString());
    }
  }

  Future<List<Room>> getRooms() async {
    try {
      final result = await db.listDocuments(collectionId: kRoomsCollectionId);

      return result.documents.reversed
          .map((e) => Room.fromJson(e.data))
          .toList();
    } catch (e) {
      throw ExceptionWithMessage(e.toString());
    }
  }
}
