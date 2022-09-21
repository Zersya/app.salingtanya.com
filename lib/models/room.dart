import 'package:app_salingtanya/helpers/user_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable(explicitToJson: true)
class Room {
  Room(
    this.id,
    this.collectionId,
    this.name,
    this.slug,
    this.description,
    this.memberIds,
    this.memberNames,
    this.questionIds,
    this.createdAt,
    this.updatedAt,
    this.startedAt,
    this.createdBy,
    this.indexSession,
    this.indexRaffle,
    this.activeQuestionId,
    this.activeQuestionEmojis,
  );

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  @JsonKey(name: '\$id')
  final String id;

  @JsonKey(name: '\$collectionId')
  final String? collectionId;

  final String name;

  final String slug;

  final String? description;

  @JsonKey(name: 'member_ids')
  final List<String> memberIds;

  @JsonKey(name: 'member_names')
  final List<String> memberNames;

  @JsonKey(name: 'question_ids')
  final List<String> questionIds;

  @JsonKey(name: '\$createdAt')
  final DateTime createdAt;

  @JsonKey(name: '\$updatedAt')
  final DateTime updatedAt;

  @JsonKey(name: 'started_at')
  final DateTime? startedAt;

  @JsonKey(name: 'created_by')
  final String? createdBy;

  @JsonKey(name: 'index_session', defaultValue: 0)
  final int indexSession;

  @JsonKey(name: 'index_raffle', defaultValue: 0)
  final int indexRaffle;

  @JsonKey(name: 'active_question_id')
  final String? activeQuestionId;

  @JsonKey(name: 'active_question_emojis')
  List<String> activeQuestionEmojis;

  bool isCreatedByMe() => createdBy == GetIt.I<UserHelper>().userId;
}
