// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      json[r'$id'] as String,
      json[r'$collection'] as String,
      json['name'] as String,
      json['slug'] as String,
      json['description'] as String?,
      (json['member_ids'] as List<dynamic>).map((e) => e as String).toList(),
      (json['member_names'] as List<dynamic>).map((e) => e as String).toList(),
      (json['question_ids'] as List<dynamic>).map((e) => e as String).toList(),
      DateTime.parse(json['created_at'] as String),
      DateTime.parse(json['updated_at'] as String),
      json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      (json[r'$write'] as List<dynamic>).map((e) => e as String).toList(),
      json['index_session'] as int,
      json['index_raffle'] as int,
      json['active_question_id'] as String?,
      (json['active_question_emojis'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      r'$id': instance.id,
      r'$collection': instance.collection,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'member_ids': instance.memberIds,
      'member_names': instance.memberNames,
      'question_ids': instance.questionIds,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'started_at': instance.startedAt?.toIso8601String(),
      r'$write': instance.writeBy,
      'index_session': instance.indexSession,
      'index_raffle': instance.indexRaffle,
      'active_question_id': instance.activeQuestionId,
      'active_question_emojis': instance.activeQuestionEmojis,
    };
