// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Badge _$BadgeFromJson(Map<String, dynamic> json) => Badge(
      badgeId: (json['badgeId'] as num).toInt(),
      createdTime: DateTime.parse(json['createdTime'] as String),
      name: json['name'] as String,
    );

Map<String, dynamic> _$BadgeToJson(Badge instance) => <String, dynamic>{
      'badgeId': instance.badgeId,
      'createdTime': instance.createdTime.toIso8601String(),
      'name': instance.name,
    };
