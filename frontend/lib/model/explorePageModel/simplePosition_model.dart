import 'package:json_annotation/json_annotation.dart';

part 'simplePosition_model.g.dart';

@JsonSerializable()
class SimplePosition {
  final double latitude; // 경도
  final double longitude;// 위도

  SimplePosition({required this.latitude, required this.longitude});

  // JSON 직렬화 및 역직렬화를 위한 팩토리 생성자와 메서드
  factory SimplePosition.fromJson(Map<String, dynamic> json) => _$SimplePositionFromJson(json);
  Map<String, dynamic> toJson() => _$SimplePositionToJson(this);

  @override
  String toString() => 'SimplePosition(latitude: $latitude, longitude: $longitude)';
}