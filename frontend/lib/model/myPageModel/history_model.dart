import 'package:json_annotation/json_annotation.dart';

part 'history_model.g.dart';

@JsonSerializable()
class HistoryModel {
  final double distance;
  final String startTime;
  final String endTime;

  HistoryModel({
    required this.distance,
    required this.startTime, // nullable로 유지
    required this.endTime, // nullable로 유지
  });

  // JSON 데이터를 User 객체로 변환하는 factory constructor
  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);

  // User 객체를 JSON 형식으로 변환하는 메서드
  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);
}
