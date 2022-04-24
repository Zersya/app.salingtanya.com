import 'package:json_annotation/json_annotation.dart';

part 'question_category.g.dart';

@JsonSerializable(explicitToJson: true)
class QuestionCategory {
  QuestionCategory(
    this.id,
    this.collection,
    this.color,
    this.nameEn,
    this.nameId,
  );

  factory QuestionCategory.fromJson(Map<String, dynamic> json) =>
      _$QuestionCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionCategoryToJson(this);

  @JsonKey(name: '\$id')
  final String id;

  @JsonKey(name: '\$collection')
  final String collection;

  @JsonKey(name: 'name_en')
  final String nameEn;
  @JsonKey(name: 'name_id')
  final String nameId;

  final String color;
}
