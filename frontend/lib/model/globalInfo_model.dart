// import 'package:json_annotation/json_annotation.dart';
// import 'myPageModel/user_model.dart';
//
// part 'globaInfo.g.dart';
//
// @JsonSerializable()
// class GlobalInfo {
//   final String authUuid;
//   final String teamId;
//   final UserModel user;
//
//   GlobalModel({
//     required this.authUuid,
//     required this.teamId,
//     required this.user,
//   });
//
//   // JSON 데이터를 GlobalModel 객체로 변환하는 factory constructor
//   factory GlobalModel.fromJson(Map<String, dynamic> json) => _$GlobalModelFromJson(json);
//
//   // GlobalModel 객체를 JSON 형식으로 변환하는 메서드
//   Map<String, dynamic> toJson() => _$GlobalModelToJson(this);
// }