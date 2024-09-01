import 'package:json_annotation/json_annotation.dart';

part 'badge_model.g.dart'; // 생성된 파일을 포함합니다.


//뱃지 데이터 클래스
@JsonSerializable()
class Badge {

  final int badgeId; // 뱃지 id
  final DateTime createdTime; // 뱃지 생성 날짜, 나중에 들어올 수 있음
  final String name; // 뱃지 이름

  Badge(
      {required this.badgeId, required this.createdTime, required this.name});

  // JSON 데이터를 Dart 객체로 변환하기 위한 팩토리 생성자
  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);

  // Dart 객체를 JSON 데이터로 변환하기 위한 메서드
  Map<String, dynamic> toJson() => _$BadgeToJson(this);
}

