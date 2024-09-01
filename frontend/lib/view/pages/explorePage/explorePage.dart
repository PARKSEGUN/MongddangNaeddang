import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/explorePageProvider/explorePage_notifierProvider.dart';
import 'package:frontend/sharedView/navBar.dart';
import 'package:frontend/sharedView/customAppBar.dart';
import 'package:frontend/view/pages/explorePage/startButton.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'endButton.dart';

class ExplorePage extends ConsumerStatefulWidget {
  static const String routeName = 'explore_page';

  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  late final ExplorePageNotifier provider;
  String _locationError = ''; // 에러 메시지를 저장할 변수
  NaverMapController? _mapController; // Add a NaverMapController
  bool _hasExecutedOnce = false; // 카메라 위치가 변경되고 주변 정보를 가져왔는지 확인하는 flag 변수
  bool _isMoving = false; //카메라가 움직이고 있는지 확인할 변수

  // 위젯의 초기 상태를 설정
  @override
  void initState() {
    // initState는 Future<void> 안되고 무조건 그냥 void 여야함. initState에서 ref.watch 사용 불가
    super.initState();
    // provider 설정 + 내 위치 초기화
    provider = ref.read<ExplorePageNotifier>(explorePageNotifierProvider.notifier)..initializePosition();
    _determinePosition(); // 현재 위치 정보 확인
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  // ----------------------------------------위젯 build 시작----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final exploreInfo = ref.watch(explorePageNotifierProvider);


    return Scaffold(
      appBar: CustomAppBar(),
      // body: Text('explore페이지'),
      body: exploreInfo.currentPosition == null // 이상한 위치면
          ? Center(
              child: _locationError.isEmpty
                  ? CircularProgressIndicator() //
                  : Text(_locationError))
          : Stack(
              // 시작 버튼을 네이버 맵 위에 올리기위해 Stack위젯 사용
              children: [
                NaverMap(
                    options: NaverMapViewOptions(
                      initialCameraPosition: NCameraPosition(
                        target: NLatLng(exploreInfo.currentPosition!.latitude,
                            exploreInfo.currentPosition!.longitude),
                        zoom: 17,
                        bearing: 0,
                        tilt: 0,
                      ),
                      mapType: NMapType.basic,
                      activeLayerGroups: [
                        NLayerGroup.building,
                        NLayerGroup.transit
                      ],
                    ),
                    onMapReady: (myMapController) {
                      // 맵 로딩된 후 실행될 함수
                      debugPrint("네이버 맵 로딩됨!");
                      _mapController = myMapController;
                      provider.addMarkerToMap(myMapController); //마커 찍어 주기
                      provider.repeat(
                          myMapController); //n초마다 반복될 녀석 시작(isStart가 true인 경우)
                    },
                    onMapTapped: (point, latLng) {
                      debugPrint("${latLng.latitude}, ${latLng.longitude}");
                    },
                    onCameraChange:
                        (NCameraUpdateReason reason, bool animated) {
                      // 카메라 이동할 때 해줄 것
                      print('onCameraChange 작동 이유 : $reason'); //왜 움직였는지 확인하기
                      // 게임 시작하고 사용자가 맵을 움직인 경우
                      if (!_isMoving && reason == NCameraUpdateReason.gesture) {
                        _isMoving = true;
                        _hasExecutedOnce = false;
                      }
                    },
                    onCameraIdle: () async {
                      //카메라가 이동 후 멈췄을 때
                      // 0. 화면에 표시되는 영역의 경계정보를 가져오지 않았다면 실행
                      _isMoving = false;
                      if (!_hasExecutedOnce) {
                        _hasExecutedOnce = true;
                        try {
                          // 1. 현재 화면에 표시되는 영역의 경계 정보 가져오기
                          final bounds =
                              await _mapController!.getContentBounds();
                          print(bounds);
                          // 2. 경계 정보로부터 네 모서리 좌표 추출
                          final double top = bounds.northLatitude; // 위쪽 위도
                          final double bottom = bounds.southLatitude; // 아래쪽 위도
                          final double left = bounds.westLongitude; // 왼쪽 경도
                          final double right = bounds.eastLongitude; // 오른쪽 경도
                          print('상하좌우 :$top, $bottom, $left, $right');
                          // 3. api 요청 보내서 주변에 땅 정보 있으면 그려주기!
                          provider.getPolygons(_mapController!);
                        } catch (e) {
                          print('-------------------\n정보 가져오기 실패 - 에러: $e');
                        }
                      }
                    }
                    // _currentLocationMarker,
                    ),
                exploreInfo.isStart == true // isStart 상태에 따라 다른 위젯 보여주기
                    // true인경우 EndButton 보여주기
                    ? Positioned(
                        bottom: 50,
                        left: 0,
                        right: 0, // 좌우 중앙 정렬을 위해 left와 right를 0으로 설정
                        child: Align(
                          alignment: Alignment.center, // 중앙 정렬
                          child: EndButton(onPressed: () async {
                            // 종료 버튼 누를 경우
                            // 일단 초기 위치에 가까운지 확인
                            // 1. 가까운 경우
                            if (await provider.checkNearStart()) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('게임 종료'),
                                  content: Text('지금 땅을 획득하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        provider.setIsStart(false); // 빠르게 종료하기 버튼 상태를 변경하기 위함
                                        context.pop();
                                        showAcquiredLandInfo(context, ref); // 땅 얻은 정보 보여주기 -> 이동거리와 게임시간
                                        provider.endGameSuccess(_mapController!); // 게임 종료 로직
                                        provider.resetGameState(); // 게임 정보 초기화
                                      },
                                      child: Text('네'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // '아니오' 버튼을 눌렀을 때의 동작
                                        context.pop();
                                      },
                                      child: Text('아니오'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // 2. 먼 경우
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('게임 종료'),
                                  content: Text(
                                      '지금 종료하실 경우 땅을 획득할 수 없습니다. 시작 지점 근처로 와야 땅을 획득할 수 있습니다. 그래도 종료하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // '네' 버튼을 눌렀을 때의 동작
                                        print('정상 게임 종료 버튼이 눌러 졌음');

                                        provider.setIsStart(false); // 빠르게 종료하기 버튼 상태를 변경하기 위함
                                        Navigator.of(context).pop();
                                        provider.endGameFail(_mapController!);
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: Text('땅 생성 실패'),
                                                  content: Text(
                                                      '시작 위치와 너무 멀어서 땅 생성이 실패하였습니다.'),
                                                ));
                                      },
                                      child: Text('네'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // '아니오' 버튼을 눌렀을 때의 동작
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('아니오'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                      )
                    // false인 경우 StartButton 보여주기
                    : Positioned(
                        bottom: 50,
                        left: 0,
                        right: 0, // 좌우 중앙 정렬을 위해 left와 right를 0으로 설정
                        child: Align(
                          alignment: Alignment.center, // 중앙 정렬
                          child: StartButton(onPressed: ()  {
                            // provider.setIsStart(true);
                            // 게임 시작 메세지 3초간 시작 메시지 보여주기
                             provider.gameStart(_mapController!);
                            // provider.timerCount.cancel();
                          }),
                        ),
                      ),
                Positioned(
                  bottom: 50,
                  left: 10,
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.goMyPosition(_mapController!);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                    ),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors
                              .black87, // Set the color you want the image to tint
                          BlendMode.srcIn, // Apply the color to the image
                        ),
                        child:
                            Image.asset('assets/aim.png', fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
                if (exploreInfo.showStartMessage)
                  Center(
                    child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '땅따먹기 게임 시작!',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '게임 규칙:',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20), // 제목과 내용 사이 간격
                              Text(
                                ' 1. 어디서든 자유롭게 시작하세요.\n'
                                ' 2. 게임 종료 시 빨간 원 안으로!\n'
                                '빨간 원 = 시작 지점 30m 반경\n\n'
                                '준비  됐나요?,',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: '${exploreInfo.count}',
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold,),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: '초 후, 시작됩니다!',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ))
                                  ])),
                            ],
                          ),
                        )),
                  ),

                // Text('쌓인 점들 : ${exploreInfo.path}'), //path 적용 확인용
              ],
            ),
      bottomNavigationBar: NavBar(),
    );
  }

  // ------------------------빌드 끝-------------------------------------
  // ------------------------내부함수-------------------------------------

  Future<void> _determinePosition() async {
    // 현재 위치정보 사용할 수 있는지 확인 함수
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationError = '위치 서비스가 비활성화되었습니다.';
      });
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationError = '위치 권한이 거부되었습니다.';
        });
        await Geolocator.openLocationSettings(); // 위치 권한 설정으로 이동
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationError = '위치 권한이 영구적으로 거부되었습니다. 권한을 요청할 수 없습니다.';
      });
      await Geolocator.openAppSettings(); // 앱 설정으로 이동
      return;
    }
    // 현재위치 초기화
  }
}

