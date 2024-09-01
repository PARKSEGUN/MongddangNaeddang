import 'package:json_annotation/json_annotation.dart';

part 'region_model.g.dart';

@JsonSerializable(explicitToJson: true) // This allows nested serialization
class Region {
  final String id;
  final String teamId;
  final String name;
  final String color;
  final String logo;
  final List<List<List<double?>>> area; // 3중 리스트

  Region({
    required this.id,
    required this.teamId,
    required this.name,
    required this.color,
    required this.logo,
    required this.area,
  });

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);

  Map<String, dynamic> toJson() => _$RegionToJson(this);
}