import 'package:json_annotation/json_annotation.dart';

part 'rankPage_model.g.dart';

@JsonSerializable()
class RankPageModel {

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'comment')
  final String comment;
  @JsonKey(name: 'logo')
  final String logo;
  @JsonKey(name: 'unit')
  final double unit;

  RankPageModel({
    required this.name,
    required this.comment,
    required this.logo,
    required this.unit,
  });

  factory RankPageModel.fromJson(Map<String, dynamic> json) => _$RankPageModelFromJson(json);
  Map<String, dynamic> toJson() => _$RankPageModelToJson(this);
}
