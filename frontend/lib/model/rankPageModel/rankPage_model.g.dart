// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rankPage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RankPageModel _$RankPageModelFromJson(Map<String, dynamic> json) =>
    RankPageModel(
      name: json['name'] as String,
      comment: json['comment'] as String,
      logo: json['logo'] as String,
      unit: (json['unit'] as num).toDouble(),
    );

Map<String, dynamic> _$RankPageModelToJson(RankPageModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'comment': instance.comment,
      'logo': instance.logo,
      'unit': instance.unit,
    };
