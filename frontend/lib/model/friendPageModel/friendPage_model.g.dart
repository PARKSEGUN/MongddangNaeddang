// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendPage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendPageModel _$FriendPageModelFromJson(Map<String, dynamic> json) =>
    FriendPageModel(
      nickname: json['nickname'] as String? ?? "이름없음",
      profileImage: json['profile_image'] as String? ?? "noImg",
      totalDistance: (json['total_distance'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] as String? ?? "",
    );

Map<String, dynamic> _$FriendPageModelToJson(FriendPageModel instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'profile_image': instance.profileImage,
      'total_distance': instance.totalDistance,
      'comment': instance.comment,
    };
