import 'package:frontend/model/explorePageModel/simplePosition_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exploreInfo_model.g.dart';

@JsonSerializable()
class ExploreInfoModel {
  final bool isStart;                       // 게임 시작 여부
  final SimplePosition? currentPosition;     // 현재 위치
  final SimplePosition? firstPosition;       // 처음 시작 위치
  final SimplePosition? prevPosition;        // 직전의 위치
  final DateTime? startTime;                 // 탐험 시작 시간
  final DateTime? endTime;                  // 탐험 종료 시간 (null일 경우 아직 진행 중)
  final double totalDistance;               // 총 이동 거리 (미터 단위)
  final List<SimplePosition>? path;         // 이동한 경로들의 리스트
  final bool showStartMessage;              // 스타트메시지 보여줬는지 나타내는 변수
  final int count;                          // 시작까지 남은 시간초

  ExploreInfoModel({
    required this.isStart,
    this.currentPosition,
    this.firstPosition,
    this.prevPosition,
    this.startTime,
    this.path,
    this.endTime,
    this.totalDistance = 0.0,
    required this.showStartMessage,
    this.count = 3,
  });

  ExploreInfoModel copyWith({
    bool? isStart,
    SimplePosition? currentPosition,
    SimplePosition? firstPosition,
    SimplePosition? prevPosition,
    DateTime? startTime,
    List<SimplePosition>? path,
    double? totalDistance,
    bool? showStartMessage,
    int? count,
  }) {
    return ExploreInfoModel(
      isStart: isStart ?? this.isStart,
      currentPosition: currentPosition ?? this.currentPosition,
      firstPosition: firstPosition ?? this.firstPosition,
      prevPosition: prevPosition ?? this.prevPosition,
      startTime: startTime ?? this.startTime,
      path: path ?? this.path,
      totalDistance: totalDistance ?? this.totalDistance,
      showStartMessage: showStartMessage ?? this.showStartMessage,
      count : count ?? this.count,
    );


    }
}