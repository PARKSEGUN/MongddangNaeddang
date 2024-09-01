import 'package:json_annotation/json_annotation.dart';

part 'friendPage_model.g.dart';

@JsonSerializable()
class FriendPageModel {
  @JsonKey(name: "nickname")
  final String nickname;
  @JsonKey(name: "profile_image")
  final String profileImage;
  @JsonKey(name: "total_distance")
  final double totalDistance;
  @JsonKey(name: "comment")
  final String comment;

  FriendPageModel({
    this.nickname="이름없음",
    this.profileImage="noImg",
    this.totalDistance=0.0,
    this.comment="",
  });

  factory FriendPageModel.fromJson(Map<String, dynamic> json) => _$FriendPageModelFromJson(json);
  Map<String, dynamic> toJson() => _$FriendPageModelToJson(this);
}