void showAcquiredLandInfo(BuildContext context, WidgetRef ref) {
  final exploreInfo = ref.read(explorePageNotifierProvider);
  final distance = exploreInfo.totalDistance;
  final now = DateTime.now();

  // distance 표시 형식 설정
  String distanceDisplay;
  if (distance >= 1000) {
    distanceDisplay = '${(distance / 1000).toStringAsFixed(2)} km';
  } else {
    distanceDisplay = '${distance.toStringAsFixed(0)} m';
  }

  // 시간 형식 설정
  final DateFormat formatter = DateFormat('yyyy년 MM월 dd일 HH시 mm분');
  String startTimeFormatted = formatter.format(exploreInfo.startTime!);
  String endTimeFormatted = formatter.format(now);

  // 게임 시간 계산
  Duration gameDuration = now.difference(exploreInfo.startTime!);
  String gameTimeDisplay =
      '${gameDuration.inHours}시간 ${gameDuration.inMinutes.remainder(60)}분';

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('땅 획득 성공!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이동거리 : $distanceDisplay'),
          // Text('시작시간 : $startTimeFormatted'),
          // Text('끝난시간 : $endTimeFormatted'),
          Text('게임 시간 : $gameTimeDisplay'),
          // 기타 필요한 정보 추가
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('확인'),
        ),
      ],
    ),
  );
}
