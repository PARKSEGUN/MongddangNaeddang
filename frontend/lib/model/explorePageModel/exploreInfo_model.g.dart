// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exploreInfo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExploreinfoModel _$ExploreinfoModelFromJson(Map<String, dynamic> json) =>
    ExploreinfoModel(
      isStart: json['isStart'] as bool,
      currentPosition: json['currentPosition'] == null
          ? null
          : SimplePosition.fromJson(
              json['currentPosition'] as Map<String, dynamic>),
      firstPosition: json['firstPosition'] == null
          ? null
          : SimplePosition.fromJson(
              json['firstPosition'] as Map<String, dynamic>),
      prevPosition: json['prevPosition'] == null
          ? null
          : SimplePosition.fromJson(
              json['prevPosition'] as Map<String, dynamic>),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      path: (json['path'] as List<dynamic>?)
          ?.map((e) => SimplePosition.fromJson(e as Map<String, dynamic>))
          .toList(),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      showStartMessage: json['showStartMessage'] as bool,
    );

Map<String, dynamic> _$ExploreinfoModelToJson(ExploreinfoModel instance) =>
    <String, dynamic>{
      'isStart': instance.isStart,
      'currentPosition': instance.currentPosition,
      'firstPosition': instance.firstPosition,
      'prevPosition': instance.prevPosition,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'totalDistance': instance.totalDistance,
      'path': instance.path,
      'showStartMessage': instance.showStartMessage,
    };
