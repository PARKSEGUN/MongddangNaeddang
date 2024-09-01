// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Region _$RegionFromJson(Map<String, dynamic> json) => Region(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      logo: json['logo'] as String,
      area: (json['area'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => (e as List<dynamic>)
                  .map((e) => (e as num?)?.toDouble())
                  .toList())
              .toList())
          .toList(),
    );

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'name': instance.name,
      'color': instance.color,
      'logo': instance.logo,
      'area': instance.area,
    };
