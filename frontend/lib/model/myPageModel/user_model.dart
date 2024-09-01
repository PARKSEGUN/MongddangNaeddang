import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String nickname;
  final String? comment;         // nullable로 유지
  final String? profileImage;    // nullable로 유지
  final String? address;         // nullable로 유지

  UserModel({
    required this.nickname,
    this.comment,       // nullable로 유지
    this.profileImage,  // nullable로 유지
    this.address,       // nullable로 유지
  });

  // JSON 데이터를 User 객체로 변환하는 factory constructor
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  // User 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}