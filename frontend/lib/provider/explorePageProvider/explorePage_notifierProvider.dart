import 'dart:async';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:frontend/dataSource/api_url.dart';
import 'package:frontend/model/explorePageModel/region_model.dart';
import 'package:frontend/secureStroage/token_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:frontend/model/explorePageModel/exploreInfo_model.dart';
import 'package:frontend/model/explorePageModel/simplePosition_model.dart';
import 'package:geolocator/geolocator.dart';

part 'explorePage_notifierProvider.g.dart';

const double _goalRadius = 25; //goalRadius 만큼 시작점과 이동해야 게임 종료 가능
const double _moveDistance = 1; //moveDistance 만큼 이전 위치와 차이나야 변경됨

@Riverpod(keepAlive: true)
class ExplorePageNotifier extends _$ExplorePageNotifier {
  final Dio _dio = Dio(); // Dio 인스턴스 생성
  static const LocationAccuracy _desiredAccuracy =
      LocationAccuracy.high; // 위치 정확도 설정
  NMarker? _currentMarker; // 현재 위치 마커
  int _pathCount = 0; // 경로 카운트 (고유 ID 생성용)
  late final timerCount;

  // 초기 상태
  @override
  ExploreInfoModel build() {
    return ExploreInfoModel(
      isStart: false,
      currentPosition: null,
      firstPosition: null,
      prevPosition: null,
      startTime: null,
      path: [],
      totalDistance: 0,
      showStartMessage: false,
      count: 3,
    );
  }

  /// 초기 위치 설정
  Future<void> initializePosition() async {
    // 게임이 시작이 안된 경우에만 위치 설정
    if (state.isStart == false) {
      final currentPosition = await _getCurrentSimplePosition(); //지금 위치 받아오기
      // 게임이 시작 안된 경우
      state = ExploreInfoModel(
        isStart: state.isStart,
        currentPosition: currentPosition,
        firstPosition: currentPosition,
        prevPosition: currentPosition,
        startTime: DateTime.now(),
        path: [],
        showStartMessage: state.showStartMessage,
        count: 3,
      );
    }
  }

  /// 게임 시작 버튼 눌렀을 때 이뤄질 함수 -> 초기 값 변경, 시작점 위치를 원으로 나타내기, n초마다 반복될 함수 시작
  Future<void> gameStart(NaverMapController mapController) async {
    // 초기 값들 초기화 시켜주기
    if (state.isStart == false) {
      setIsStart(true);
      showStartMessage();
    }
    startInit();
    // 시작 점을 원으로 그려줄 메서드
    drawStartCircle(mapController);
    repeat(mapController); //n초 마다 반복될 일들이 적힌 함수
  }

