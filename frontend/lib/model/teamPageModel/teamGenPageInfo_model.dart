import 'package:json_annotation/json_annotation.dart';

part 'teamGenPageInfo_model.g.dart';

@JsonSerializable()
class TeamGenPageInfoModel {
  @JsonKey(name: "authUuid")
  late String authUuid;
  @JsonKey(name: "teamName")
  late String teamName;
  @JsonKey(name: "description")
  late String description;
  @JsonKey(name: "teamColor")
  late String teamColor;

  TeamGenPageInfoModel.empty();

  TeamGenPageInfoModel({
    required this.authUuid,
    required this.teamName,
    required this.description,
    required this.teamColor,
  });

  factory TeamGenPageInfoModel.fromJson(Map<String, dynamic>json) => _$TeamGenPageInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$TeamGenPageInfoModelToJson(this);
}
