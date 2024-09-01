import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'teamSearchPageTeamInfo_model.g.dart';

@JsonSerializable()
class SearchPageTeamModel {
  @JsonKey(name: "teamId")
  final int teamId;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "comment")
  final String comment;
  @JsonKey(name: "color")
  final String color;
  @JsonKey(name: "logo")
  final String logo;
  @JsonKey(name: "memberCount")
  final int memberCount;
  @JsonKey(name: "areaSum")
  final double areaSum;
  @JsonKey(name: "distanceSum")
  final double distSum;
  @JsonKey(name: "areaRank")
  final int areaRank;
  @JsonKey(name: "distanceRank")
  final int distRank;

  const SearchPageTeamModel({
    required this.teamId,
    required this.name,
    required this.comment,
    required this.color,
    required this.logo,
    required this.memberCount,
    required this.areaSum,
    required this.distSum,
    required this.areaRank,
    required this.distRank,
  });

  factory SearchPageTeamModel.fromJson(Map<String, dynamic> json) => _$SearchPageTeamModelFromJson(json);
  Map<String, dynamic> toJson() => _$SearchPageTeamModelToJson(this);
}
