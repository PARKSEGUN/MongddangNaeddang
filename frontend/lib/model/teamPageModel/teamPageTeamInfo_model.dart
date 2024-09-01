import 'package:json_annotation/json_annotation.dart';

part 'teamPageTeamInfo_model.g.dart';

@JsonSerializable()
class TeamPageTeamInfoModel {
  @JsonKey(name: "teamId")
  late int teamID;
  @JsonKey(name: "name")
  late String teamName;
  @JsonKey(name: "comment")
  late String teamMemo;
  @JsonKey(name: "color")
  late String teamColor;
  @JsonKey(name: "logo")
  late String teamLogo;
  @JsonKey(name: "memberCount")
  late int memberCount;
  @JsonKey(name: "areaSum")
  late double areaSum;
  @JsonKey(name: "distanceSum")
  late double distanceSum;
  @JsonKey(name: "areaRank")
  late int teamAreaRank;
  @JsonKey(name: "distanceRank")
  late int teamDistRank;

  TeamPageTeamInfoModel.empty();

  TeamPageTeamInfoModel({
    required this.teamID,
    required this.teamName,
    required this.teamMemo,
    required this.teamColor,
    required this.teamLogo,
    required this.teamAreaRank,
    required this.teamDistRank,
    required this.areaSum,
    required this.distanceSum,
    required this.memberCount,
  });

  factory TeamPageTeamInfoModel.fromJson(Map<String, dynamic>json) => _$TeamPageTeamInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$TeamPageTeamInfoModelToJson(this);
}