  /// 3초간 시작메시지 보여주기 + CountDown
  Future<void> showStartMessage() async {
    state = state.copyWith(
      showStartMessage: true,
    );

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.count > 0) {
        state = state.copyWith(
          count: state.count - 1,
        );
      } else {
        // 시작 메시지 보여주기 끝!
        state = state.copyWith(
          showStartMessage: false,
        );
        timer.cancel();
      }
    });
  }

  /// 게임 상태 변경
  void setIsStart(bool isStart) {
    state = state.copyWith(isStart: isStart);
  }

  /// 시작 위치를 나타내줄 원 생성
  Future<void> drawStartCircle(NaverMapController mapController) async {
    final circle = NCircleOverlay(
      id: 'startCircle_${_pathCount}',
      center: NLatLng(
          state.firstPosition!.latitude, state.firstPosition!.longitude),
      radius: _goalRadius,
      // 게임 완료 가능한 반경
      color: Colors.red.withOpacity(0.5),
      outlineColor: Colors.red,
      outlineWidth: 2,
    );
    mapController.addOverlay(circle);
  }

  /// 2초마다 반복이 될 함수 (위치 정보 가져오고 그려주기)
  Future<void> repeat(NaverMapController mapController) async {
    if (state.isStart) {
      // 게임이 시작된 경우에만 반복합시다.
      Timer.periodic(Duration(seconds: 2), (timer) async {
        if (!state.isStart) {
          timer.cancel(); // 타이머 끄기
          mapController.clearOverlays(
              type: NOverlayType.pathOverlay); // 맵에 있는 이동 경로를 삭제해주는 로직
          mapController.clearOverlays(type: NOverlayType.polygonOverlay);
          return;
        }
        // 3m이상 떨어 졌는지 확인하기
        final isChange = await checkPositionChange();
        if (isChange) {
          // 3m 이상 떨어졌다면 위치를 업데이트하기
          updatePosition(mapController);
          print('위치 업데이트 되었음');
          // 이전 위치와 현재위치 사이를 그려주는 로직
        }
      });
    }
  }

  /// 게임 시작할 때, state 초기화 시켜줄 코드
  Future<void> startInit() async {
    SimplePosition nowPosition = await _getCurrentSimplePosition();
    state = ExploreInfoModel(
        isStart: true,
        currentPosition: state.currentPosition ?? nowPosition,
        firstPosition: state.firstPosition ?? nowPosition,
        prevPosition: state.prevPosition ?? nowPosition,
        startTime: state.startTime ?? DateTime.now(),
        path: state.path ?? [nowPosition],
        showStartMessage: state.showStartMessage,
        count: 3);
  }

  /// 현재 위치 업데이트 및 경로 그리기
  Future<void> updatePosition(NaverMapController mapController) async {
    SimplePosition newPosition = await _getCurrentSimplePosition();
    double distance = _calculateDistance(state.currentPosition!, newPosition);
    // 이전 위치와 현재 위치 사이의 경로 그리기
    if (state.prevPosition != null) {
      // NPolylineOverlay or NPathOverlay 로 경로 그려주기
      final path = NPolylineOverlay(
        id: "myPath_${_pathCount++}",
        coords: [
          NLatLng(state.prevPosition!.latitude, state.prevPosition!.longitude),
          NLatLng(newPosition.latitude, newPosition.longitude),
        ],
        color: Color(0xff6d0ecd),
        width: 6,
      );
      await mapController.addOverlay(path);
    }

    // 상태 업데이트
    state = state.copyWith(
      currentPosition: newPosition,
      prevPosition: state.currentPosition,
      totalDistance: state.totalDistance + distance,
      path: [...state.path ?? [], newPosition],
    );
    List<SimplePosition>? tmp = state.path;
    for (int i = 0; i < tmp!.length; i++) {
      print("longitude: ${tmp[i].longitude} / latitude: ${tmp[i].latitude}");
    }
    // 현재 위치 마커 업데이트
    await _updateMarker(newPosition, mapController);
  }

  /// 위치 변경 확인 (10m 이상 이동했는지)
  Future<bool> checkPositionChange() async {
    SimplePosition newPosition = await _getCurrentSimplePosition();
    double distance = _calculateDistance(state.prevPosition!, newPosition);
    return distance >= _moveDistance;
  }

  /// 초기 위치와 가까운지 확인
  Future<bool> checkNearStart() async {
    SimplePosition newPosition = await _getCurrentSimplePosition();
    double distance = _calculateDistance(state.firstPosition!, newPosition);
    if (distance <= _goalRadius) {
      return true; // goalRadius m 미만이면 true반환
    } else {
      return false; // 아니면 false 반환
    }
  }

  /// 초기 위치 근처에서 게임 종료
  Future<void> endGameSuccess(NaverMapController mapController) async {
    List<List<double>> pathData = state.path!
        .map((position) => [position.latitude, position.longitude])
        .toList();
    pathData.add([
      state.firstPosition!.latitude,
      state.firstPosition!.longitude
    ]); // 초기 위치를 마지막에 넣어줘야하므로 추가
    await _sendPathData(pathData);
    // 게임 상태 초기화 코드가 있었으나 잠시 사용해야해서 나중에 넣음
    resetGameState();
    //Polyline과 원 삭제해주기
    mapController.clearOverlays(type: NOverlayType.polylineOverlay);
    mapController.clearOverlays(type: NOverlayType.circleOverlay);
    getPolygons(mapController); // 게임 끝나고 내가 만든 영역도 보여줘야 하니까
  }

  /// 초기 위치에서 멀어졌을 때, 게임 종료
  Future<void> endGameFail(NaverMapController mapController) async {
    resetGameState();
    mapController.clearOverlays(type: NOverlayType.polylineOverlay);
  }

  /// 경로 데이터 서버로 전송
  Future<void> _sendPathData(List<List<double>> pathData) async {
    UserSecureStorage storage = UserSecureStorage();
    final authUuid = await storage.readAuthUuid();
    print('-------------------------------------------');
    for (int i = 0; i < pathData.length; i++) {
      print('${pathData[i][0]} / ${pathData[i][1]}');
    }
    try {
      final response = await _dio.post(
        '$url/api/game/finish',
        data: {
          'authUuid': authUuid, // 필요하다면 'kakao_' + authUuid로 수정
          'multipoints': pathData,
          'startTime': state.startTime!.toIso8601String(),
          'endTime': DateTime.now().toIso8601String(),
        },
      );
      if (response.statusCode == 201) {
        print('땅 생성 성공! : ${response.data}');
      } else {
        print('path 데이터 전송 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('path 데이터 전송 중 에러 발생: $e');
    }
  }

  /// 게임 상태 초기화
  Future<void> resetGameState() async {
    SimplePosition nowPosition = await _getCurrentSimplePosition();
    state = ExploreInfoModel(
        isStart: false,
        currentPosition: nowPosition,
        firstPosition: null,
        prevPosition: null,
        startTime: null,
        path: [],
        showStartMessage: state.showStartMessage);
  }

  /// 지정된 영역의 폴리곤 정보 가져오기
  Future<void> getPolygons(NaverMapController mapController) async {
    final bounds = await mapController.getContentBounds();
    print(bounds);
    // 2. 경계 정보로부터 네 모서리 좌표 추출
    final double top = bounds.northLatitude; // 위쪽 위도
    final double bottom = bounds.southLatitude; // 아래쪽 위도
    final double left = bounds.westLongitude; // 왼쪽 경도
    final double right = bounds.eastLongitude; // 오른쪽 경도
    final body = {
      'leftTop': [top, left],
      'rightTop': [top, right],
      'leftBottom': [bottom, left],
      'rightBottom': [bottom, right]
    };
    try {
      final response = await _dio.post('$url/api/redis/map', data: body);
      // print(response.data);
      if (response.data is List) {
        List<Region> regionList = (response.data as List)
            .map((item) => Region.fromJson(item))
            .toList();
        for (var region in regionList) {
          if (region.area.length == 1) {
            _addPolygonToMap(region, mapController);
          } else if (region.area.length >= 2) {
            _addHolePolygonToMap(region, mapController);
          }
        }
        print('총 Region 수: ${regionList.length}');
      } else {
        print('예상치 못한 데이터 형식: ${response.data}');
      }
    } catch (e) {
      print('백엔드로 폴리곤 정보 가져오기 오류: $e');
    }
  }

  /// 구멍 안뚫린 폴리곤을 지도에 추가
  void _addPolygonToMap(Region region, NaverMapController controller) {
    // '#' 문자 제거
    String cleanString = region.color.replaceAll('#', '');
    // 알파 채널이 없으면 'FF'를 추가 (완전 불투명)
    if (cleanString.length == 6) {
      cleanString = 'FF' + cleanString;
    }
    final colorCode = int.parse('0x$cleanString');

    final polygon = NPolygonOverlay(
      id: '${region.teamId}_${region.id}',
      coords: region.area[0].map((pos) => NLatLng(pos[0]!, pos[1]!)).toList(),
      color: Color(colorCode).withOpacity(0.2),
      outlineColor: Color(colorCode),
      outlineWidth: 3,
    );
    controller.addOverlay(polygon);
  }

  /// 구멍 뚫린 폴리곤 추가
  void _addHolePolygonToMap(Region region, NaverMapController controller) {
    // '#' 문자 제거
    String cleanString = region.color.replaceAll('#', '');
    // 알파 채널이 없으면 'FF'를 추가 (완전 불투명)
    if (cleanString.length == 6) {
      cleanString = 'FF' + cleanString;
    }
    final colorCode = int.parse('0x$cleanString');

    final holes = region.area
        .sublist(1)
        .map((holeCoords) =>
            holeCoords.map((pos) => NLatLng(pos[0]!, pos[1]!)).toList())
        .toList();

    final polygon = NPolygonOverlay(
      id: '${region.teamId}_${region.id}',
      coords: region.area[0].map((pos) => NLatLng(pos[0]!, pos[1]!)).toList(),
      color: Color(colorCode).withOpacity(0.2),
      outlineColor: Color(colorCode),
      outlineWidth: 3,
      holes: holes,
    );

    controller.addOverlay(polygon);
  }

  // 현재 위치 마커 추가 + 시작점에 대한 마커 추가
  Future<void> addMarkerToMap(NaverMapController controller) async {
    // 현재 위치에 대한 마커
    _currentMarker = NMarker(
      id: 'current_position_marker',
      position: NLatLng(
          state.currentPosition!.latitude, state.currentPosition!.longitude),
    );
    // 시작점을 보여줄 원
    await controller.addOverlayAll({_currentMarker!});
    if (state.isStart) {
      // 게임이 시작된 경우 이전 path 그려주기
      _updateAllPath(controller);
    }
  }

  // 현재 위치 마커 업데이트
  Future<void> _updateMarker(
      SimplePosition position, NaverMapController controller) async {
    if (_currentMarker != null) {
      _currentMarker!.setPosition(NLatLng(
          state.currentPosition!.latitude, state.currentPosition!.longitude));
    } else {
      await addMarkerToMap(controller);
    }
  }

  /// 현재 위치 가져오기
  Future<SimplePosition> _getCurrentSimplePosition() async {
    Position position =
        await Geolocator.getCurrentPosition(desiredAccuracy: _desiredAccuracy);
    return SimplePosition(
        latitude: position.latitude, longitude: position.longitude);
  }

  /// 페이지 이동했을 때, 경로가 사라지는데 다시 그려주는 메서드임 + 초기 원도 그려주기
  Future<void> _updateAllPath(NaverMapController mapController) async {
    drawStartCircle(mapController);
    final pathList = state.path;
    if (pathList != null) {
      List<NLatLng> coords = pathList
          .map((point) => NLatLng(point.latitude, point.longitude))
          .toList();
      final AllPath = NPolylineOverlay(
        id: "myPath_${_pathCount++}",
        coords: coords,
        color: Color(0xff6d0ecd),
        width: 6,
      );
      await mapController.addOverlay(AllPath);
    }
  }

  /// 현재 내 위치로 카메라를 이동시키는 메서드
  void goMyPosition(NaverMapController mapController) {
    final cameraUpdate = NCameraUpdate.withParams(
      target: NLatLng(
          state.currentPosition!.latitude, state.currentPosition!.longitude),
      zoom: 17,
      // bearing: , //이거는 방향
    );
    mapController.updateCamera(cameraUpdate);
  }
}

/// 두 위치 사이의 거리 계산
double _calculateDistance(SimplePosition pos1, SimplePosition pos2) {
  return Geolocator.distanceBetween(
      pos1.latitude, pos1.longitude, pos2.latitude, pos2.longitude);
}
