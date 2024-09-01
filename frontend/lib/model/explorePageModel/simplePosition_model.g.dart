// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simplePosition_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimplePosition _$SimplePositionFromJson(Map<String, dynamic> json) =>
    SimplePosition(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$SimplePositionToJson(SimplePosition instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
