import 'package:json_annotation/json_annotation.dart';

part 'alarmPage_model.g.dart';

@JsonSerializable()
class AlarmModel {
  @JsonKey(name: "user1Uuid")
  final String user1Uuid;
  @JsonKey(name: "user2Uuid")
  final String user2Uuid;
  @JsonKey(name: "user1Name")
  final String user1Name;
  @JsonKey(name: "user2Name")
  final String user2Name;
  @JsonKey(name: "teamId")
  final int teamId;
  @JsonKey(name: "teamName")
  final String teamName;
  @JsonKey(name: "title")
  final String title;
  @JsonKey(name: "content")
  final String content;
  @JsonKey(name: "createdAt")
  final String createdAt;

  const AlarmModel({
    required this.user1Uuid,
    required this.user2Uuid,
    required this.user1Name,
    required this.user2Name,
    required this.teamId,
    required this.teamName,
    required this.title,
    required this.content,
    required this.createdAt
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) => _$AlarmModelFromJson(json);
  Map<String, dynamic> toJson() => _$AlarmModelToJson(this);
}