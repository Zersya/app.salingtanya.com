// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionCategory _$QuestionCategoryFromJson(Map<String, dynamic> json) =>
    QuestionCategory(
      json[r'$id'] as String,
      json[r'$collection'] as String,
      json['color'] as String,
      json['name_en'] as String,
      json['name_id'] as String,
    );

Map<String, dynamic> _$QuestionCategoryToJson(QuestionCategory instance) =>
    <String, dynamic>{
      r'$id': instance.id,
      r'$collection': instance.collection,
      'name_en': instance.nameEn,
      'name_id': instance.nameId,
      'color': instance.color,
    };
