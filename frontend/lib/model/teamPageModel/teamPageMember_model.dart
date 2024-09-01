import 'package:json_annotation/json_annotation.dart';

part 'teamPageMember_model.g.dart';

@JsonSerializable()
class TeamPageMemberModel {
  @JsonKey(name: "authUuid")
  final String uID;
  @JsonKey(name: "teamId")
  final int tID;
  @JsonKey(name: "nickname")
  final String memberName;
  @JsonKey(name: "userImage")
  final String memberImage;
  @JsonKey(name: "distance")
  final double memberDistance;
  @JsonKey(name: "comment")
  final String memberMemo;
  @JsonKey(name: "leader")
  final bool isLeader;

  TeamPageMemberModel({
    required this.uID,
    required this.tID,
    required this.memberName,
    required this.memberImage,
    required this.memberDistance,
    required this.memberMemo,
    required this.isLeader,
  });

  factory TeamPageMemberModel.fromJson(Map<String, dynamic> json) => _$TeamPageMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$TeamPageMemberModelToJson(this);
}
