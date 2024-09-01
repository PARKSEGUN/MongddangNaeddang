// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarmPage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlarmModel _$AlarmModelFromJson(Map<String, dynamic> json) => AlarmModel(
      user1Uuid: json['user1Uuid'] as String,
      user2Uuid: json['user2Uuid'] as String,
      user1Name: json['user1Name'] as String,
      user2Name: json['user2Name'] as String,
      teamId: (json['teamId'] as num).toInt(),
      teamName: json['teamName'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$AlarmModelToJson(AlarmModel instance) =>
    <String, dynamic>{
      'user1Uuid': instance.user1Uuid,
      'user2Uuid': instance.user2Uuid,
      'user1Name': instance.user1Name,
      'user2Name': instance.user2Name,
      'teamId': instance.teamId,
      'teamName': instance.teamName,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt,
    };
