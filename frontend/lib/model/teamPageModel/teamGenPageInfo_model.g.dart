// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teamGenPageInfo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamGenPageInfoModel _$TeamGenPageInfoModelFromJson(
        Map<String, dynamic> json) =>
    TeamGenPageInfoModel(
      authUuid: json['authUuid'] as String,
      teamName: json['teamName'] as String,
      description: json['description'] as String,
      teamColor: json['teamColor'] as String,
    );

Map<String, dynamic> _$TeamGenPageInfoModelToJson(
        TeamGenPageInfoModel instance) =>
    <String, dynamic>{
      'authUuid': instance.authUuid,
      'teamName': instance.teamName,
      'description': instance.description,
      'teamColor': instance.teamColor,
    };
