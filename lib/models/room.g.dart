// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      json[r'$id'] as String,
      json[r'$collectionId'] as String?,
      json['name'] as String,
      json['slug'] as String,
      json['description'] as String?,
      (json['member_ids'] as List<dynamic>).map((e) => e as String).toList(),
      (json['member_names'] as List<dynamic>).map((e) => e as String).toList(),
      (json['question_ids'] as List<dynamic>).map((e) => e as String).toList(),
      DateTime.parse(json[r'$createdAt'] as String),
      DateTime.parse(json[r'$updatedAt'] as String),
      json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      json['created_by'] as String?,
      json['index_session'] as int? ?? 0,
      json['index_raffle'] as int? ?? 0,
      json['active_question_id'] as String?,
      (json['active_question_emojis'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      r'$id': instance.id,
      r'$collectionId': instance.collectionId,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'member_ids': instance.memberIds,
      'member_names': instance.memberNames,
      'question_ids': instance.questionIds,
      r'$createdAt': instance.createdAt.toIso8601String(),
      r'$updatedAt': instance.updatedAt.toIso8601String(),
      'started_at': instance.startedAt?.toIso8601String(),
      'created_by': instance.createdBy,
      'index_session': instance.indexSession,
      'index_raffle': instance.indexRaffle,
      'active_question_id': instance.activeQuestionId,
      'active_question_emojis': instance.activeQuestionEmojis,
    };
