// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamSearchPageTeamInfo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchPageTeamModel _$SearchPageTeamModelFromJson(Map<String, dynamic> json) =>
    SearchPageTeamModel(
      teamId: (json['teamId'] as num).toInt(),
      name: json['name'] as String,
      comment: json['comment'] as String,
      color: json['color'] as String,
      logo: json['logo'] as String,
      memberCount: (json['memberCount'] as num).toInt(),
      areaSum: (json['areaSum'] as num).toDouble(),
      distSum: (json['distanceSum'] as num).toDouble(),
      areaRank: (json['areaRank'] as num).toInt(),
      distRank: (json['distanceRank'] as num).toInt(),
    );

Map<String, dynamic> _$SearchPageTeamModelToJson(
        SearchPageTeamModel instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'name': instance.name,
      'comment': instance.comment,
      'color': instance.color,
      'logo': instance.logo,
      'memberCount': instance.memberCount,
      'areaSum': instance.areaSum,
      'distanceSum': instance.distSum,
      'areaRank': instance.areaRank,
      'distanceRank': instance.distRank,
    };
