// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamPageMember_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamPageMemberModel _$TeamPageMemberModelFromJson(Map<String, dynamic> json) =>
    TeamPageMemberModel(
      uID: json['authUuid'] as String,
      tID: (json['teamId'] as num).toInt(),
      memberName: json['nickname'] as String,
      memberImage: json['userImage'] as String,
      memberDistance: (json['distance'] as num).toDouble(),
      memberMemo: json['comment'] as String,
      isLeader: json['leader'] as bool,
    );

Map<String, dynamic> _$TeamPageMemberModelToJson(
        TeamPageMemberModel instance) =>
    <String, dynamic>{
      'authUuid': instance.uID,
      'teamId': instance.tID,
      'nickname': instance.memberName,
      'userImage': instance.memberImage,
      'distance': instance.memberDistance,
      'comment': instance.memberMemo,
      'leader': instance.isLeader,
    };
