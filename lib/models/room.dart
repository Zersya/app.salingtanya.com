import 'package:app_salingtanya/helpers/user_helper.dart';
import 'package:get_it/get_it.dart';
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
    this.updatedAt,
    this.startedAt,
    this.writeBy,
    this.indexSession,
    this.indexRaffle,
    this.activeQuestionId,
    this.activeQuestionEmojis,
  );

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  Map<String, dynamic> toJson() => _$RoomToJson(this);

  @JsonKey(name: '\$id')
  final String id;

  @JsonKey(name: '\$collection')
  final String collection;

  final String name;

  final String slug;

  final String? description;

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

  @JsonKey(name: 'started_at')
  final DateTime? startedAt;

  @JsonKey(name: '\$write')
  final List<String> writeBy;

  @JsonKey(name: 'index_session')
  final int indexSession;

  @JsonKey(name: 'index_raffle')
  final int indexRaffle;

  @JsonKey(name: 'active_question_id')
  final String? activeQuestionId;

  @JsonKey(name: 'active_question_emojis')
  List<String> activeQuestionEmojis;

  bool isCreatedByMe() =>
      writeBy.contains('user:${GetIt.I<UserHelper>().userId}');
}
