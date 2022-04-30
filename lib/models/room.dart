import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable(explicitToJson: true)
class Room {
  Room(
    this.id,
    this.collection,
    this.name,
    this.slug,
    this.description,
    this.memberIds,
    this.memberNames,
    this.questionIds,
    this.createdAt,
    this.updatedAt, {
    required this.isActive,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  @JsonKey(name: '\$id')
  final String id;

  @JsonKey(name: '\$collection')
  final String collection;

  final String name;

  final String slug;

  final String? description;

  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'member_ids')
  final List<String> memberIds;

  @JsonKey(name: 'member_names')
  final List<String> memberNames;

  @JsonKey(name: 'question_ids')
  final List<String> questionIds;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
}
