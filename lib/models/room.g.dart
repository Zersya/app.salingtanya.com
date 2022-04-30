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
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      r'$id': instance.id,
      r'$collection': instance.collection,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'is_active': instance.isActive,
      'member_ids': instance.memberIds,
      'member_names': instance.memberNames,
      'question_ids': instance.questionIds,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
