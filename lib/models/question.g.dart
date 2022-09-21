// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      json[r'$id'] as String,
      json[r'$collectionId'] as String,
      json['value'] as String,
      json['used_count'] as int,
      (json['category_ids'] as List<dynamic>).map((e) => e as String).toList(),
      DateTime.parse(json[r'$createdAt'] as String),
      json['language'] as String? ?? 'id',
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      r'$id': instance.id,
      r'$collectionId': instance.collectionId,
      'value': instance.value,
      'used_count': instance.usedCount,
      'category_ids': instance.categoryIds,
      r'$createdAt': instance.createdAt.toIso8601String(),
      'language': instance.language,
    };
