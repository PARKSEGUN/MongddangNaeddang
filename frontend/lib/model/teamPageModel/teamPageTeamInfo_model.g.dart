// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamPageTeamInfo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamPageTeamInfoModel _$TeamPageTeamInfoModelFromJson(
        Map<String, dynamic> json) =>
    TeamPageTeamInfoModel(
      teamID: (json['teamId'] as num).toInt(),
      teamName: json['name'] as String,
      teamMemo: json['comment'] as String,
      teamColor: json['color'] as String,
      teamLogo: json['logo'] as String,
      teamAreaRank: (json['areaRank'] as num).toInt(),
      teamDistRank: (json['distanceRank'] as num).toInt(),
      areaSum: (json['areaSum'] as num).toDouble(),
      distanceSum: (json['distanceSum'] as num).toDouble(),
      memberCount: (json['memberCount'] as num).toInt(),
    );

Map<String, dynamic> _$TeamPageTeamInfoModelToJson(
        TeamPageTeamInfoModel instance) =>
    <String, dynamic>{
      'teamId': instance.teamID,
      'name': instance.teamName,
      'comment': instance.teamMemo,
      'color': instance.teamColor,
      'logo': instance.teamLogo,
      'memberCount': instance.memberCount,
      'areaSum': instance.areaSum,
      'distanceSum': instance.distanceSum,
      'areaRank': instance.teamAreaRank,
      'distanceRank': instance.teamDistRank,
    };
