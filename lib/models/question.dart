import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable(explicitToJson: true)
class Question {
  Question(
    this.id,
    this.collectionId,
    this.value,
    this.usedCount,
    this.categoryIds,
    this.createdAt,
    this.language,
  );

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  @JsonKey(name: '\$id')
  final String id;

  @JsonKey(name: '\$collectionId')
  final String collectionId;

  final String value;

  @JsonKey(name: 'used_count')
  final int usedCount;

  @JsonKey(name: 'category_ids')
  final List<String> categoryIds;

  @JsonKey(name: '\$createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'language', defaultValue: 'id')
  final String language;
}
