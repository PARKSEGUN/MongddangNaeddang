import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../dataSource/myPageDataSource/getHistory_api.dart';
import '../../../../../model/myPageModel/history_model.dart';

// LineChartSample2 클래스는 라인 차트를 표시하는 StatefulWidget입니다.
class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

// _LineChartSample2State 클래스는 LineChartSample2의 상태를 관리합니다.
class _LineChartSample2State extends State<LineChartSample2> {
  DateTime oneMonthAgo = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  List<HistoryModel> historyData = [];
  bool isLoading = true;
  double maxHistoryDistance = 0.0;
  double minHistoryDistance = 0;
  double yMaxDistance = 0;
  double yMinDistance = 0;
  List<FlSpot> spotsByHistory = [];

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    final container = ProviderContainer();
    final data = await getHistory(container);
    if (data != null) {
      setState(() {
        historyData = data;
        isLoading = false;
        addSpotsByHistory();
        findMaxMinDistance();
        sortSpotsByHistory();
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void addSpotsByHistory() {
    Map<double, double> distanceMap = {}; // 날짜별 거리 합산을 위한 맵

    for (var cur in historyData) {
      print(cur.toJson());
      var endDate = DateTime.parse(cur.endTime);
      if (endDate.isAfter(oneMonthAgo) &&
          endDate.isBefore(DateTime.now().add(Duration(days: 1)))) {
        double daysFromOneMonthAgo =
            endDate.difference(oneMonthAgo).inDays.toDouble();

        // 같은 날짜가 이미 존재하는 경우, 거리 합산
        if (distanceMap.containsKey(daysFromOneMonthAgo)) {
          distanceMap[daysFromOneMonthAgo] =
              (distanceMap[daysFromOneMonthAgo] ?? 0) +
                  cur.distance; // null 체크 후 거리 합산
        } else {
          distanceMap[daysFromOneMonthAgo] = cur.distance; // 새로운 날짜 추가
        }
      }
    }

    // 맵의 값을 기반으로 FlSpot 생성
    spotsByHistory = distanceMap.entries.map((entry) {
      return FlSpot(entry.key, entry.value);
    }).toList();
  }

  void findMaxMinDistance() {
    for (var spot in spotsByHistory) {
      if (minHistoryDistance == 0) {
        minHistoryDistance = spot.y;
      }
      maxHistoryDistance = max(maxHistoryDistance, spot.y);
      minHistoryDistance = min(minHistoryDistance, spot.y);
    }
    yMaxDistance =
        (maxHistoryDistance + maxHistoryDistance * 0.05).toInt().toDouble();
    yMinDistance =
        (minHistoryDistance - maxHistoryDistance * 0.05).toInt().toDouble();
    if (yMinDistance < 0) {
      yMinDistance = 0;
    }
    // print('yMaxDistance');
    // print(yMaxDistance);
    // print('yMinDistance');
    // print(yMinDistance);
  }

  void sortSpotsByHistory() {
    spotsByHistory.sort((a, b) => a.x.compareTo(b.x));
  }

  // 차트의 그라데이션 색상 목록
  List<Color> gradientColors = [Colors.purple, Colors.purpleAccent];

  // 평균 값을 표시할지 여부를 결정하는 변수
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // AspectRatio 위젯은 차트의 비율을 설정합니다.
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            // LineChart 위젯을 사용하여 데이터를 시각화합니다.
            child: LineChart(
              // showAvg ? avgData() : mainData(),
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  // x축의 타이틀을 설정하는 메서드
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    Widget text;

    if (value.toInt() == 5) {
      text = Text(addDay(5), style: style);
    } else if (value.toInt() == 10) {
      text = Text(addDay(10), style: style);
    } else if (value.toInt() == 15) {
      text = Text(addDay(15), style: style);
    } else if (value.toInt() == 20) {
      text = Text(addDay(20), style: style);
    } else if (value.toInt() == 25) {
      text = Text(addDay(25), style: style);
    } else if (value.toInt() == 30) {
      text = Text(addDay(30), style: style);
    } else {
      text = Text('', style: style);
    }

    // 타이틀을 반환합니다.
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  String addDay(int day) {
    return DateFormat('MM.dd').format(oneMonthAgo.add(Duration(days: day)));
  }

  // y축의 타이틀을 설정하는 메서드
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    // yMaxDistance를 변수로 사용하여 if 문으로 비교
    if (value == yMaxDistance) {
      text = yMaxDistance.toInt().toString();
    } else if (value == (yMaxDistance / 4 * 1).toInt()) {
      text = (yMaxDistance / 4 * 1).toInt().toString();
    } else if (value == (yMaxDistance / 4 * 2).toInt()) {
      text = (yMaxDistance / 4 * 2).toInt().toString();
    } else if (value == (yMaxDistance / 4 * 3).toInt()) {
      text = (yMaxDistance / 4 * 3).toInt().toString();
    } else if (value == 0) {
      text = '0';
    } else {
      return Container(); // 다른 경우에는 빈 컨테이너 반환
    }

    // 타이틀을 반환합니다.
    return Text(text, style: style, textAlign: TextAlign.left);
  }

// LineChartData를 생성하는 메서드
  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Color(0xFF544459),
        fitInsideHorizontally: true, // 수평으로 툴팁을 맞춤
        fitInsideVertically: true, // 수직으로 툴팁을 맞춤
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((LineBarSpot spot) {
            String formattedDate = DateFormat('MM.dd')
                .format(oneMonthAgo.add(Duration(days: spot.x.toInt())));

            return LineTooltipItem(
              '달린 날짜: ${formattedDate}\n달린 거리: ${spot.y.toStringAsFixed(2)}',
              TextStyle(color: Color(0xFFE8C2EF)),
            );
          }).toList();
        },
      )),
      // 그리드 데이터 설정
      gridData: FlGridData(
        show: true,
        // 그리드 표시 여부
        drawVerticalLine: true,
        // 수직선 그리기 여부
        horizontalInterval: 1,
        // 수평 그리드 간격
        verticalInterval: 1,
        // 수직 그리드 간격
        // 수평선 설정
        getDrawingHorizontalLine: (value) {
          if (value == yMaxDistance ||
              value == (yMaxDistance / 4 * 1).toInt() ||
              value == (yMaxDistance / 4 * 2).toInt() ||
              value == (yMaxDistance / 4 * 3).toInt() ||
              value == 0) {
            return const FlLine(
              color: Colors.black, // 수평선 색상
              strokeWidth: 0.3, // 수평선 두께
            );
          } else {
            return const FlLine(
              color: Colors.black, // 수평선 색상
              strokeWidth: 0, // 수평선 두께
            );
          }
        },
        // 수직선 설정
        getDrawingVerticalLine: (value) {
          if (value == 0 ||
              value == 5 ||
              value == 10 ||
              value == 15 ||
              value == 20 ||
              value == 25 ||
              value == 30) {
            return const FlLine(
              color: Colors.black, // 수직선 색상
              strokeWidth: 0.3, // 수직선 두께
            );
          } else {
            return const FlLine(
              color: Colors.lightBlue, // 수직선 색상
              strokeWidth: 0, // 수직선 두께
            );
          }
        },
      ),
      // 타이틀 데이터 설정
      titlesData: FlTitlesData(
        show: true,
        // 타이틀 표시 여부
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false), // 오른쪽 타이틀 숨기기
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false), // 상단 타이틀 숨기기
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true, // 하단 타이틀 표시 여부
            reservedSize: 30, // 하단 타이틀을 위한 여유 공간
            interval: 1, // 타이틀 간격
            getTitlesWidget: bottomTitleWidgets, // 하단 타이틀 위젯 설정
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true, // 왼쪽 타이틀 표시 여부
            interval: 1, // 타이틀 간격
            getTitlesWidget: leftTitleWidgets, // 왼쪽 타이틀 위젯 설정
            reservedSize: 42, // 왼쪽 타이틀을 위한 여유 공간
          ),
        ),
      ),
      // 경계 데이터 설정
      borderData: FlBorderData(
        show: true, // 경계 표시 여부
        border: Border(
          left: BorderSide(color: const Color(0xff37434d)), // 왼쪽 경계
          bottom: BorderSide(color: const Color(0xff37434d)), // 아래 경계
        ),
      ),

      minX: 0,
      // x축 최소값
      maxX: 31,
      // x축 최대값
      minY: 0,
      // y축 최소값
      maxY: yMaxDistance,
      // y축 최대값
      // 라인 차트 데이터 설정
      lineBarsData: [
        LineChartBarData(
          spots: spotsByHistory,
          isCurved: false,
          // 곡선 여부
          gradient: LinearGradient(
            colors: gradientColors, // 그래디언트 색상
          ),
          barWidth: 5,
          // 라인 두께
          isStrokeCapRound: true,
          // 라인 끝 모양
          // 점 데이터 설정
          dotData: const FlDotData(
            show: true, // 점 표시 여부
          ),
          // 라인 아래 영역 데이터 설정
          belowBarData: BarAreaData(
            show: true, // 영역 표시 여부
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3)) // 색상 불투명도 조정
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
